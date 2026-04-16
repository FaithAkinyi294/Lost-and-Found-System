package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AdminResetServlet")
public class AdminResetServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String email = req.getParameter("email");
        String code = req.getParameter("admin_code");
        String newPass = req.getParameter("new_password");

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "UPDATE admins SET password=? WHERE email=? AND admin_code=?"
            );

            ps.setString(1, newPass);
            ps.setString(2, email);
            ps.setString(3, code);

            int result = ps.executeUpdate();

            if (result > 0) {
                res.getWriter().println("<script>alert('Password reset successful');window.location='adminLogin.jsp';</script>");
            } else {
                res.getWriter().println("<script>alert('Invalid details');history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}