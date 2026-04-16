package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ClaimServlet")
public class ClaimServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null || id.isEmpty()) {
            res.getWriter().println("Invalid ID");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lostandfound",
                "root",
                "Password"
            );

            PreparedStatement ps = con.prepareStatement(
                "UPDATE lost_items SET approval_status='CLAIMED' WHERE id=?"
            );

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            // Redirect back to dashboard
            res.sendRedirect("viewLost.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("CLAIM ERROR: " + e.getMessage());
        }
    }
}