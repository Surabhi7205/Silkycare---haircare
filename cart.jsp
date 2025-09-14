<%@ page import="java.util.*, java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve or create cart from session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) cart = new HashMap<>();

    // Add product to cart
    String prodIdStr = request.getParameter("productId");
    String qtyStr = request.getParameter("quantity");
    if(prodIdStr != null && qtyStr != null) {
        int prodId = Integer.parseInt(prodIdStr);
        int qty = Integer.parseInt(qtyStr);
        cart.put(prodId, cart.getOrDefault(prodId, 0) + qty);

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
        return;
    }

    // Remove product if requested
    String removeIdStr = request.getParameter("remove");
    if(removeIdStr != null) {
        int removeId = Integer.parseInt(removeIdStr);
        cart.remove(removeId);
        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SilkyCare - Haircare Essentials</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #ffe4e1, #fff5f7); 
            margin: 0; 
            padding: 20px; 
            color: #333;
        }

        h2 { 
            text-align: center; 
            color: #d6336c; 
            margin-bottom: 30px; 
        }

        .navbar {
            background: linear-gradient(90deg, #d6336c, #f78da7);
            padding: 15px 0;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 0 0 15px 15px;
            margin-bottom: 30px;
        }

        .navbar a {
            color: white;
            margin: 0 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
        }

        .navbar a:hover {
            color: #ffeef2;
        }

        .search-bar {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-bar input {
            padding: 10px;
            width: 50%;
            border-radius: 20px;
            border: 1px solid #ccc;
        }

        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 15px;
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

        .btn {
            padding: 8px 15px;
            background: #e85d75;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none;
        }

        .btn:hover {
            background: #d6336c;
        }

        .checkout-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background: #38a169;
            color: white;
            font-weight: 600;
            border-radius: 30px;
            text-decoration: none;
            transition: 0.3s;
        }

        .checkout-btn:hover {
            background: #2f855a;
        }

        .product-img {
            width: 70px;
            height: 70px;
            border-radius: 10px;
            object-fit: cover;
        }

        p {
            text-align: center;
            font-size: 1.1em;
            margin-top: 20px;
        }

        @media(max-width:768px){
            table { width: 100%; }
            .navbar a { margin: 0 10px; font-size: 14px; }
            .search-bar input { width: 80%; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Haircare Products</a>
        <a href="cart.jsp">My Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="search-bar">
        <input type="text" placeholder="Search for shampoos, oils, conditioners...">
    </div>

    <h2>Your Haircare Cart</h2>

    <%
        double grandTotal = 0.0;

        if(cart.isEmpty()) {
    %>
        <p>Your cart is empty. <a href="products.jsp">Browse Haircare Essentials</a></p>
    <%
        } else {
    %>
    <table>
        <tr>
            <th>Product</th>
            <th>Image</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Total (₹)</th>
            <th>Action</th>
        </tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()) {
                    int pid = entry.getKey();
                    int qty = entry.getValue();

                    String sql = "SELECT name, price, imageUrl FROM products WHERE id=?";
                    try(PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, pid);
                        try(ResultSet rs = ps.executeQuery()) {
                            if(rs.next()) {
                                String name = rs.getString("name");
                                double price = rs.getDouble("price");
                                String imageUrl = rs.getString("imageUrl"); // assuming DB column
                                double total = price * qty;
                                grandTotal += total;
        %>
        <tr>
            <td><%=name%></td>
            <td><img src="<%=imageUrl%>" alt="<%=name%>" class="product-img"></td>
            <td>₹<%=price%></td>
            <td><%=qty%></td>
            <td>₹<%=total%></td>
            <td>
                <a class="btn" href="cart.jsp?remove=<%=pid%>">Remove</a>
            </td>
        </tr>
        <%
                            }
                        }
                    }
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='6' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
            }
        %>
        <tr>
            <th colspan="4">Grand Total</th>
            <th colspan="2">₹ <%=grandTotal%></th>
        </tr>
    </table>
    <div style="text-align:center; margin-top:20px;">
        <a class="checkout-btn" href="checkout.jsp">Proceed to Checkout</a>
    </div>
    <%
        }
    %>
</body>
</html>
