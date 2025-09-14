<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Products - SilkyCare</title>
    <style>
        /* Reset */
        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff5f7, #ffe4e1);
            padding: 30px;
            color: #333;
        }

        /* Navbar */
        .navbar {
            text-align: center;
            background: rgba(255, 255, 255, 0.6);
            padding: 15px 0;
            border-radius: 15px;
            margin-bottom: 40px;
            backdrop-filter: blur(12px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        .navbar a {
            color: #d6336c;
            margin: 0 18px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }

        .navbar a:hover {
            color: #f78da7;
        }

        /* Page title */
        h2 {
            text-align: center;
            background: linear-gradient(90deg, #d6336c, #f78da7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
            font-size: 2.2em;
            font-weight: 700;
        }

        /* Table styles */
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: rgba(255,255,255,0.9);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
        }

        th {
            background: linear-gradient(45deg, #d6336c, #f78da7);
            color: #fff;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #fff0f5;
        }

        tr:hover {
            background: #ffe4ec;
            transition: 0.3s;
        }

        input[type="number"] {
            width: 60px;
            padding: 6px;
            border-radius: 8px;
            border: 1px solid #ccc;
            text-align: center;
            outline: none;
        }

        input[type="number"]:focus {
            border-color: #d6336c;
            box-shadow: 0 0 6px rgba(214, 51, 108, 0.3);
        }

        .btn {
            padding: 8px 16px;
            background: linear-gradient(90deg, #d6336c, #f78da7);
            color: #fff;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .btn:hover {
            background: linear-gradient(90deg, #b02a58, #f06292);
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.2);
        }

        /* Responsive */
        @media(max-width:768px){
            table { width: 100%; font-size: 0.9em; }
            .navbar a { margin: 0 10px; font-size: 14px; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>🌸 Our Haircare Products</h2>

    <table>
        <tr>
            <th>Product</th>
            <th>Description</th>
            <th>Price (₹)</th>
            <th>Stock</th>
            <th>Quantity</th>
            <th>Action</th>
        </tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products");
                while(rs.next()){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
        %>
                    <tr>
                        <td><%=name%></td>
                        <td><%=desc%></td>
                        <td>₹<%=price%></td>
                        <td><%=stock%></td>
                        <form action="cart.jsp" method="get">
                            <td><input type="number" name="quantity" value="1" min="1" max="<%=stock%>" required></td>
                            <td>
                                <input type="hidden" name="productId" value="<%=id%>">
                                <button type="submit" class="btn">Add to Cart</button>
                            </td>
                        </form>
                    </tr>
        <%
                }
                rs.close();
                st.close();
            } catch(Exception e){
                out.println("<tr><td colspan='6' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
            }
        %>
    </table>
</body>
</html>
