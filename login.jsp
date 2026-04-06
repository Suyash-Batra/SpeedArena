<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpeedArena | Login</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="form">
            <h3>Welcome Back</h3>
            <h4>Login to continue your streak</h4>
            <form method="post">
                Username<BR><input type="text" name="cname" placeholder="Enter Username" required><br>
                Password<br><input type="password" name="pin" placeholder="Enter Password" required><br>
                <button type="submit" class="btn1">Login</button>
                <a href="${pageContext.request.contextPath}/register.jsp">Dont have an account? Register.</a>
            </form>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String cname = request.getParameter("cname");
    String p = request.getParameter("pin");

    if (cname != null && p != null) {
        try {
            // CHANGED: MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");
            con = DriverManager.getConnection(url, user, pass);

            ps = con.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
            ps.setString(1, cname.trim());
            ps.setString(2, p.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                int userid = rs.getInt("user_id");
                int streak = rs.getInt("streak");
                session.setAttribute("streak", streak);
                session.setAttribute("userid", userid);
                session.setAttribute("username", cname);

                // CHANGED: Logic for date subtraction in MySQL using DATEDIFF
                String sql = "UPDATE users " +
                             "SET streak = CASE " +
                             "    WHEN last_login IS NULL THEN 1 " +
                             "    WHEN DATEDIFF(CURDATE(), last_login) = 1 THEN streak + 1 " +
                             "    WHEN DATEDIFF(CURDATE(), last_login) > 1 THEN 1 " +
                             "    ELSE streak " +
                             "END, " +
                             "last_login = CURDATE() " +
                             "WHERE user_id = ?";
                
                PreparedStatement sp = con.prepareStatement(sql);
                sp.setInt(1, userid);
                sp.executeUpdate();

                response.sendRedirect("dashboard.jsp");
            } else {
%>
                <h2 style="color:red; text-align:center;">Invalid login credentials</h2>
<%
            }
        } catch (Exception e1) {
            out.println("<p style='color:white;'>Error: " + e1.getMessage() + "</p>");
        } finally {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        }
    }
%>
        </div>
    </div>
</body>
</html>