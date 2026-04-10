package com.mycompany.lostandfoundsystem;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
// Import your new business class
import com.mycompany.lostandfoundsystem.business.User; 

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); 
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("Welcome.jsp");
            return; 
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Using your test credentials: AWUOR and 2345
    if ("AWUOR".equalsIgnoreCase(username) && "2345".equals(password)) {
        User userBean = new User();
        userBean.setUsername(username);

        HttpSession session = request.getSession();
        session.setAttribute("user", userBean);

        response.sendRedirect("Welcome.jsp");
    } else {
        response.sendRedirect("login.jsp?error=true");
    }

}
    }
