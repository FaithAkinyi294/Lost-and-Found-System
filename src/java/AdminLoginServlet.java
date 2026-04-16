package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/lostandfound";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "SELECT * FROM admins WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // ✅ LOGIN SUCCESS
                session.setAttribute("admin", email);
                session.setAttribute("adminName", rs.getString("username"));

                session.setAttribute("loginStatus", "success");

                // 🔥 REDIRECT TO DASHBOARD
                response.sendRedirect("dashboard.jsp");

            } else {

                // ❌ LOGIN FAILED
                session.setAttribute("loginStatus", "failed");
                response.sendRedirect("adminLogin.jsp");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("loginStatus", "error");
            response.sendRedirect("adminLogin.jsp");
        }
    }
}