<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Match Items</title>

<style>
body {
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #f4f6ff, #e8f0ff);
    margin: 0;
}

.container {
    width: 500px;
    margin: 60px auto;
    background: white;
    padding: 25px;
    border-radius: 14px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
}

h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #333;
}

label {
    font-weight: bold;
    font-size: 14px;
}

select {
    width: 100%;
    padding: 10px;
    margin: 10px 0 20px 0;
    border: 1px solid #ccc;
    border-radius: 6px;
}

button {
    width: 100%;
    padding: 12px;
    background: #4facfe;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background: #2196f3;
}
</style>
</head>

<body>

<div class="container">

<h2>? Match Lost & Found Items</h2>

<form action="MatchServlet" method="post">

    <!-- LOST ITEMS -->
    <label>Select Lost Item</label>
    <select name="lost_id" required>
        <%
        try {
            Connection con = servlets.DBConnection.getConnection();
            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery("SELECT id, item_name, location FROM lost_items");

            while (rs.next()) {
        %>
            <option value="<%= rs.getInt("id") %>">
                <%= rs.getString("item_name") %> - <%= rs.getString("location") %>
            </option>
        <%
            }
            con.close();
        } catch (Exception e) {
            out.println("Error loading lost items");
        }
        %>
    </select>

    <!-- FOUND ITEMS -->
    <label>Select Found Item</label>
    <select name="found_id" required>
        <%
        try {
            Connection con = servlets.DBConnection.getConnection();
            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery("SELECT id, item_name, location FROM found_items");

            while (rs.next()) {
        %>
            <option value="<%= rs.getInt("id") %>">
                <%= rs.getString("item_name") %> - <%= rs.getString("location") %>
            </option>
        <%
            }
            con.close();
        } catch (Exception e) {
            out.println("Error loading found items");
        }
        %>
    </select>

    <button type="submit">Match Items</button>

</form>

</div>

</body>
</html>