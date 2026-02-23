<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpeedArena | Register</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<body>
    <div class="container">
        <div class="form">
            <h3>Create Account</h3>
            <h4>Join SpeedArena and start competing</h4>
    <form method="post">
        Username<BR><input type="text" name="cname" placeholder="Enter Username" required><br>
        Email<br><input type="email" name="email" placeholder="Enter Email" required><br>
        Password<br><input type="password" name="pin" placeholder="Enter Password" required><br>
        <button type="submit" class="btn1">Create Account</button>
        <a href="${pageContext.request.contextPath}/login.jsp">Have an account? Login.</a>
    </form>
    <%@ page import = "java.sql.*"%>
    <%
    String username = request.getParameter("cname");
    String email = request.getParameter("email");
    String password = request.getParameter("pin");
    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("org.postgresql.Driver");
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        con = DriverManager.getConnection(url, user, pass);
        if (username != null && email != null && password != null) {
            PreparedStatement ps1 = con.prepareStatement("Select username, email from users");
            ResultSet rs = ps1.executeQuery();
            while (rs.next()) {
                if (username.equals(rs.getString(1)) || email.equals(rs.getString(2))) {
                    %>
                    <script>
                        alert("Username/Email already registered :( \n Please use another Username or login using registered email");
                    </script>
                    <%
                    break;
                }
            }
            ps = con.prepareStatement("Insert into users (username, email, password) values (?,?,?)");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.executeUpdate();
            response.sendRedirect("login.jsp");
        }
    }catch (Exception e) {
        out.println(e);
    }
    %>
    </div>
    </div>
</body>
</html>