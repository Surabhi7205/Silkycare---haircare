

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SilkyCare - Haircare Essentials</title>
<style>
/* Google Font */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');

/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}

/* Body with soft pink gradient */
body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: linear-gradient(135deg, #ffe4e1, #fff5f7);
    color: #333;
}

/* Glassmorphic Navbar */
.navbar {
    width: 90%;
    margin: 20px auto;
    padding: 15px 30px;
    display: flex;
    justify-content: center;
    gap: 25px;
    background: rgba(255, 192, 203, 0.25);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
}

.navbar a {
    color: #d6336c;
    text-decoration: none;
    font-weight: 600;
    padding: 8px 20px;
    border-radius: 12px;
    transition: all 0.3s ease;
}

.navbar a:hover {
    background: rgba(255,255,255,0.5);
    color: #a61e4d;
    transform: scale(1.05);
}

/* Floating Welcome Card */
.welcome-card {
    margin-top: 60px;
    width: 90%;
    max-width: 700px;
    background: rgba(255,192,203,0.25);
    backdrop-filter: blur(15px);
    border-radius: 30px;
    padding: 50px 40px;
    text-align: center;
    box-shadow: 0 20px 50px rgba(0,0,0,0.1);
    animation: float 4s ease-in-out infinite;
    transition: transform 0.5s ease, box-shadow 0.5s ease;
}

.welcome-card:hover {
    transform: translateY(-10px) scale(1.02);
    box-shadow: 0 25px 60px rgba(0,0,0,0.15);
}

/* Floating Animation */
@keyframes float {
    0% { transform: translateY(0); }
    50% { transform: translateY(-15px); }
    100% { transform: translateY(0); }
}

.welcome-card h1 {
    font-size: 3em;
    font-weight: 700;
    background: linear-gradient(90deg, #d6336c, #f78da7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 20px;
}

.welcome-card p {
    font-size: 1.2em;
    color: #333;
    line-height: 1.6;
    margin-bottom: 30px;
}

/* Call-to-action Button */
.cta-btn {
    display: inline-block;
    padding: 15px 40px;
    border-radius: 50px;
    background: linear-gradient(45deg, #e85d75, #d6336c);
    color: #fff;
    font-weight: 700;
    font-size: 1.1em;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 10px 20px rgba(0,0,0,0.15);
    text-decoration: none;
}

.cta-btn:hover {
    transform: translateY(-5px) scale(1.05);
    box-shadow: 0 15px 30px rgba(0,0,0,0.2);
}

/* Responsive */
@media(max-width:768px) {
    .welcome-card {
        padding: 35px 20px;
    }
    .welcome-card h1 {
        font-size: 2.2em;
    }
    .welcome-card p {
        font-size: 1em;
    }
    .navbar {
        flex-wrap: wrap;
        gap: 15px;
    }
    .navbar a {
        padding: 6px 15px;
    }
}
</style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Haircare Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="welcome-card">
        <h1>Welcome to SilkyCare ✨</h1>
        <p>Discover premium shampoos, conditioners, and oils crafted to give your hair a silky, shiny glow 💖</p>
        <a href="products.jsp" class="cta-btn">🛍️ Start Shopping</a>
    </div>
</body>
</html>
