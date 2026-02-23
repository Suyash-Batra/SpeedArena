<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SpeedArena - Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Kanit:ital,wght@0,300;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/profile.css">
</head>
<body>

<%
Connection con = null;
Integer uid = (Integer) session.getAttribute("userid");
if (uid == null) {
    session.invalidate(); response.sendRedirect("login.jsp"); return;
}
Integer streak = (Integer) session.getAttribute("streak");
String rank = null;
int totalPoints = 0;

try {
    Class.forName("org.postgresql.Driver");
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");
    con = DriverManager.getConnection(url, user, pass);
    
    PreparedStatement psUser = con.prepareStatement("SELECT rank_name, total_points FROM users WHERE user_id = ?");
    psUser.setInt(1, uid);
    ResultSet rsUser = psUser.executeQuery();
    if (rsUser.next()) {
        rank = rsUser.getString("rank_name");
        totalPoints = rsUser.getInt("total_points");
    }
    rsUser.close(); psUser.close();

    if (request.getParameter("logout") != null) {
        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }

    if (request.getParameter("delete") != null) {
        PreparedStatement pdScores = con.prepareStatement("DELETE FROM scores WHERE user_id = ?");
        pdScores.setInt(1, uid);
        pdScores.executeUpdate();
        pdScores.close();

        PreparedStatement pdUser = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
        pdUser.setInt(1, uid);
        pdUser.executeUpdate();
        pdUser.close();

        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }

} catch(Exception e) {
    out.println("DB Error: " + e.getMessage());
}
%>

<!-- Navbar -->
<nav class="navbar">
    <div class="logo">Speed&nbsp;<div class="orange">Arena</div></div>
    <div class="rightcon">
        <div class="user-info" style="display:flex; align-items:center; gap:15px;">
            <span class="stats-value">
                <div class="orange">P : <%= totalPoints %></div>
            </span>
            <a href="profile.jsp">
                <div class="rank-img">
                    <img src="<%= request.getContextPath() %>/images/<%= (rank != null ? rank : "Rookie") %>.png" alt="rank" style="height:40px;">
                </div>
            </a>
        </div>
    </div>
</nav>

<div class="main-layout">
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>

    <div class="profile-container">
        <div class="sidebar">
            <div class="league">
                <div class="img">
                    <img src="<%= request.getContextPath() %>/images/<%= (rank != null ? rank : "Rookie") %>.png" style="width:160px;">
                </div>
                <div class="title">
                    <div class="orange"><%= (rank != null ? rank : "Rookie") %></div>
                    <div style="font-size: 1.2rem; color: #a0a0a0; margin-top:5px;"><%= session.getAttribute("username") %></div>
                </div>
                <hr style="border: 0; border-top: 1px solid #23272f; margin: 20px 0;">
                <%
                int j = 0;
                PreparedStatement psAll = con.prepareStatement("SELECT user_id FROM users ORDER BY total_points DESC");
                ResultSet rsAll = psAll.executeQuery();
                while (rsAll.next()) { j++; if (uid == rsAll.getInt("user_id")) break; }
                rsAll.close(); psAll.close();
                String rankCol = (j == 1) ? "#DAA520" : (j == 2) ? "#aeabab" : (j == 3) ? "#cd7f32" : "#f45c25";
                %>
                <div class="sidebar-rank">
                    <div class="card-icon">Leaderboard Position</div>
                    <div class="rank-value" style="color: <%=rankCol%>; text-shadow: 0 0 15px <%=rankCol%>99;">#<%=j%></div>
                </div>
            </div>
            <div class="streak-box">
                <div class="orange" style="font-size: 1.4rem;">
                    <%=streak%> <i class="fa-solid fa-fire"></i>
                </div>
                <div class="subtitle2">Current Day Streak</div>
                <table class="rank-table">
                    <tr><th>Streak</th><th>Bonus</th></tr>
                    <tr><td>1 <i class="fa-solid fa-fire"></i></td><td>1.10X</td></tr>
                    <tr><td>5 <i class="fa-solid fa-fire"></i></td><td>1.25X</td></tr>
                    <tr><td>10 <i class="fa-solid fa-fire"></i></td><td>1.50X</td></tr>
                </table>
            </div>
        </div>

        <div class="stats-area">
            <%
            PreparedStatement psS = con.prepareStatement(
                "SELECT " +
                "MAX(CASE WHEN test_id=1 THEN point END), AVG(CASE WHEN test_id=1 THEN point END), " +
                "MAX(CASE WHEN test_id=2 THEN point END), AVG(CASE WHEN test_id=2 THEN point END), " +
                "MIN(CASE WHEN test_id=3 THEN point END), AVG(CASE WHEN test_id=3 THEN point END) " +
                "FROM scores WHERE user_id = ?"
            );
            psS.setInt(1, uid);
            ResultSet rsS = psS.executeQuery();
            if(rsS.next()){
            %>
            <div class="section-tile">Personal Bests</div>
            <div class="card-grid">
                <div class="cardp"><div class="card-icon">Best WPM</div><div class="orange stat-num"><%=rsS.getInt(1)%></div><div class="card-desc">Typing Speed</div></div>
                <div class="cardp"><div class="card-icon">Best Click</div><div class="orange stat-num"><%=rsS.getInt(3)%></div><div class="card-desc">Max CPS</div></div>
                <div class="cardp"><div class="card-icon">Best Reaction</div><div class="orange stat-num"><%=rsS.getInt(5)%>ms</div><div class="card-desc">Fastest Response</div></div>
            </div>

            <div class="section-tile" style="margin-top: 40px;">Performance Average</div>
            <div class="card-grid">
                <div class="cardp"><div class="card-icon">Avg WPM</div><div class="orange stat-num"><%=rsS.getInt(2)%></div><div class="card-desc">Consistent Pace</div></div>
                <div class="cardp"><div class="card-icon">Avg Click</div><div class="orange stat-num"><%=rsS.getInt(4)%></div><div class="card-desc">Average CPS</div></div>
                <div class="cardp"><div class="card-icon">Avg Reaction</div><div class="orange stat-num"><%=rsS.getInt(6)%>ms</div><div class="card-desc">Typical Time</div></div>
            </div>

            <form method="post" style="display: flex; flex-direction: column; gap: 10px; margin-top: 20px;">
                <button class="btn2" name="logout" style="margin:0; width:100%;">Logout</button>
                <button class="btn2" name="delete" style="margin:0; width:100%; background-color: transparent; border: 1px solid #ff4444; color: #ff4444;">Delete Account</button>
            </form>
            <% } rsS.close(); psS.close(); %>
        </div>
    </div>
</div>

<%
if(con != null) try { con.close(); } catch(Exception ex) { /* ignore */ }
%>

</body>
</html>