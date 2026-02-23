<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SpeedArena</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ page import="java.sql.*"%>

<%
Connection con = null;
Integer uid = (Integer) session.getAttribute("userid");
Integer streak = (Integer) session.getAttribute("streak");
String rank = null;
int totalPoints = 0;

try {
    Class.forName("org.postgresql.Driver");
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");

    con = DriverManager.getConnection(url, user, pass);

    if (uid != null) {
        PreparedStatement psUser = con.prepareStatement(
            "SELECT rank_name, total_points FROM users WHERE user_id = ?"
        );
        psUser.setInt(1, uid);
        ResultSet rsUser = psUser.executeQuery();

        if (rsUser.next()) {
            rank = rsUser.getString("rank_name");
            totalPoints = rsUser.getInt("total_points");
        }

        rsUser.close();
        psUser.close();
    }

} catch(Exception e) {
    out.println("DB Error: " + e.getMessage());
}
%>

<nav class="navbar">
    <div class="logo">Speed&nbsp;<div class="orange">Arena</div></div>

    <div class="rightcon">
        <% if (uid != null) { %>

        <div class="user-info" style="display:flex; align-items:center; gap:15px;">
    
    <span class="stats-value">
        <div class="orange">
        P : <%= totalPoints %>
        </div>
    </span>

    <a href="profile.jsp">
    <div class="rank-img">
        <img src="<%= request.getContextPath() %>/images/<%= (rank != null ? rank : "default") %>.png" alt="rank" style="height:40px;">
    </div></a>

</div>


        <% } else { %>

            <div class="nav-auth-buttons">
                <a href="login.jsp"><button class="btn2">Signin</button></a>
                <a href="register.jsp"><button class="btn2">Signup</button></a>
            </div>

        <% } %>
    </div>
</nav>