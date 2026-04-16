<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Lost Items Gallery</title>

<style>
body {
    font-family: 'Segoe UI', sans-serif;
    background: #0b0f1a;
    margin: 0;
    color: white;
}

/* HEADER */
.header {
    text-align: center;
    padding: 25px;
    font-size: 30px;
    font-weight: bold;
    color: #00c6ff;
    letter-spacing: 1px;
}

/* GRID */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 20px;
    padding: 25px;
}

/* CARD */
.card {
    background: #151a2b;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 0 18px rgba(0,0,0,0.6);
    transition: 0.3s;
    border: 1px solid #222;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 0 25px rgba(0,198,255,0.25);
}

.card img {
    width: 100%;
    height: 180px;
    object-fit: cover;
    filter: brightness(0.85);
}

.card-body {
    padding: 15px;
}

.card h3 {
    color: #00c6ff;
    margin: 5px 0;
}

.card p {
    color: #bbb;
    font-size: 14px;
}

/* BUTTON */
.btn {
    display: inline-block;
    padding: 10px 14px;
    margin-top: 10px;
    background: linear-gradient(135deg, #007cf0, #00dfd8);
    color: black;
    font-weight: bold;
    border-radius: 8px;
    text-decoration: none;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
}
</style>
</head>

<body>

<div class="header">? LOST ITEMS GALLERY</div>

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
    ResultSet rs = st.executeQuery("SELECT * FROM lost_items ORDER BY id DESC");

    while(rs.next()) {

        String img = rs.getString("image_url");

        // ? PIXABAY SAFE FALLBACK IMAGES (always displayable)
        if(img == null || img.trim().isEmpty()) {
            int fallback = (rs.getInt("id") % 5);

            switch(fallback) {
                case 0:
                    img = "https://cdn.pixabay.com/photo/2017/01/31/13/14/briefcase-2020360_1280.png";
                    break;
                case 1:
                    img = "https://cdn.pixabay.com/photo/2016/11/29/09/32/keys-1869727_1280.jpg";
                    break;
                case 2:
                    img = "https://cdn.pixabay.com/photo/2016/03/27/19/32/wallet-1281782_1280.jpg";
                    break;
                case 3:
                    img = "https://cdn.pixabay.com/photo/2015/09/05/21/51/watch-925424_1280.jpg";
                    break;
                default:
                    img = "https://cdn.pixabay.com/photo/2016/11/18/12/52/lost-1836075_1280.jpg";
            }
        }
%>

<div class="card">
    <img src="<%= img %>" alt="lost item">

    <div class="card-body">
        <h3><%= rs.getString("item_name") %></h3>
        <p><%= rs.getString("description") %></p>

        <a class="btn" href="viewLostDetails.jsp?id=<%= rs.getInt("id") %>">
            View Details
        </a>
    </div>
</div>

<%
    }

    con.close();

} catch(Exception e) {
%>
    <p style="color:red; text-align:center;">
        Error loading gallery: <%= e.getMessage() %>
    </p>
<%
}
%>

</div>

</body>
</html>