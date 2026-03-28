package com.swasthyabuddy.servlets;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import com.swasthyabuddy.model.Prediction;
import com.swasthyabuddy.model.User;
import com.swasthyabuddy.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PredictionServlet")
public class PredictServlet extends HttpServlet {

    // ── Live Flask ML API on Render.com (Anant's deployment)
    private static final String FLASK_URL = "https://swasthyabuddy.onrender.com/predict";

    // ── 60 seconds — required for Render free-tier cold start
    private static final int CONNECT_TIMEOUT_MS = 60_000;
    private static final int READ_TIMEOUT_MS    = 60_000;

    // ════════════════════════════════════════════════════
    //  doPost — entry point
    // ════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ── Auth check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        User   user        = (User) session.getAttribute("user");
        String symptomsRaw = req.getParameter("symptoms"); // e.g. "fever,headache,cough"

        if (symptomsRaw == null || symptomsRaw.trim().isEmpty()) {
            res.sendRedirect("patient-dashboard.jsp");
            return;
        }

        String symptoms = symptomsRaw.trim();

        try {
            // ── 1. Call Flask ML API (60 s timeout for Render cold start)
            List<Prediction> predictions = callFlaskAPI(symptoms);

            // ── 2. Persist to Oracle XE
            savePrediction(user.getId(), symptoms, predictions);

            // ── 3. Store in session so result.jsp can read them
            session.setAttribute("predictions",  predictions);
            session.setAttribute("lastSymptoms", symptoms);

            // ── 4. Broadcast SSE alert to all connected doctor dashboards
            SSEServlet.broadcastAlert(user, symptoms, predictions);

            // ── 5. Redirect to result page
            res.sendRedirect("result.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Prediction failed: " + e.getMessage());
            req.getRequestDispatcher("patient-dashboard.jsp").forward(req, res);
        }
    }

    // ════════════════════════════════════════════════════
    //  CALL FLASK /predict API
    //  POST {"symptoms": "fever,headache,cough"}
    //  Handles Render 60 s cold-start gracefully
    // ════════════════════════════════════════════════════
    private List<Prediction> callFlaskAPI(String symptoms) throws Exception {

        URL url = new URL(FLASK_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept",       "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(CONNECT_TIMEOUT_MS); // 60 s — Render cold start
            conn.setReadTimeout(READ_TIMEOUT_MS);       // 60 s — model inference

            // Build request body
            String jsonBody = "{\"symptoms\": \"" + escapeJson(symptoms) + "\"}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read full response
                StringBuilder sb = new StringBuilder();
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line);
                }
                return parseFlaskResponse(sb.toString());

            } else {
                // Read error stream for logging
                StringBuilder errSb = new StringBuilder();
                InputStream errStream = conn.getErrorStream();
                if (errStream != null) {
                    try (BufferedReader br = new BufferedReader(
                            new InputStreamReader(errStream, "UTF-8"))) {
                        String line;
                        while ((line = br.readLine()) != null) errSb.append(line);
                    }
                }
                System.err.println("[SwasthyaBuddy] Flask API returned HTTP "
                        + responseCode + ": " + errSb);
                return getFallbackPredictions(symptoms);
            }

        } finally {
            conn.disconnect();
        }
    }

    // ════════════════════════════════════════════════════
    //  JSON PARSER  (no external library — pure Java)
    //
    //  Parses Flask response:
    //  {
    //    "status": "success",
    //    "predictions": [
    //      {
    //        "disease":     "Viral Fever",
    //        "confidence":  78,
    //        "description": "...",
    //        "precautions": ["Rest", "Stay hydrated"]
    //      }, ...
    //    ]
    //  }
    // ════════════════════════════════════════════════════
    private List<Prediction> parseFlaskResponse(String json) {
        List<Prediction> list = new ArrayList<>();
        try {
            // Locate the predictions array [ ... ]
            int arrStart = json.indexOf("[");
            int arrEnd   = json.lastIndexOf("]");
            if (arrStart == -1 || arrEnd == -1) return getFallbackPredictions("");

            String arr = json.substring(arrStart + 1, arrEnd).trim();

            // Split individual objects — each object is between { and }
            // We walk character-by-character to handle nested arrays properly
            List<String> objects = splitJsonObjects(arr);

            for (String obj : objects) {
                try {
                    String       disease     = extractJsonString(obj, "disease");
                    int          confidence  = extractJsonInt   (obj, "confidence");
                    String       description = extractJsonString(obj, "description");
                    List<String> precautions = extractJsonArray (obj, "precautions");

                    if (!disease.isEmpty()) {
                        Prediction p = new Prediction(disease, confidence, description);
                        p.setPrecautions(precautions);
                        list.add(p);
                    }
                    if (list.size() == 3) break; // top-3 only
                } catch (Exception inner) {
                    System.err.println("[SwasthyaBuddy] Skipping malformed prediction entry: "
                            + inner.getMessage());
                }
            }

        } catch (Exception e) {
            System.err.println("[SwasthyaBuddy] JSON parse error: " + e.getMessage());
        }

        return list.isEmpty() ? getFallbackPredictions("") : list;
    }

    /**
     * Splits a JSON array body (content between outer [ and ])
     * into individual object strings, respecting nested { } and [ ].
     */
    private List<String> splitJsonObjects(String arrayContent) {
        List<String> objects = new ArrayList<>();
        int depth = 0;
        int start = -1;

        for (int i = 0; i < arrayContent.length(); i++) {
            char c = arrayContent.charAt(i);
            if (c == '{') {
                if (depth == 0) start = i;
                depth++;
            } else if (c == '}') {
                depth--;
                if (depth == 0 && start != -1) {
                    objects.add(arrayContent.substring(start + 1, i)); // content inside { }
                    start = -1;
                }
            }
        }
        return objects;
    }

    /** Extract a JSON string value for a given key. */
    private String extractJsonString(String json, String key) {
        String search = "\"" + key + "\"";
        int keyIdx = json.indexOf(search);
        if (keyIdx == -1) return "";

        int colon = json.indexOf(":", keyIdx + search.length());
        if (colon == -1) return "";

        // Find the opening quote
        int quoteOpen = json.indexOf("\"", colon + 1);
        if (quoteOpen == -1) return "";

        // Find the closing quote (skip escaped quotes)
        int quoteClose = quoteOpen + 1;
        while (quoteClose < json.length()) {
            if (json.charAt(quoteClose) == '"' && json.charAt(quoteClose - 1) != '\\') break;
            quoteClose++;
        }
        return json.substring(quoteOpen + 1, quoteClose);
    }

    /** Extract a JSON integer value for a given key. */
    private int extractJsonInt(String json, String key) {
        String search = "\"" + key + "\"";
        int keyIdx = json.indexOf(search);
        if (keyIdx == -1) return 0;

        int colon = json.indexOf(":", keyIdx + search.length());
        if (colon == -1) return 0;

        // Grab until next comma or closing brace
        int end = colon + 1;
        while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}') end++;

        String val = json.substring(colon + 1, end).trim().replaceAll("[^0-9.]", "");
        if (val.isEmpty()) return 0;
        // Flask may send confidence as a decimal (e.g. 3.6 meaning 36%, or 0.78 meaning 78%)
        // OR as a plain integer (e.g. 78). Normalise everything to 0–100.
        double raw = Double.parseDouble(val);
        if (raw <= 1.0)   raw = raw * 100;   // 0.0–1.0  → percentage  (e.g. 0.78 → 78)
        if (raw > 100.0)  raw = raw / 10.0;  // 360, 240 → 36, 24      (e.g. 360  → 36)
        return (int) Math.min(100, Math.round(raw));
    }

    /**
     * Extract a JSON string array for a given key.
     * e.g. "precautions": ["Rest", "Stay hydrated"]  →  ["Rest", "Stay hydrated"]
     */
    private List<String> extractJsonArray(String json, String key) {
        List<String> result = new ArrayList<>();
        String search = "\"" + key + "\"";
        int keyIdx = json.indexOf(search);
        if (keyIdx == -1) return result;

        int arrOpen  = json.indexOf("[", keyIdx + search.length());
        int arrClose = json.indexOf("]", arrOpen + 1);
        if (arrOpen == -1 || arrClose == -1) return result;

        String arrContent = json.substring(arrOpen + 1, arrClose);
        // Each element is a quoted string
        int pos = 0;
        while (pos < arrContent.length()) {
            int q1 = arrContent.indexOf("\"", pos);
            if (q1 == -1) break;
            int q2 = q1 + 1;
            while (q2 < arrContent.length()) {
                if (arrContent.charAt(q2) == '"' && arrContent.charAt(q2 - 1) != '\\') break;
                q2++;
            }
            result.add(arrContent.substring(q1 + 1, q2));
            pos = q2 + 1;
        }
        return result;
    }

    /** Escape special characters in symptoms string for safe JSON embedding. */
    private String escapeJson(String input) {
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }

    // ════════════════════════════════════════════════════
    //  FALLBACK  (used when Flask is offline / cold-starting)
    // ════════════════════════════════════════════════════
    private List<Prediction> getFallbackPredictions(String symptoms) {
        List<Prediction> list = new ArrayList<>();

        Prediction p1 = new Prediction("Viral Fever", 78,
            "Caused by viral infection. Characterized by high temperature, fatigue, and body aches.");
        p1.setPrecautions(List.of("Rest", "Stay hydrated", "Take paracetamol", "Avoid cold drinks"));

        Prediction p2 = new Prediction("Influenza", 54,
            "Flu virus causing fever, chills, muscle aches, and respiratory symptoms.");
        p2.setPrecautions(List.of("Rest", "Drink warm fluids", "Use antiviral medication", "Avoid crowded places"));

        Prediction p3 = new Prediction("Common Cold", 31,
            "Mild upper respiratory infection with runny nose and sore throat.");
        p3.setPrecautions(List.of("Gargle with warm salt water", "Steam inhalation", "Vitamin C intake", "Rest"));

        list.add(p1);
        list.add(p2);
        list.add(p3);
        return list;
    }

    // ════════════════════════════════════════════════════
    //  SAVE TO ORACLE XE  (via DBUtil — DriverManager)
    //  Table: swasthya_predictions
    //  Sequence: predictions_seq
    // ════════════════════════════════════════════════════
    private void savePrediction(int userId, String symptoms, List<Prediction> preds) {
        Connection con = null;
        try {
            con = DBUtil.getConnection();

            String sql =
                "INSERT INTO swasthya_predictions " +
                "  (id, user_id, symptoms, " +
                "   disease1, confidence1, description1, " +
                "   disease2, confidence2, description2, " +
                "   disease3, confidence3, description3, " +
                "   created_at) " +
                "VALUES " +
                "  (predictions_seq.NEXTVAL, ?, ?, " +
                "   ?, ?, ?, " +
                "   ?, ?, ?, " +
                "   ?, ?, ?, " +
                "   SYSDATE)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt   (1,  userId);
                ps.setString(2,  symptoms);

                // Disease 1
                ps.setString(3,  get(preds, 0, "name"));
                ps.setInt   (4,  getConf(preds, 0));
                ps.setString(5,  get(preds, 0, "desc"));

                // Disease 2
                ps.setString(6,  get(preds, 1, "name"));
                ps.setInt   (7,  getConf(preds, 1));
                ps.setString(8,  get(preds, 1, "desc"));

                // Disease 3
                ps.setString(9,  get(preds, 2, "name"));
                ps.setInt   (10, getConf(preds, 2));
                ps.setString(11, get(preds, 2, "desc"));

                ps.executeUpdate();
            }

        } catch (Exception e) {
            System.err.println("[SwasthyaBuddy] DB save failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
        }
    }

    // Helper methods to safely read from predictions list
    private String get(List<Prediction> list, int i, String field) {
        if (list.size() <= i) return "";
        return "name".equals(field) ? list.get(i).getName() : list.get(i).getDescription();
    }

    private int getConf(List<Prediction> list, int i) {
        return list.size() > i ? list.get(i).getConfidence() : 0;
    }
}
