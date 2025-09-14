<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()){
        response.sendRedirect("cart.jsp");
        return;
    }

    String address = request.getParameter("address");
    String payment = request.getParameter("payment");

    int orderId = 0;
    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - SilkyCare</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ffe4e1, #fff5f7);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 60px auto;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            padding: 40px 30px;
            text-align: center;
            backdrop-filter: blur(12px);
            animation: fadeIn 1s ease-in-out;
        }

        h1 {
            font-size: 2.5rem;
            background: linear-gradient(90deg, #d6336c, #f78da7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
            font-weight: 700;
        }

        p {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 40px;
        }

        .order-id {
            font-size: 1.5rem;
            color: #d6336c;
            font-weight: bold;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 35px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 14px 15px;
            text-align: center;
        }

        th {
            background: linear-gradient(45deg, #e85d75, #d6336c);
            color: #fff;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #fff0f5;
        }

        td {
            color: #333;
            font-size: 1rem;
        }

        .btn {
            display: inline-block;
            background: linear-gradient(90deg, #d6336c, #f78da7);
            color: #fff;
            padding: 12px 28px;
            border-radius: 50px;
            font-weight: 600;
            margin: 12px;
            transition: 0.3s ease;
            text-decoration: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        @keyframes fadeIn {
            0% {opacity: 0; transform: translateY(-20px);}
            100% {opacity: 1; transform: translateY(0);}
        }

        @media(max-width: 768px){
            .container { padding: 25px 20px; }
            h1 { font-size: 2rem; }
            .order-id { font-size: 1.2rem; }
            table, th, td { font-size: 0.9rem; }
        }
    </style>
</head>
<body>
<%
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // Calculate grand total
        for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
            int pid = entry.getKey();
            int qty = entry.getValue();
            try (PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                ps.setInt(1, pid);
                try (ResultSet rs = ps.executeQuery()) {
                    if(rs.next()) grandTotal += rs.getDouble("price") * qty;
                }
            }
        }

        // Insert order
        try (PreparedStatement psOrder = conn.prepareStatement(
            "INSERT INTO orders(user_email,address,payment_method,total) VALUES(?,?,?,?)",
            Statement.RETURN_GENERATED_KEYS
        )) {
            psOrder.setString(1, userEmail);
            psOrder.setString(2, address);
            psOrder.setString(3, payment);
            psOrder.setDouble(4, grandTotal);
            psOrder.executeUpdate();

            try (ResultSet rsOrder = psOrder.getGeneratedKeys()) {
                if(rsOrder.next()) orderId = rsOrder.getInt(1);
            }
        }

        // Insert order_items
        for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
            int pid = entry.getKey();
            int qty = entry.getValue();
            double price = 0;
            try (PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                psPrice.setInt(1, pid);
                try (ResultSet rsPrice = psPrice.executeQuery()) {
                    if(rsPrice.next()) price = rsPrice.getDouble("price");
                }
            }

            try (PreparedStatement psItem = conn.prepareStatement(
                "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)"
            )) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, pid);
                psItem.setInt(3, qty);
                psItem.setDouble(4, price);
                psItem.executeUpdate();
            }
        }

        conn.commit();
        session.removeAttribute("cart");
%>

    <div class="container">
        <h1>🎉 Order Placed Successfully!</h1>
        <p class="order-id">Your Order ID is <strong><%=orderId%></strong></p>

        <table>
            <tr><th>Product ID</th><th>Quantity</th><th>Price (₹)</th><th>Total (₹)</th></tr>
            <%
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                    int pid = entry.getKey();
                    int qty = entry.getValue();
                    double price = 0;
                    try (PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                        psPrice.setInt(1, pid);
                        try (ResultSet rsPrice = psPrice.executeQuery()) {
                            if(rsPrice.next()) price = rsPrice.getDouble("price");
                        }
                    }
                    double total = price * qty;
            %>
            <tr>
                <td><%=pid%></td>
                <td><%=qty%></td>
                <td>₹<%=price%></td>
                <td>₹<%=total%></td>
            </tr>
            <% } %>
            <tr>
                <th colspan="3">Grand Total</th>
                <th>₹<%=grandTotal%></th>
            </tr>
        </table>

        <a href="products.jsp" class="btn">🛍 Continue Shopping</a>
        <a href="myOrders.jsp" class="btn">📦 View Orders</a>
    </div>

<%
    } catch(Exception e){
        out.println("<p style='color:red; text-align:center; margin-top:50px;'>Error placing order: "+e.getMessage()+"</p>");
        e.printStackTrace();
    }
%>
</body>
</html>
