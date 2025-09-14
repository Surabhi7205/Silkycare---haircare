<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Products - E-Commerce</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #fafafa;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        /* Navbar */
        .navbar {
            text-align: center;
            background: #4CAF50;
            padding: 15px 0;
            border-radius: 6px;
            margin-bottom: 30px;
        }
        .navbar a {
            color: #fff;
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.2s;
        }
        .navbar a:hover {
            text-decoration: underline;
        }

        /* Title */
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #4CAF50;
        }

        /* Table */
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #f0f0f0;
            color: #333;
        }
        tr:hover {
            background: #f9f9f9;
        }

        /* Inputs & Button */
        input[type="number"] {
            width: 60px;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            padding: 6px 12px;
            background: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background: #45a049;
        }

        @media(max-width:768px){
            table { width: 100%; font-size: 14px; }
            .navbar a { margin: 0 8px; font-size: 14px; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Available Products</h2>

    <table>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Price (₹)</th>
            <th>Stock</th>
            <th>Quantity</th>
            <th>Action</th>
        </tr>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.name}</td>
                <td>${p.description}</td>
                <td>₹${p.price}</td>
                <td>${p.stock}</td>
                <form action="cart.jsp" method="get">
                    <td>
                        <input type="number" name="quantity" value="1" min="1" max="${p.stock}" required>
                    </td>
                    <td>
                        <input type="hidden" name="productId" value="${p.id}">
                        <button type="submit" class="btn">Add</button>
                    </td>
                </form>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
