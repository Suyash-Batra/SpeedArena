<%@ page import="java.sql.*" %>
<%@ include file="navbar.jsp" %>

<%
PreparedStatement ps1 = null;
PreparedStatement ps2 = null;
ResultSet rs1 = null;
ResultSet rs2 = null;

try {
    Class.forName("org.postgresql.Driver");
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");

    con = DriverManager.getConnection(url, user, pass);
%>

<div class="main-content">
    <div class="text">How Fast &nbsp;<div class="orange">Are You?</div></div>
    <div class="subtext">Three skill tests. One leaderboard. Prove your speed in
        <br>typing, clicking, and reaction time.</div>
</div>

<div class="card-holder">
<%
    ps1 = con.prepareStatement("SELECT * FROM tests");
    rs1 = ps1.executeQuery();
    while(rs1.next()) {
        String icon = rs1.getString("icon");
        String title = rs1.getString("test_name");
        String desc = rs1.getString("description");
        String href = rs1.getString("href");
%>
    <a href="<%= href %>" style="text-decoration: none;">
        <div class="card">
            <div class="card-icon"><%= icon %></div>
            <div class="card-title"><%= title %></div>
            <div class="card-desc"><%= desc %></div>
        </div>
    </a>
<%
    }
%>
</div>

<div class="rank-table-container">
    <h2 class="rank-title"><div class="orange">Rank Tiers</div></h2>

    <table class="rank-table">
        <tr>
            <th>Tier</th>
            <th>Rank</th>
            <th>Points</th>
        </tr>
        <tr><td><img src="images/Apex.png" class="rank-img"></td><td>APEX</td><td>150+</td></tr>
        <tr><td><img src="images/GrandMaster.png" class="rank-img"></td><td>GRANDMASTER</td><td>130 - 149</td></tr>
        <tr><td><img src="images/Master.png" class="rank-img"></td><td>MASTER</td><td>100 - 129</td></tr>
        <tr><td><img src="images/Elite.png" class="rank-img"></td><td>ELITE</td><td>80 - 99</td></tr>
        <tr><td><img src="images/Rookie.png" class="rank-img"></td><td>ROOKIE</td><td>0 - 79</td></tr>
    </table>
</div>

<div class="leaderboard-area">
    <div class="trophy"><i class="fa-solid fa-trophy"></i></div>
    <div class="title">Top Players</div>
    <div class="subtitle">Can you beat them?</div>
    <div class="minileaderboard">
<%
    ps2 = con.prepareStatement("SELECT * FROM users ORDER BY total_points DESC LIMIT 3");
    rs2 = ps2.executeQuery();
    int rank1 = 0;
    while(rs2.next()) {
        rank1++;
%>
        <div class="lcard">
            <div class="rank">#<%= rank1 %></div>
            <div class="name"><%= rs2.getString("username") %></div>
            <div class="points"><%= rs2.getInt("total_points") %></div>
        </div>
<%
    }
%>
    </div>
    <a href="leaderboard.jsp"><button id="view">View Full</button></a>
</div>

<%
} catch(Exception e) {
    out.println("DB Error: " + e.getMessage());
} finally {
    if(rs1 != null) try { rs1.close(); } catch(Exception ex){}
    if(ps1 != null) try { ps1.close(); } catch(Exception ex){}
    if(rs2 != null) try { rs2.close(); } catch(Exception ex){}
    if(ps2 != null) try { ps2.close(); } catch(Exception ex){}
    if(con != null) try { con.close(); } catch(Exception ex){}
}
%>

<%@ include file="footer.jsp" %>