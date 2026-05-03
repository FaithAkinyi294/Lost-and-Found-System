<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #4c0000;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    color: #111827;
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
    margin-bottom: 20px;
}

/* INPUT */
input {
    width: 100%;
    padding: 12px;
    margin: 8px 0;
    border: none;
    border-radius: 8px;
    background: #111827;
    color: white;
    outline: none;
}

input:focus {
    border: 1px solid #60a5fa;
}

/* PASSWORD WRAPPER */
.pass-wrapper {
    position: relative;
}

/* MODERN EYE ICON */
.eye {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    font-size: 18px;
    opacity: 0.7;
    transition: 0.3s;
}

.eye:hover {
    opacity: 1;
    transform: translateY(-50%) scale(1.1);
}

/* REMEMBER ME (MODERN TOGGLE STYLE) */
.remember {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 10px;
    font-size: 14px;
    color: #cbd5e1;
}

.remember input {
    width: 16px;
    height: 16px;
    accent-color: #4c0000;
    cursor: pointer;
}

/* BUTTON */
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
    transition: 0.3s;
}

button:hover {
    background: #1d4ed8;
    transform: scale(1.02);
}

/* LINKS */
.login-link {
    text-align: center;
    margin-top: 12px;
    font-size: 14px;
}

.login-link a {
    color: #60a5fa;
    text-decoration: none;
    display: block;
    margin-top: 6px;
}

.login-link a:hover {
    text-decoration: underline;
}

/* MODAL */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
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
    border: 1px solid #374151;
}

.close-btn {
    margin-top: 15px;
    padding: 8px 15px;
    background: #2563eb;
    border: none;
    color: white;
    border-radius: 6px;
    cursor: pointer;
}
</style>

<script>

// TOGGLE PASSWORD (MODERN VERSION)
function togglePassword(id, icon) {
    let input = document.getElementById(id);

    if (input.type === "password") {
        input.type = "text";
        icon.innerText = "?";
    } else {
        input.type = "password";
        icon.innerText = "??";
    }
}

// POPUP
function showPopup(message, type) {
    const modal = document.getElementById("popup");
    const text = document.getElementById("popupText");

    text.innerText = message;
    text.style.color = (type === "error") ? "#ef4444" : "#22c55e";

    modal.style.display = "flex";
}

function closePopup() {
    document.getElementById("popup").style.display = "none";
}

// AUTO LOGIN STATUS POPUP
window.onload = function () {
    let status = "<%= session.getAttribute("loginStatus") != null ? session.getAttribute("loginStatus") : "" %>";

    if (status === "failed") {
        showPopup("Invalid login credentials!", "error");
    } else if (status === "error") {
        showPopup("System error occurred!", "error");
    }

    <% session.removeAttribute("loginStatus"); %>
};
</script>

</head>

<body>

<div class="container">

    <h2>ADMIN LOGIN</h2>

    <form action="AdminLoginServlet" method="post">

        <input type="email" name="email"
               placeholder="Email"
               pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$"
               required>

        <div class="pass-wrapper">
            <input type="password" id="password" name="password"
                   placeholder="Password" required>

            <span class="eye" onclick="togglePassword('password', this)">??</span>
        </div>

        <!-- MODERN REMEMBER ME -->
        <div class="remember">
            <input type="checkbox" name="remember">
            <label>Remember me</label>
        </div>

        <button type="submit">LOGIN</button>
    </form>

    <div class="login-link">
        <a href="adminReset.jsp">Forgot Password?</a>
        <a href="adminRegister.jsp">Don't have an account? Register</a>
    </div>

</div>

<!-- POPUP -->
<div class="modal" id="popup">
    <div class="modal-content">
        <h3 id="popupText"></h3>
        <button class="close-btn" onclick="closePopup()">OK</button>
    </div>
</div>

</body>
</html>
