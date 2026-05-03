<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Claims Dashboard</title>

<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #facc15;
    color: #111827;
}

h2 {
    text-align: center;
    margin: 20px;
}

.sub {
    text-align: center;
    color: #888;
    margin-bottom: 15px;
}

.table-container {
    width: 95%;
    margin: auto;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    background: #15151d;
    border-radius: 12px;
    overflow: hidden;
}

th {
    background: #1f1f2e;
    color: #00c6ff;
    padding: 14px;
    font-size: 13px;
    text-transform: uppercase;
}

td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #222;
    color: #ddd;
}

tr:hover {
    background: #1a1a25;
}

.status {
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    display: inline-block;
}

.PENDING { background: #f39c12; color: black; }
.APPROVED { background: #28a745; color: white; }
.REJECTED { background: #ff4d4d; color: white; }

.btn {
    padding: 8px 12px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    display: inline-block;
}

.approve { background: #28a745; color: white; }
.reject { background: #ff4d4d; color: white; }
</style>

</head>

<body>

<h2>? CLAIMS MANAGEMENT DASHBOARD</h2>
<div class="sub">? Newest requests appear first</div>

<div class="table-container">

<table>

<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Phone</th>
    <th>Date Lost</th>
    <th>Description</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

boolean hasData = false;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/lostandfound",
        "root",
        "Password"
    );

    st = con.createStatement();

    // ? FIXED ORDER (REAL SYSTEM ORDER)
    rs = st.executeQuery("SELECT * FROM match_requests ORDER BY created_at DESC");

    while(rs.next()) {
        hasData = true;

        String name = rs.getString("fullname");
        String phone = rs.getString("phone");
        String date = rs.getString("date_lost");
        String desc = rs.getString("lost_description");
        String status = rs.getString("status");

        // SAFE NULL HANDLING
        if(name == null) name = "Unknown User";
        if(phone == null) phone = "N/A";
        if(date == null) date = "Not Specified";
        if(desc == null) desc = "No Description";
        if(status == null) status = "PENDING";

        status = status.toUpperCase();
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= name %></td>
    <td><%= phone %></td>
    <td><%= date %></td>
    <td><%= desc %></td>

    <td>
        <span class="status <%= status %>"><%= status %></span>
    </td>

    <td>
        <a class="btn approve"
           href="ApproveClaimServlet?id=<%= rs.getInt("id") %>">
           Approve
        </a>

        <a class="btn reject"
           href="RejectClaimServlet?id=<%= rs.getInt("id") %>">
           Reject
        </a>
    </td>
</tr>

<%
    }

} catch(Exception e) {
%>
    <tr>
        <td colspan="7" style="color:red;">
            ERROR: <%= e.getMessage() %>
        </td>
    </tr>
<%
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(st != null) st.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

</table>

</div>

</body>
</html>