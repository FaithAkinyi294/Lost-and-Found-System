<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #facc15;
    color: #111827;
}

/* NAVBAR */
.navbar {
    background: #0f172a;
    padding: 16px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #1f2937;
    position: sticky;
    top: 0;
    z-index: 10;
}

.navbar a {
    color: #cbd5e1;
    margin-right: 15px;
    text-decoration: none;
    font-weight: 600;
    transition: 0.3s;
}

.navbar a:hover {
    color: #38bdf8;
}

/* WELCOME BADGE */
.user {
    color: #38bdf8;
    font-weight: bold;
    padding: 6px 14px;
    border-radius: 20px;
    background: rgba(56,189,248,0.08);
    border: 1px solid rgba(56,189,248,0.3);
}

/* HEADER */
.header {
    text-align: center;
    font-size: 34px;
    margin: 30px 10px;
    font-weight: bold;
    color: #f1f5f9;
}

/* GRID */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 25px;
    padding: 30px;
}

/* CARD */
.card {
    background: #111827;
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid #1f2937;
    transition: 0.3s ease;
}

.card:hover {
    transform: translateY(-6px);
    box-shadow: 0 0 25px rgba(56,189,248,0.18);
}

/* IMAGE */
.card img {
    width: 100%;
    height: 170px;
    object-fit: cover;
    filter: brightness(0.85);
}

/* CONTENT */
.card-body {
    padding: 15px;
}

.card-body h3 {
    margin: 0;
    color: #e2e8f0;
}

.card-body p {
    font-size: 13px;
    color: #94a3b8;
}

/* BUTTONS */
.btn {
    display: inline-block;
    padding: 10px 14px;
    margin-top: 12px;
    border-radius: 8px;
    color: white;
    text-decoration: none;
    font-weight: bold;
    transition: 0.3s;
}

/* masculine button colors */
.lost { background: #ef4444; }
.found { background: #3b82f6; }
.gallery { background: #22c55e; }
.claims { background: #a855f7; }

.btn:hover {
    transform: scale(1.05);
    opacity: 0.9;
}
</style>

</head>

<body>

<%
String username = (String) session.getAttribute("username");
if (username == null || username.trim().isEmpty()) {
    username = "Admin";
}
%>

<!-- NAVBAR -->
<div class="navbar">

    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="viewLost.jsp">Lost Items</a>
        <a href="viewFound.jsp">Found Items</a>
        <a href="lostGallery.jsp">Gallery</a>
        <a href="viewClaims.jsp">Claims</a>
    </div>

    <div class="user">
        Welcome, <%= username %> Admin
    </div>

</div>

<!-- HEADER -->
<div class="header">
    ? ADMIN CONTROL PANEL
</div>

<!-- GRID -->
<div class="grid">

    <!-- LOST -->
    <div class="card">
        <img src="https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg" />
        <div class="card-body">
            <h3>? Lost Items</h3>
            <p>Track and manage lost item reports</p>
            <a href="viewLost.jsp" class="btn lost">Open</a>
        </div>
    </div>

    <!-- FOUND -->
    <div class="card">
        <img src="https://images.pexels.com/photos/3183197/pexels-photo-3183197.jpeg" />
        <div class="card-body">
            <h3>? Found Items</h3>
            <p>Verify and manage found submissions</p>
            <a href="viewFound.jsp" class="btn found">Open</a>
        </div>
    </div>

    <!-- GALLERY -->
    <div class="card">
        <img src="https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg" />
        <div class="card-body">
            <h3>? Gallery</h3>
            <p>Visual browsing of all items</p>
            <a href="lostGallery.jsp" class="btn gallery">Open</a>
        </div>
    </div>

    <!-- CLAIMS -->
    <div class="card">
        <img src="https://images.pexels.com/photos/3184467/pexels-photo-3184467.jpeg" />
        <div class="card-body">
            <h3>? Claims</h3>
            <p>Approve or reject user claims</p>
            <a href="viewClaims.jsp" class="btn claims">Open</a>
        </div>
    </div>

</div>

</body>
</html>