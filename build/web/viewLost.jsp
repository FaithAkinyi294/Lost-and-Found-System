<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>View Lost Items</title>

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
    padding: 22px;
    font-size: 28px;
    font-weight: bold;
    color: #00c6ff;
    letter-spacing: 1px;
}

/* CONTAINER */
.container {
    width: 90%;
    margin: auto;
}

/* CARD */
.card {
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(18px);
    border-radius: 15px;
    padding: 20px;
    box-shadow: 0 10px 35px rgba(0,0,0,0.5);
    border: 1px solid rgba(255,255,255,0.1);
}

/* TABLE */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
    color: white;
}

th {
    background: linear-gradient(135deg, #2563eb, #0ea5e9);
    color: white;
    padding: 12px;
    letter-spacing: 1px;
    text-transform: uppercase;
}

td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

tr:hover {
    background: rgba(255,255,255,0.05);
    transition: 0.3s;
}

/* BUTTONS */
.btn {
    padding: 9px 14px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    display: inline-block;
    transition: 0.3s;
    margin: 2px;
}

/* MATCH BUTTON */
.match {
    background: linear-gradient(135deg, #00c6ff, #0072ff);
    color: white;
}

/* CLAIM BUTTON */
.claim {
    background: linear-gradient(135deg, #ff416c, #ff4b2b);
    color: white;
}

.btn:hover {
    transform: scale(1.08);
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}
</style>

</head>

<body>

<div class="header">? Lost Items Dashboard</div>

<div class="container">
<div class="card">

<table>
<tr>
    <th>ID</th>
    <th>Item</th>
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
ResultSet rs = st.executeQuery("SELECT * FROM lost_items");

while(rs.next()) {
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("item_name") %></td>
    <td><%= rs.getString("description") %></td>

    <td>

        <a class="btn match"
           href="matchItem.jsp?id=<%= rs.getInt("id") %>">
           Match ?
        </a>

        <a class="btn claim"
           href="approveClaim.jsp?id=<%= rs.getInt("id") %>">
           Claim ?
        </a>

    </td>
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