<%@ page import="java.sql.*" %>
<%
String id = request.getParameter("id");

// SAFETY CHECK
if (id == null || id.trim().isEmpty()) {
%>
<script>
    alert("Invalid claim ID");
    window.location = "viewClaims.jsp";
</script>
<%
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Approve Claim</title>

<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #facc15;
    color: #111827;
}

/* CARD */
.container {
    width: 430px;
    margin: 90px auto;
    background: #111827;
    padding: 28px;
    border-radius: 16px;
    text-align: center;
    border: 1px solid #1f2937;
    box-shadow: 0 0 25px rgba(0,0,0,0.6);
}

/* TITLE */
h2 {
    color: #38bdf8;
    margin-bottom: 10px;
}

/* TEXT */
p {
    color: #94a3b8;
    font-size: 14px;
}

/* BUTTON BASE */
.btn {
    display: inline-block;
    padding: 12px 18px;
    margin: 12px 8px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: bold;
    transition: 0.3s;
}

/* MASCULINE APPROVE BUTTON (BLUE STEEL) */
.approve {
    background: linear-gradient(135deg, #1e3a8a, #2563eb);
    color: white;
    box-shadow: 0 0 15px rgba(37,99,235,0.3);
}

/* MASCULINE CANCEL BUTTON (DARK RED) */
.cancel {
    background: linear-gradient(135deg, #7f1d1d, #ef4444);
    color: white;
    box-shadow: 0 0 15px rgba(239,68,68,0.2);
}

/* HOVER EFFECT */
.btn:hover {
    transform: scale(1.06);
    opacity: 0.9;
}
</style>

</head>

<body>

<div class="container">

    <h2>? Approve Claim</h2>

    <p>Confirm approval of this claim request</p>

    <!-- APPROVE -->
    <a class="btn approve"
       href="ApproveClaimServlet?id=<%= id %>">
       ? Confirm Approval
    </a>

    <!-- CANCEL -->
    <a class="btn cancel"
       href="viewClaims.jsp">
       ? Cancel Action
    </a>

</div>

</body>
</html>