<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpeedArena | Register</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
</head>
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

<%
String username = request.getParameter("cname");
String email = request.getParameter("email");
String password = request.getParameter("pin");

if (username != null && email != null && password != null) {
    Connection con = null;
    PreparedStatement psCheck = null;
    PreparedStatement psInsert = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");
        con = DriverManager.getConnection(url, user, pass);

        psCheck = con.prepareStatement("SELECT username, email FROM users WHERE username = ? OR email = ?");
        psCheck.setString(1, username);
        psCheck.setString(2, email);
        rs = psCheck.executeQuery();
        if (rs.next()) {
%>
            <script>
                alert("Username or Email already registered. Please use another Username or login using registered email.");
            </script>
<%
        } else {
            psInsert = con.prepareStatement("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
            psInsert.setString(1, username);
            psInsert.setString(2, email);
            psInsert.setString(3, password);
            psInsert.executeUpdate();
            response.sendRedirect("login.jsp");
        }

    } catch (Exception e) {
        out.println("DB Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ex){}
        if (psCheck != null) try { psCheck.close(); } catch(Exception ex){}
        if (psInsert != null) try { psInsert.close(); } catch(Exception ex){}
        if (con != null) try { con.close(); } catch(Exception ex){}
    }
}
%>
    </div>
</div>
</body>
</html>