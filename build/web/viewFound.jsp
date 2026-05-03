<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>View Found Items</title>

<style>
body {
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
    background: #facc15;
    color: #111827;
}

/* HEADER */
.header {
    text-align: center;
    padding: 25px;
    font-size: 30px;
    font-weight: bold;
    color: #00c6ff;
    letter-spacing: 1px;
    animation: fadeDown 0.6s ease;
}

@keyframes fadeDown {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

/* CONTAINER */
.container {
    width: 92%;
    margin: auto;
    animation: fadeIn 0.8s ease;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* CARD */
.card {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(18px);
    border-radius: 18px;
    padding: 25px;
    box-shadow: 0 10px 35px rgba(0,0,0,0.5);
    border: 1px solid rgba(255,255,255,0.1);
}

/* TABLE */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    color: white;
}

th {
    background: linear-gradient(135deg, #0ea5e9, #2563eb);
    color: white;
    padding: 14px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

td {
    padding: 14px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

tr:hover {
    background: rgba(255,255,255,0.05);
    transition: 0.3s;
}

/* BUTTON */
.btn {
    padding: 10px 14px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: 0.3s;
    font-weight: bold;
}

.approve {
    background: linear-gradient(135deg, #00c853, #00bfa5);
    color: white;
}

.approve:hover {
    transform: scale(1.08);
    box-shadow: 0 0 15px rgba(0, 255, 150, 0.3);
}

/* EMPTY STATE */
.empty {
    text-align: center;
    padding: 20px;
    color: #aaa;
}
</style>

</head>

<body>

<div class="header">? Found Items Dashboard</div>

<div class="container">
<div class="card">

<table>
<tr>
    <th>ID</th>
    <th>Item Name</th>
    <th>Description</th>
    <th>Action</th>
</tr>

<%
Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/lostandfound",
    "root",
    "Password"
);

Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM found_items");

boolean hasData = false;

while(rs.next()) {
    hasData = true;
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("item_name") %></td>
    <td><%= rs.getString("description") %></td>

    <td>
        <form action="ApproveClaimServlet" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            <button class="btn approve">Approve ?</button>
        </form>
    </td>
</tr>

<%
}

if(!hasData) {
%>
<tr>
    <td colspan="4" class="empty">No found items available</td>
</tr>
<%
}

con.close();
%>

</table>

</div>
</div>

</body>
</html>