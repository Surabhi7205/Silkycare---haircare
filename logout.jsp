<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session to log out
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout - SilkyCare</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #ffe4e1, #fff5f7);
            font-family: 'Poppins', sans-serif;
            color: #333;
        }

        .logout-card {
            background: rgba(255, 192, 203, 0.25);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            animation: fadeIn 1s ease-in-out;
        }

        h2 {
            background: linear-gradient(90deg, #d6336c, #f78da7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2em;
            margin-bottom: 15px;
        }

        p {
            font-size: 1.1em;
            margin-bottom: 20px;
            color: #444;
        }

        a {
            display: inline-block;
            padding: 12px 25px;
            border-radius: 30px;
            background: linear-gradient(45deg, #e85d75, #d6336c);
            color: white;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        a:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-15px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <!-- Auto redirect after 3 seconds -->
    <meta http-equiv="refresh" content="3;URL=login.jsp">
</head>
<body>
    <div class="logout-card">
        <h2>👋 Logged Out</h2>
        <p>You have been successfully logged out of SilkyCare.</p>
        <p>Redirecting you to the <strong>Login</strong> page...</p>
        <a href="login.jsp">Go to Login Now</a>
    </div>
</body>
</html>
