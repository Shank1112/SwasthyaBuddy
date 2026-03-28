package com.swasthyabuddy.servlets;

import java.io.*;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import com.swasthyabuddy.model.Prediction;
import com.swasthyabuddy.model.User;

import jakarta.servlet.AsyncContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * SSEServlet — Server-Sent Events for SwasthyaBuddy
 * ───────────────────────────────────────────────────
 * Doctor dashboard connects to GET /SSEServlet and keeps
 * the connection open. When PredictServlet calls
 * SSEServlet.broadcastAlert(...), all connected doctors
 * receive an instant alert card.
 */
@WebServlet(urlPatterns = "/SSEServlet", asyncSupported = true)
public class SSEServlet extends HttpServlet {

    // ── Thread-safe list of all open SSE connections (one per doctor tab)
    private static final CopyOnWriteArrayList<AsyncContext> clients =
            new CopyOnWriteArrayList<>();

    // ════════════════════════════════════════════════════
    //  GET  — doctor dashboard connects here
    // ════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ── Auth check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // ── SSE response headers
        res.setContentType("text/event-stream");
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Cache-Control",     "no-cache");
        res.setHeader("Connection",        "keep-alive");
        res.setHeader("X-Accel-Buffering", "no");

        // ── Send initial comment to confirm connection
        PrintWriter writer = res.getWriter();
        writer.write(": SwasthyaBuddy SSE connected\n\n");
        writer.flush();

        // ── Start async context (keeps HTTP connection open)
        AsyncContext asyncCtx = req.startAsync();
        asyncCtx.setTimeout(0); // 0 = no timeout

        // ── Register this connection
        clients.add(asyncCtx);

        // ── Clean up on disconnect
        asyncCtx.addListener(new jakarta.servlet.AsyncListener() {
            @Override public void onComplete (jakarta.servlet.AsyncEvent e) { clients.remove(asyncCtx); }
            @Override public void onTimeout  (jakarta.servlet.AsyncEvent e) { clients.remove(asyncCtx); asyncCtx.complete(); }
            @Override public void onError    (jakarta.servlet.AsyncEvent e) { clients.remove(asyncCtx); }
            @Override public void onStartAsync(jakarta.servlet.AsyncEvent e) {}
        });
    }

    // ════════════════════════════════════════════════════
    //  BROADCAST  — called by PredictServlet
    // ════════════════════════════════════════════════════
    public static void broadcastAlert(User patient, String symptoms,
                                       List<Prediction> predictions) {

        if (clients.isEmpty()) return;

        String json       = buildAlertJson(patient, symptoms, predictions);
        String sseMessage = "event: newPrediction\ndata: " + json + "\n\n";

        for (AsyncContext ctx : clients) {
            try {
                PrintWriter writer = ctx.getResponse().getWriter();
                writer.write(sseMessage);
                writer.flush();
                if (writer.checkError()) {
                    clients.remove(ctx);
                    try { ctx.complete(); } catch (Exception ignored) {}
                }
            } catch (IOException | IllegalStateException e) {
                clients.remove(ctx);
                try { ctx.complete(); } catch (Exception ignored) {}
            }
        }
    }

    // ════════════════════════════════════════════════════
    //  BUILD JSON ALERT PAYLOAD
    // ════════════════════════════════════════════════════
    private static String buildAlertJson(User patient, String symptoms,
                                          List<Prediction> predictions) {

        String timestamp = new java.text.SimpleDateFormat("dd-MMM-yyyy HH:mm:ss")
                .format(new java.util.Date());

        // ✅ FIXED: User has no getName() — using getFirstName() + getLastName()
        String patientName = (patient.getFirstName() + " " + patient.getLastName()).trim();

        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"patientName\":")  .append(jsonStr(patientName))        .append(",");
        sb.append("\"patientId\":")    .append(patient.getId())              .append(",");
        sb.append("\"symptoms\":")     .append(jsonStr(symptoms))            .append(",");
        sb.append("\"timestamp\":")    .append(jsonStr(timestamp))           .append(",");
        sb.append("\"predictions\":[");

        for (int i = 0; i < predictions.size(); i++) {
            Prediction p = predictions.get(i);
            sb.append("{");
            sb.append("\"disease\":")    .append(jsonStr(p.getName()))        .append(",");
            sb.append("\"confidence\":") .append(p.getConfidence())           .append(",");
            sb.append("\"description\":").append(jsonStr(p.getDescription())) .append(",");
            sb.append("\"precautions\":[");
            List<String> precs = p.getPrecautions();
            if (precs != null) {
                for (int j = 0; j < precs.size(); j++) {
                    sb.append(jsonStr(precs.get(j)));
                    if (j < precs.size() - 1) sb.append(",");
                }
            }
            sb.append("]}");
            if (i < predictions.size() - 1) sb.append(",");
        }

        sb.append("]}");
        return sb.toString();
    }

    private static String jsonStr(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r")
                + "\"";
    }

    public static int getConnectedDoctorCount() {
        return clients.size();
    }
}
