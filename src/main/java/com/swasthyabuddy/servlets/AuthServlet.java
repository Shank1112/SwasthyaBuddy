package com.swasthyabuddy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.swasthyabuddy.model.User;
import com.swasthyabuddy.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    // ── LOGIN (POST action=login)
    // ── SIGNUP (POST action=signup)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(req, res);
        } else if ("signup".equals(action)) {
            handleSignup(req, res);
        } else {
            res.sendRedirect("login.jsp");
        }
    }

    // ── LOGOUT (GET action=logout)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            res.sendRedirect("login.jsp");
        }
    }

    // ════════════════════════════════════
    //  LOGIN
    // ════════════════════════════════════
    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        Connection con = null;
        try {
            con = DBUtil.getConnection();
            String sql = "SELECT id, first_name, last_name, email, role, phone " +
                         "FROM swasthya_users " +
                         "WHERE LOWER(email) = LOWER(?) AND password = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email.trim());
            ps.setString(2, password.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Build user object
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));

                // Store in session
                HttpSession session = req.getSession(true);
                session.setAttribute("user",     user);
                session.setAttribute("userId",   user.getId());
                session.setAttribute("userName", user.getFirstName());
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("userEmail",user.getEmail());
                session.setMaxInactiveInterval(30 * 60); // 30 min

                // Role-based redirect
                if ("DOCTOR".equalsIgnoreCase(user.getRole())) {
                    res.sendRedirect("doctor-dashboard.jsp");
                } else {
                    res.sendRedirect("patient-dashboard.jsp");
                }

            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("login.jsp").forward(req, res);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, res);
        } finally {
            DBUtil.closeConnection(con);
        }
    }

    // ════════════════════════════════════
    //  SIGNUP
    // ════════════════════════════════════
    private void handleSignup(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String firstName   = req.getParameter("firstName");
        String lastName    = req.getParameter("lastName");
        String email       = req.getParameter("email");
        String password    = req.getParameter("password");
        String role        = req.getParameter("role");
        String phone       = req.getParameter("phone");
        String gender      = req.getParameter("gender");
        String bloodGroup  = req.getParameter("bloodGroup");

        // Basic validation
        if (firstName == null || email == null || password == null
                || firstName.trim().isEmpty() || email.trim().isEmpty()
                || password.trim().isEmpty()) {
            req.setAttribute("error", "Please fill all required fields.");
            req.getRequestDispatcher("signup.jsp").forward(req, res);
            return;
        }

        Connection con = null;
        try {
            con = DBUtil.getConnection();

            // Check email already exists
            PreparedStatement check = con.prepareStatement(
                "SELECT id FROM swasthya_users WHERE LOWER(email) = LOWER(?)");
            check.setString(1, email.trim());
            ResultSet checkRs = check.executeQuery();

            if (checkRs.next()) {
                req.setAttribute("error", "Email already registered. Please login.");
                req.getRequestDispatcher("signup.jsp").forward(req, res);
                return;
            }

            // Insert new user
            String sql = "INSERT INTO swasthya_users " +
                         "(id, first_name, last_name, email, password, " +
                         "role, phone, gender, blood_group, created_at) " +
                         "VALUES (users_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, firstName.trim());
            ps.setString(2, lastName  != null ? lastName.trim()   : "");
            ps.setString(3, email.trim());
            ps.setString(4, password.trim());
            ps.setString(5, role      != null ? role.toUpperCase(): "PATIENT");
            ps.setString(6, phone     != null ? phone.trim()      : "");
            ps.setString(7, gender    != null ? gender.trim()     : "");
            ps.setString(8, bloodGroup!= null ? bloodGroup.trim() : "");
            ps.executeUpdate();

            // Redirect to login with success message
            req.setAttribute("success", "Account created successfully! Please login.");
            req.getRequestDispatcher("login.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Signup failed: " + e.getMessage());
            req.getRequestDispatcher("signup.jsp").forward(req, res);
        } finally {
            DBUtil.closeConnection(con);
        }
    }
}