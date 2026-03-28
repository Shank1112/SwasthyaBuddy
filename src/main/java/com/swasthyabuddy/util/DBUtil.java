package com.swasthyabuddy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String MYSQL_URL = System.getenv("MYSQL_URL");
    private static final String MYSQL_USER = System.getenv("MYSQL_USER");
    private static final String MYSQL_PASSWORD = System.getenv("MYSQL_PASSWORD");
    
    private static final String ORA_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String ORA_USER = "Swasthya";
    private static final String ORA_PASS = "Buddy";

    static {
        try {
            if (MYSQL_URL != null) {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } else {
                Class.forName("oracle.jdbc.driver.OracleDriver");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("DB Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        if (MYSQL_URL != null) {
            return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
        }
        return DriverManager.getConnection(ORA_URL, ORA_USER, ORA_PASS);
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); }
            catch (SQLException e) { e.printStackTrace(); }
        }
    }
}