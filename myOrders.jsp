<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - SilkyCare</title>
    <style>
    /* Reset */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

    body {
        background: linear-gradient(135deg, #ffe4e1, #fff5f7);
        margin: 0;
        padding: 20px;
        color: #333;
    }

    h2 {
        text-align: center;
        background: linear-gradient(90deg, #d6336c, #f78da7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 40px;
        font-size: 2.5em;
        font-weight: 700;
    }

    .container {
        width: 90%;
        max-width: 1100px;
        margin: auto;
    }

    .order-block {
        background: rgba(255, 192, 203, 0.25);
        backdrop-filter: blur(15px);
        border-radius: 20px;
        padding: 25px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        margin-bottom: 35px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .order-block:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0,0,0,0.2);
    }

    .order-block h3 {
        color: #d6336c;
        margin-bottom: 15px;
        font-size: 1.4em;
    }

    .order-block p {
        margin: 6px 0;
        font-size: 1em;
        color: #444;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    th, td {
        padding: 12px;
        text-align: center;
    }

    th {
        background: linear-gradient(45deg, #e85d75, #d6336c);
        color: white;
        font-weight: 600;
    }

    tr:nth-child(even) {
        background: #fff0f5;
    }

    .item-row td {
        color: #333;
        font-size: 0.95em;
    }

    a {
        color: #d6336c;
        text-decoration: none;
        font-weight: 600;
    }

    a:hover {
        text-decoration: underline;
        color: #a61e4d;
    }

    /* Info and error messages */
    .info {
        text-align: center;
        font-size: 1.1em;
        color: #444;
        margin-top: 20px;
    }

    .info a {
        color: #d6336c;
    }

    .error {
        text-align: center;
        color: #e53e3e;
        margin-top: 20px;
        font-weight: 600;
    }

    /* Responsive */
    @media(max-width: 768px) {
        .container { width: 95%; padding: 10px; }
        table, th, td { font-size: 13px; }
        .order-block { padding: 20px; }
    }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Orders</h2>

        <%
            String email = (String) session.getAttribute("userEmail");
            if (email == null) {
                out.println("<p class='error'>⚠ Please <a href='login.jsp'>login</a> to view your orders.</p>");
            } else {
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT * FROM orders WHERE user_email=? ORDER BY order_date DESC";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, email);
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hasOrders = false;
                            while (rs.next()) {
                                hasOrders = true;
                                int orderId = rs.getInt("id");
                                String addr = rs.getString("address");
                                String payment = rs.getString("payment_method");
                                double total = rs.getDouble("total");
                                Timestamp date = rs.getTimestamp("order_date");
        %>
                                <div class="order-block">
                                    <h3>🛍 Order ID: <%= orderId %></h3>
                                    <p><b>Date:</b> <%= date %></p>
                                    <p><b>Address:</b> <%= addr %></p>
                                    <p><b>Payment:</b> <%= payment %></p>
                                    <p><b>Total:</b> ₹ <%= total %></p>

                                    <table>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price (₹)</th>
                                            <th>Quantity</th>
                                            <th>Subtotal (₹)</th>
                                        </tr>
                                        <%
                                            String itemSql = "SELECT oi.*, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=?";
                                            try (PreparedStatement ps2 = conn.prepareStatement(itemSql)) {
                                                ps2.setInt(1, orderId);
                                                try (ResultSet rs2 = ps2.executeQuery()) {
                                                    while (rs2.next()) {
                                                        String pname = rs2.getString("name");
                                                        double price = rs2.getDouble("price");
                                                        int qty = rs2.getInt("quantity");
                                                        double subtotal = price * qty;
                                        %>
                                                        <tr class="item-row">
                                                            <td><%= pname %></td>
                                                            <td>₹ <%= price %></td>
                                                            <td><%= qty %></td>
                                                            <td>₹ <%= subtotal %></td>
                                                        </tr>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </table>
                                </div>
        <%
                            }
                            if (!hasOrders) {
                                out.println("<p class='info'>ℹ You have no orders yet. <a href='products.jsp'>Start Shopping</a></p>");
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
