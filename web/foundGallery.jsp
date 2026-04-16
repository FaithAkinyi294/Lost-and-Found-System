<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Found Items Gallery</title>

<style>
body { font-family: 'Segoe UI'; background:#f5f7ff; margin:0; }

.header {
    text-align:center;
    padding:20px;
    font-size:28px;
    font-weight:bold;
}

.grid {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:20px;
    padding:20px;
}

.card {
    background:white;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 10px 20px rgba(0,0,0,0.1);
}

.card img {
    width:100%;
    height:180px;
    object-fit:cover;
}

.card-body {
    padding:12px;
}

.btn {
    display:inline-block;
    padding:8px 12px;
    background:#28a745;
    color:white;
    border-radius:8px;
    text-decoration:none;
}
</style>
</head>

<body>

<div class="header">? Found Items Gallery</div>

<div class="grid">

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/lostandfound",
        "root",
        "Password"
    );

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM found_items ORDER BY id DESC");

    while(rs.next()) {

        String img = rs.getString("image_url");
        if(img == null || img.equals("")) {
            img = "https://images.unsplash.com/photo-1523275335684-37898b6baf30";
        }
%>

<div class="card">
    <img src="<%= img %>">

    <div class="card-body">
        <h3><%= rs.getString("item_name") %></h3>
        <p><%= rs.getString("description") %></p>

        <a class="btn" href="viewFound.jsp">
            Manage
        </a>
    </div>
</div>

<%
    }

    con.close();

} catch(Exception e) {
    out.println("Error loading gallery");
}
%>

</div>

</body>
</html>