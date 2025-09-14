

<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If user already logged in, redirect to index.jsp
    if (session.getAttribute("userEmail") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SilkyCare</title>
    <style>
    /* Reset */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }

    body {
        background: linear-gradient(135deg, #ffe4e1, #fff5f7);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #333;
    }

    .login-box {
        background: rgba(255, 192, 203, 0.25);
        backdrop-filter: blur(15px);
        padding: 40px 30px;
        border-radius: 20px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        width: 360px;
        text-align: center;
        animation: fadeIn 1s ease-in-out;
    }

    .login-box h2 {
        margin-bottom: 25px;
        background: linear-gradient(90deg, #d6336c, #f78da7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-size: 2.2em;
        font-weight: 700;
    }

    input {
        width: 100%;
        padding: 12px 15px;
        margin: 12px 0;
        border: 1px solid #ccc;
        border-radius: 12px;
        font-size: 1em;
        transition: all 0.3s ease;
    }

    input:focus {
        outline: none;
        border-color: #d6336c;
        box-shadow: 0 0 8px rgba(214,51,108,0.3);
    }

    button {
        width: 100%;
        padding: 12px;
        margin-top: 20px;
        background: linear-gradient(45deg, #e85d75, #d6336c);
        color: white;
        font-weight: bold;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        font-size: 1em;
        transition: all 0.3s ease;
        box-shadow: 0 6px 15px rgba(0,0,0,0.15);
    }

    button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.25);
    }

    .error {
        color: #e53e3e;
        margin-top: 15px;
        font-weight: 500;
    }

    .register-link {
        display: block;
        margin-top: 20px;
        font-size: 0.9em;
        color: #d6336c;
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .register-link:hover {
        color: #a61e4d;
        text-decoration: underline;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 420px) {
        .login-box {
            width: 90%;
            padding: 30px 20px;
        }
    }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Login to SilkyCare</h2>
        <form method="post" action="login.jsp">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <a href="register.jsp" class="register-link">✨ New user? Register here</a>

        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
                    ps.setString(1, email);
                    ps.setString(2, password); // plain text for simplicity
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("userEmail", email);
                        response.sendRedirect("index.jsp");
                    } else {
                        out.println("<p class='error'>Invalid email or password!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ex) {}
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>
