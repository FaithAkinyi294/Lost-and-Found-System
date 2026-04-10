<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 1. IMPORT JSTL CORE TAGS --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 2. JSTL REDIRECT (Replaces the Java if-block) --%>
<c:if test="${not empty sessionScope.user}">
    <c:redirect url="Welcome.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Lost</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0; 
            background-image: linear-gradient(rgba(15, 23, 42, 0.8), rgba(15, 23, 42, 0.8)), 
                              url('https://plus.unsplash.com/premium_photo-1676212822725-b3334538ba1a?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .accent-yellow {
            accent-color: #facc15;
        }
    </style>
</head>
<body class="p-4">

    <div class="w-full max-w-[400px] glass-card rounded-[2.5rem] shadow-2xl p-10 flex flex-col">
        
        <div class="text-left mb-10">
            <h2 class="text-4xl font-bold text-white tracking-tight">Login</h2> 
            <p class="text-slate-300 text-sm mt-2 font-medium">Please Sign In to continue.</p>
        </div>

        <%-- 3. JSTL ERROR MESSAGE (Replaces the Java if(error != null) block) --%>
        <c:if test="${not empty param.error}">
            <div class="mb-6 p-3 rounded-xl bg-red-500/20 border border-red-500/50 text-red-200 text-xs text-center">
                Invalid username or password
            </div>
        </c:if>

        <form action="LoginServlet" method="post" class="flex flex-col space-y-5">
            
            <div class="relative w-full">
                <div class="absolute inset-y-0 left-0 pl-5 flex items-center pointer-events-none">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                </div>
                <%-- 4. EL to preserve username (optional) --%>
                <input type="text" name="username" value="${param.username}"
                       class="w-full bg-white/90 text-slate-900 rounded-full pl-14 pr-4 py-4 outline-none focus:ring-2 focus:ring-yellow-400 transition-all placeholder:text-slate-500"
                       placeholder="Username" 
                       required
                       pattern="^[A-Za-z]+$"
                       title="Username should only contain letters">
            </div>

            <%-- ... (Rest of your HTML/JS remains exactly the same) ... --%>
            <div class="relative w-full">
                <div class="absolute inset-y-0 left-0 pl-5 flex items-center pointer-events-none">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                </div>
                <input type="password" id="password" name="password"
                       class="w-full bg-white/90 text-slate-900 rounded-full pl-14 pr-12 py-4 outline-none focus:ring-2 focus:ring-yellow-400 transition-all placeholder:text-slate-500"
                       placeholder="Password" required>
                <div id="togglePassword" class="absolute inset-y-0 right-0 pr-5 flex items-center cursor-pointer">
                    <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-slate-500 hover:text-yellow-500 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                </div>
            </div>

            <button type="submit" 
                    class="w-full bg-yellow-400 hover:bg-yellow-500 text-slate-900 font-bold py-4 rounded-full transition-all shadow-lg shadow-yellow-400/20 mt-4 text-lg">
                Log in
            </button>
        </form>

        <div class="flex flex-col items-center mt-8 space-y-6">
            <div class="flex items-center justify-between w-full text-[14px]">
                <label class="flex items-center text-slate-200 cursor-pointer">
                    <input type="checkbox" class="mr-2 w-4 h-4 rounded accent-yellow"> Remember Me
                </label>
                <a href="#" class="text-yellow-400 hover:text-yellow-300 font-semibold transition-colors">Forgot Password?</a>
            </div>
            <p class="text-slate-300 text-sm">
                Don't have an account? <a href="register.jsp" class="text-yellow-400 hover:text-yellow-300 font-bold ml-1 transition-colors">Sign Up</a>
            </p>
        </div>
    </div>
    
    <script>
        document.getElementById('togglePassword').addEventListener('click', function () {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('eyeIcon');
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            if (type === 'text') {
                eyeIcon.classList.add('text-yellow-500');
                eyeIcon.classList.remove('text-slate-500');
            } else {
                eyeIcon.classList.remove('text-yellow-500');
                eyeIcon.classList.add('text-slate-500');
            }
        });
    </script>
</body>
</html>
