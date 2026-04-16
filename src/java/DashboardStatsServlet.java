package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/DashboardStatsServlet")
public class DashboardStatsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("application/json");

        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lostandfound",
                "root",
                "Password"
            );

            Statement st = con.createStatement();

            ResultSet lost = st.executeQuery("SELECT COUNT(*) FROM lost_items");
            lost.next();
            int lostCount = lost.getInt(1);

            ResultSet found = st.executeQuery("SELECT COUNT(*) FROM found_items");
            found.next();
            int foundCount = found.getInt(1);

            ResultSet claimed = st.executeQuery(
                "SELECT COUNT(*) FROM lost_items WHERE approval_status='Claimed'"
            );
            claimed.next();
            int claimedCount = claimed.getInt(1);

            String json =
                "{"
                + "\"lost\":" + lostCount + ","
                + "\"found\":" + foundCount + ","
                + "\"claimed\":" + claimedCount +
                "}";

            res.getWriter().write(json);

            con.close();

        } catch(Exception e) {
            res.getWriter().write("{\"error\":\"true\"}");
        }
    }
}