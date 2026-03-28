package com.swasthyabuddy.servlets;

import com.swasthyabuddy.util.DBUtil;
import com.swasthyabuddy.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/HistoryServlet")
public class HistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        Connection con = null;
        try {
            con = DBUtil.getConnection();

            // Use the actual column names from Anant's DB schema
            String sql =
                "SELECT id, symptoms, predicted_disease, " +
                "confidence_svm, confidence_dt, created_at " +
                "FROM predictions " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            List<Map<String, String>> history = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("id",        String.valueOf(rs.getInt("id")));
                row.put("symptoms",  rs.getString("symptoms"));
                row.put("disease",   rs.getString("predicted_disease"));
                row.put("confSvm",   String.valueOf(rs.getDouble("confidence_svm")));
                row.put("confDt",    String.valueOf(rs.getDouble("confidence_dt")));
                row.put("createdAt", rs.getString("created_at"));
                history.add(row);
            }

            session.setAttribute("predictionHistory", history);
            req.getRequestDispatcher("history.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load history: " + e.getMessage());
            req.getRequestDispatcher("history.jsp").forward(req, resp);
        } finally {
            DBUtil.closeConnection(con);
        }
    }
}
