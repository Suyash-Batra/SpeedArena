<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>leaderboard | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%
Connection con = null;
PreparedStatement psUser = null;
PreparedStatement psTop = null;
PreparedStatement psAll = null;
ResultSet rsUser = null;
ResultSet rsTop = null;
ResultSet rsAll = null;

try {

    if (request.getParameter("logout") != null) {
        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("org.postgresql.Driver");
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");

    con = DriverManager.getConnection(url, user, pass);
%>

<nav class="navbar">
    <div class="logo">Speed&nbsp;<div class="orange">Arena</div></div>
    <div class="rightcon">
<%
    Integer userIdObj = (Integer) session.getAttribute("userid");

    if (userIdObj != null) {

        psUser = con.prepareStatement("SELECT * FROM users WHERE user_id = ?");
        psUser.setInt(1, userIdObj);
        rsUser = psUser.executeQuery();

        if (rsUser.next()) {
%>
            <div class="user-info">
                <span class="stats-value">P : <%= rsUser.getInt("total_points") %></span>
                <form method="post" style="display:inline;">
                    <button class="btn2" name="logout">Logout</button>
                </form>
            </div>
<%
        }

    } else {
%>
        <div class="nav-auth-buttons">
            <a href="login.jsp"><button class="btn2">Signin</button></a>
            <a href="register.jsp"><button class="btn2">Signup</button></a>
        </div>
<%
    }
%>
    </div>
</nav>

<a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>

<div class="trophy1"><i class="fa-solid fa-trophy"></i></div>
<div class="title1">Top Players</div>
<br>

<div class="card-holder">
<%
    psTop = con.prepareStatement("SELECT * FROM users ORDER BY total_points DESC LIMIT 3");
    rsTop = psTop.executeQuery();

    int i = 0;
    while (rsTop.next()) {
        i++;
%>
    <div class="lcard">
        <div class="rank">#<%= i %></div>
        <div class="name"><%= rsTop.getString("username") %></div>
        <div class="points"><%= rsTop.getInt("total_points") %></div>
    </div>
<%
    }
%>
</div>

<div class="table-container">
<table class="leaderboards">
    <thead>
        <tr>
            <th>Position</th>
            <th>Player</th>
            <th>Points</th>
            <th>Rank</th>
        </tr>
    </thead>
    <tbody>
<%
    psAll = con.prepareStatement("SELECT * FROM users ORDER BY total_points DESC");
    rsAll = psAll.executeQuery();
    int j = 0;
    while (rsAll.next()) {
        String rank = rsAll.getString("rank_name");
        j++;
%>
        <tr>
            <td><%= j %></td>
            <td><strong><%= rsAll.getString("username") %></strong></td>
            <td><div class="orange"><%= rsAll.getInt("total_points") %></div></td>
            <td><img src="<%= request.getContextPath() %>/images/<%=rank%>.png" style="height:40px;"></td>
        </tr>
<%
    }
%>
    </tbody>
</table>
</div>

<%
} catch (Exception e) {
    out.println(e);
}
%>

</body>
</html>