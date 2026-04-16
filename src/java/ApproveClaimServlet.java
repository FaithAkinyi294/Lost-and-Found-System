package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ApproveClaimServlet")
public class ApproveClaimServlet extends HttpServlet {

    private void approve(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

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
                    "UPDATE match_requests SET status='APPROVED' WHERE id=?"
            );

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            res.sendRedirect("viewClaims.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Approval failed: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        approve(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        approve(req, res);
    }
}