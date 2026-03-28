package com.swasthyabuddy.servlets;

import com.swasthyabuddy.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.sql.*;

@WebServlet("/MedicineServlet")
public class MedicineServlet extends HttpServlet {

    // GET  → redirect to medicines.jsp (session check)
    // POST → place order, save to DB
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        resp.sendRedirect("medicines.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        com.swasthyabuddy.model.User user =
            (com.swasthyabuddy.model.User) session.getAttribute("user");

        String action = req.getParameter("action");

        if ("placeOrder".equals(action)) {
            placeOrder(req, resp, user);
        } else {
            resp.sendRedirect("medicines.jsp");
        }
    }

    // ════════════════════════════════════
    //  PLACE ORDER
    // ════════════════════════════════════
    private void placeOrder(HttpServletRequest req,
                             HttpServletResponse resp,
                             com.swasthyabuddy.model.User user)
            throws IOException {

        String medicineIdStr = req.getParameter("medicineId");
        String quantityStr   = req.getParameter("quantity");
        String totalStr      = req.getParameter("totalPrice");

        if (medicineIdStr == null || quantityStr == null) {
            resp.sendRedirect("medicines.jsp?error=missing_params");
            return;
        }

        Connection con = null;
        try {
            con = DBUtil.getConnection();

            int    medicineId = Integer.parseInt(medicineIdStr);
            int    quantity   = Integer.parseInt(quantityStr);
            double totalPrice = Double.parseDouble(totalStr != null ? totalStr : "0");

            String sql =
                "INSERT INTO orders (id, user_id, medicine_id, quantity, total_price, status, created_at) " +
                "VALUES (orders_seq.NEXTVAL, ?, ?, ?, ?, 'PLACED', SYSDATE)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt   (1, user.getId());
            ps.setInt   (2, medicineId);
            ps.setInt   (3, quantity);
            ps.setDouble(4, totalPrice);
            ps.executeUpdate();

            resp.sendRedirect("medicines.jsp?success=order_placed");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("medicines.jsp?error=order_failed");
        } finally {
            DBUtil.closeConnection(con);
        }
    }
}
