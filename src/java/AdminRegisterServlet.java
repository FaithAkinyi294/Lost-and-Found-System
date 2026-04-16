package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminRegisterServlet")
public class AdminRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String confirm = req.getParameter("confirm"); // FIXED to match JSP
        String code = req.getParameter("adminCode");

        try (Connection con = DBConnection.getConnection()) {

            // 1. EMAIL VALIDATION
            if (!email.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$")) {
                session.setAttribute("regStatus", "invalidEmail");
                res.sendRedirect("adminRegister.jsp");
                return;
            }

            // 2. PASSWORD MATCH
            if (!pass.equals(confirm)) {
                session.setAttribute("regStatus", "passwordMismatch");
                res.sendRedirect("adminRegister.jsp");
                return;
            }

            // 3. PASSWORD STRENGTH
            if (!pass.matches("^(?=.*[A-Z])(?=.*[0-9]).{6,}$")) {
                session.setAttribute("regStatus", "weakPassword");
                res.sendRedirect("adminRegister.jsp");
                return;
            }

            // 4. ADMIN LIMIT CHECK
            PreparedStatement count = con.prepareStatement("SELECT COUNT(*) FROM admins");
            ResultSet rs = count.executeQuery();
            rs.next();

            if (rs.getInt(1) >= 5) {
                rs.close();
                count.close();

                session.setAttribute("regStatus", "adminLimit");
                res.sendRedirect("adminRegister.jsp");
                return;
            }

            rs.close();
            count.close();

            // 5. CHECK IF EMAIL EXISTS
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM admins WHERE email=?"
            );
            check.setString(1, email);
            ResultSet exists = check.executeQuery();

            if (exists.next()) {
                session.setAttribute("regStatus", "exists");
                res.sendRedirect("adminRegister.jsp");
                return;
            }

            exists.close();
            check.close();

            // 6. INSERT ADMIN
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO admins(username,email,password,admin_code) VALUES(?,?,?,?)"
            );

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, pass);
            ps.setString(4, code);

            ps.executeUpdate();

            ps.close();

            // SUCCESS → redirect to login
            session.setAttribute("regStatus", "success");
            res.sendRedirect("adminLogin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("regStatus", "error");
            res.sendRedirect("adminRegister.jsp");
        }
    }
}