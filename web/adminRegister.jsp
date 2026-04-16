<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Admin Register</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg, #0b1220, #111827);
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    color: white;
}

.container {
    background: #1f2937;
    padding: 30px;
    border-radius: 14px;
    width: 380px;
    box-shadow: 0 0 30px rgba(0,0,0,0.6);
}

h2 {
    text-align: center;
    color: #60a5fa;
}

input {
    width: 100%;
    padding: 12px;
    margin: 8px 0;
    border: none;
    border-radius: 8px;
    background: #111827;
    color: white;
}

input:focus {
    border: 1px solid #60a5fa;
    outline: none;
}

.pass-wrapper {
    position: relative;
}

.eye {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
}

button {
    width: 100%;
    padding: 12px;
    margin-top: 12px;
    background: #2563eb;
    border: none;
    border-radius: 8px;
    color: white;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    background: #1d4ed8;
}

.login-link {
    text-align: center;
    margin-top: 12px;
}

.login-link a {
    color: #60a5fa;
    text-decoration: none;
}

#msg {
    font-size: 13px;
    margin-top: -5px;
}

/* MODAL */
.modal {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.7);
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: #111827;
    padding: 25px;
    border-radius: 12px;
    text-align: center;
    width: 300px;
}
</style>

</head>

<body>

<div class="container">

<h2>ADMIN REGISTER</h2>

<form action="AdminRegisterServlet" method="post" onsubmit="return validateForm()">

    <input type="text" name="username" placeholder="Username" required>

    <input type="email" name="email" placeholder="Email" required>

    <input type="text" name="adminCode" placeholder="Admin Code (optional)">

    <div class="pass-wrapper">
        <input type="password" id="password" name="password" placeholder="Password" required>
        <span class="eye" onclick="toggle('password', this)">??</span>
    </div>

    <div class="pass-wrapper">
        <input type="password" id="confirm" name="confirm" placeholder="Confirm Password" required>
        <span class="eye" onclick="toggle('confirm', this)">??</span>
    </div>

    <div id="msg"></div>

    <button type="submit">REGISTER</button>
</form>

<div class="login-link">
    Have an account? <a href="adminLogin.jsp">Login here</a>
</div>

</div>

<!-- POPUP -->
<div class="modal" id="popup">
    <div class="modal-content">
        <h3 id="popupText"></h3>
    </div>
</div>

<script>

function toggle(id, icon) {
    let input = document.getElementById(id);

    if (input.type === "password") {
        input.type = "text";
        icon.innerText = "?";
    } else {
        input.type = "password";
        icon.innerText = "??";
    }
}

// LIVE CHECK
window.onload = function () {

    document.getElementById("password").addEventListener("input", checkMatch);
    document.getElementById("confirm").addEventListener("input", checkMatch);

};

function checkMatch() {
    let p = document.getElementById("password").value;
    let c = document.getElementById("confirm").value;
    let msg = document.getElementById("msg");

    if (c === "") {
        msg.innerText = "";
        return;
    }

    if (p === c) {
        msg.innerText = "Passwords match ?";
        msg.style.color = "#22c55e";
    } else {
        msg.innerText = "Passwords do not match ?";
        msg.style.color = "#ef4444";
    }
}

function validateForm() {
    let p = document.getElementById("password").value;
    let c = document.getElementById("confirm").value;

    if (p !== c) {
        alert("Passwords do not match!");
        return false;
    }
    return true;
}

</script>

<%
String status = (String) session.getAttribute("regStatus");

if (status != null) {
%>
<script>
alert("<%= status.equals("success") ? "Registration successful" :
       status.equals("exists") ? "User already exists" :
       "Registration failed" %>");
</script>
<%
session.removeAttribute("regStatus");
}
%>

</body>
</html>