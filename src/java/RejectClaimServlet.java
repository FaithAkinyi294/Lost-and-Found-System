package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RejectClaimServlet")
public class RejectClaimServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null || id.isEmpty()) {
            res.getWriter().println("Invalid ID");
            return;
        }

        try {
            // Load driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect DB
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lostandfound",
                "root",
                "Password"
            );

            // Update status
            PreparedStatement ps = con.prepareStatement(
                "UPDATE match_requests SET status='REJECTED' WHERE id=?"
            );

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            // Redirect back
            res.sendRedirect("viewClaims.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Rejection failed: " + e.getMessage());
        }
    }
}