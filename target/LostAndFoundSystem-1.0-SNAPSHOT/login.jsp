<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check FIRST, before any HTML output
    String user = (String) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("dashboard.jsp");
        return; // stop further processing
    }
    String error = request.getParameter("error"); // use getAttribute if servlet forwards
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Lost & Found</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            width: 350px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover { background: #0056b3; }
        .error {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Login</h2>

        <% if (error != null) { %>
            <div class="error">Invalid username or password</div>
        <% } %>

        <form action="LoginServlet" method="post">
            <input type="text" name="username"
                   placeholder="Username (letters only)"
                   pattern="[A-Za-z]+"
                   title="Only letters allowed"
                   required>

            <input type="password" name="password"
                   placeholder="Password"
                   required>

            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html><%-- 
    Document   : login.jsp
    Created on : Apr 5, 2026, 4:35:53 PM
    Author     : user
--%>