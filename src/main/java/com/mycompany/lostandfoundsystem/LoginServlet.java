package com.mycompany.lostandfoundsystem;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;  // ← add this import

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Null / empty check
        if (username == null || password == null ||
            username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=1");
            return;
        }

        // 3. Username: letters only
        if (!username.matches("[A-Za-z]+")) {
            response.sendRedirect("login.jsp?error=1");
            return;
        }


        // 5. ── Session: create and store user data ──────────────
        HttpSession session = request.getSession(true); // create new session
        session.setAttribute("user", username);         // store username
        session.setMaxInactiveInterval(30 * 60);        // expire after 30 min

        response.sendRedirect("Welcome.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, skip login page
        HttpSession session = request.getSession(false); // don't create new one
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(" Welcome.jsp");
            return;
        }

        response.sendRedirect("login.jsp");
    }
}