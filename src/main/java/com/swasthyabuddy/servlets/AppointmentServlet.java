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

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    // GET  → view all appointments for logged-in patient
    // POST → book new appointment OR cancel existing one

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        loadAppointments(req, resp, user);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User   user   = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        if ("cancel".equals(action)) {
            cancelAppointment(req, resp, user);
        } else {
            bookAppointment(req, resp, user);
        }
    }

    // ════════════════════════════════════
    //  LOAD APPOINTMENTS
    // ════════════════════════════════════
    private void loadAppointments(HttpServletRequest req,
                                   HttpServletResponse resp,
                                   User user)
            throws IOException, ServletException {

        Connection con = null;
        try {
            con = DBUtil.getConnection();

            String sql =
                "SELECT id, doctor_name, clinic_name, clinic_address, " +
                "appt_date, appt_time, status, created_at " +
                "FROM appointments " +
                "WHERE patient_id = ? " +
                "ORDER BY created_at DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();

            List<Map<String, String>> appointments = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> appt = new LinkedHashMap<>();
                appt.put("id",            String.valueOf(rs.getInt("id")));
                appt.put("doctorName",    rs.getString("doctor_name"));
                appt.put("clinicName",    rs.getString("clinic_name"));
                appt.put("clinicAddress", rs.getString("clinic_address"));
                appt.put("apptDate",      rs.getString("appt_date"));
                appt.put("apptTime",      rs.getString("appt_time"));
                appt.put("status",        rs.getString("status"));
                appt.put("createdAt",     rs.getString("created_at"));
                appointments.add(appt);
            }

            req.setAttribute("appointments", appointments);
            req.getRequestDispatcher("appointments.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load appointments: " + e.getMessage());
            req.getRequestDispatcher("appointments.jsp").forward(req, resp);
        } finally {
            DBUtil.closeConnection(con);
        }
    }

    // ════════════════════════════════════
    //  BOOK APPOINTMENT
    // ════════════════════════════════════
    private void bookAppointment(HttpServletRequest req,
                                  HttpServletResponse resp,
                                  User user)
            throws IOException {

        String doctorName = req.getParameter("doctorName");
        String clinicName = req.getParameter("clinicName");
        String address    = req.getParameter("clinicAddress");
        String date       = req.getParameter("apptDate");
        String time       = req.getParameter("apptTime");

        if (doctorName == null || date == null || time == null) {
            resp.sendRedirect("maps.jsp?error=missing_fields");
            return;
        }

        Connection con = null;
        try {
            con = DBUtil.getConnection();

            String sql =
                "INSERT INTO appointments " +
                "(id, patient_id, doctor_name, clinic_name, " +
                "clinic_address, appt_date, appt_time, status, created_at) " +
                "VALUES (appointments_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, 'PENDING', SYSDATE)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt   (1, user.getId());
            ps.setString(2, doctorName);
            ps.setString(3, clinicName  != null ? clinicName : "");
            ps.setString(4, address     != null ? address    : "");
            ps.setString(5, date);
            ps.setString(6, time);
            ps.executeUpdate();

            resp.sendRedirect("AppointmentServlet?success=booked");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("maps.jsp?error=booking_failed");
        } finally {
            DBUtil.closeConnection(con);
        }
    }

    // ════════════════════════════════════
    //  CANCEL APPOINTMENT
    // ════════════════════════════════════
    private void cancelAppointment(HttpServletRequest req,
                                    HttpServletResponse resp,
                                    User user)
            throws IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) { resp.sendRedirect("AppointmentServlet"); return; }

        Connection con = null;
        try {
            con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE appointments SET status = 'CANCELLED' " +
                "WHERE id = ? AND patient_id = ?");
            ps.setInt(1, Integer.parseInt(idStr));
            ps.setInt(2, user.getId());
            ps.executeUpdate();
            resp.sendRedirect("AppointmentServlet");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("AppointmentServlet");
        } finally {
            DBUtil.closeConnection(con);
        }
    }
}
