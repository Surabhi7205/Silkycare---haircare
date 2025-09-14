<%@ page import="java.util.*,java.sql.*,com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }

    Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) { response.sendRedirect("cart.jsp"); return; }

    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SilkyCare - Checkout</title>
   <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #ffe4e1, #fff5f7);
        color: #333;
        margin: 0;
        padding: 20px;
    }

    h2 {
        text-align: center;
        color: #d6336c; /* haircare pink */
        margin-bottom: 40px;
        font-size: 2.2em;
    }

    table {
        width: 85%;
        margin: auto;
        border-collapse: collapse;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        background: #ffffff;
    }

    th, td {
        padding: 14px;
        text-align: center;
    }

    th {
        background: #d6336c; 
        color: white;
        font-weight: 600;
    }

    tr:nth-child(even) {
        background: #fdf2f8;
    }

    textarea, select, input[type="text"] {
        width: 60%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 25px;
        font-size: 1em;
        margin-top: 10px;
    }

    textarea:focus, select:focus, input[type="text"]:focus {
        outline: none;
        border-color: #d6336c;
        box-shadow: 0 0 5px rgba(214,51,108,0.5);
    }

    .btn {
        display: inline-block;
        padding: 12px 30px;
        margin-top: 25px;
        background: #e85d75;
        color: white;
        text-decoration: none;
        border-radius: 30px;
        font-weight: bold;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
        font-size: 1em;
    }

    .btn:hover {
        background: #d6336c;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }

    form {
        text-align: center;
        margin-top: 40px;
    }

    label {
        font-weight: 600;
        display: block;
        margin-top: 15px;
        margin-bottom: 5px;
        color: #555;
    }

    .order-summary {
        text-align: center;
        margin-top: 40px;
        font-size: 1.2em;
        font-weight: bold;
        color: #d6336c;
    }

    @media(max-width: 768px) {
        table { width: 95%; }
        textarea, select, input[type="text"] { width: 90%; }
    }
</style>
</head>
<body>
    <h2>Confirm Your Haircare Order</h2>

    <table>
        <tr><th>Product</th><th>Quantity</th><th>Price (₹)</th><th>Total (₹)</th></tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                    int pid = entry.getKey();
                    int qty = entry.getValue();

                    PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
                    ps.setInt(1, pid);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()){
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        double total = price * qty;
                        grandTotal += total;
        %>
                        <tr>
                            <td><%=name%></td>
                            <td><%=qty%></td>
                            <td>₹<%=price%></td>
                            <td>₹<%=total%></td>
                        </tr>
        <%
                    }
                    rs.close(); ps.close();
                }
            } catch(Exception e){ out.println("<tr><td colspan='4'>Error: "+e.getMessage()+"</td></tr>"); }
        %>
        <tr><th colspan="3">Grand Total</th><th>₹<%=grandTotal%></th></tr>
    </table>

    <div class="order-summary">
        You’re just one step away from healthy, silky hair ✨
    </div>

    <form action="placeOrder.jsp" method="post">
        <label>Shipping Address:</label>
        <textarea name="address" rows="3" required></textarea>

        <label>Coupon Code (optional):</label>
        <input type="text" name="coupon" placeholder="Enter your coupon">

        <label>Payment Method:</label>
        <select name="payment" required>
            <option value="Cash on Delivery">Cash on Delivery</option>
            <option value="Online Payment">Online Payment</option>
            <option value="UPI">UPI</option>
            <option value="Credit/Debit Card">Credit/Debit Card</option>
        </select>

        <button type="submit" class="btn">Confirm & Pay</button>
    </form>
</body>
</html>
