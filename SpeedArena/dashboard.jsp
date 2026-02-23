<%@ include file="navbar.jsp"%>

    <div class="main-content">
        <div class="text">How Fast &nbsp;<div class="orange">Are You?</div></div>
        <div class="subtext">Three skill tests. One leaderboard. Prove your speed in
            <br>typing, clicking, and reaction time.</div>
    </div>

    <div class="card-holder">
        <%
        if (con != null) {
            PreparedStatement ps1 = con.prepareStatement("SELECT * from tests");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                String icon = rs1.getString(5);
                String title = rs1.getString(2);
                String desc = rs1.getString(3);
                String href = rs1.getString(6);
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
        <div class="rank-table-container">
    <h2 class="rank-title"><div class="orange">Rank Tiers</div></h2>

    <table class="rank-table">
        <tr>
            <th>Tier</th>
            <th>Rank</th>
            <th>Points</th>
        </tr>

        <tr>
            <td><img src="images/Apex.png" class="rank-img"></td>
            <td>APEX</td>
            <td>150+</td>
        </tr>

        <tr>
            <td><img src="images/GrandMaster.png" class="rank-img"></td>
            <td>GRANDMASTER</td>
            <td>130 - 149</td>
        </tr>

        <tr>
            <td><img src="images/Master.png" class="rank-img"></td>
            <td>MASTER</td>
            <td>100 - 129</td>
        </tr>

        <tr>
            <td><img src="images/Elite.png" class="rank-img"></td>
            <td>ELITE</td>
            <td>80 - 99</td>
        </tr>

        <tr>
            <td><img src="images/Rookie.png" class="rank-img"></td>
            <td>ROOKIE</td>
            <td>0 - 79</td>
        </tr>
    </table>
</div>

            <div class="leaderboard-area">
                <div class="trophy"><i class="fa-solid fa-trophy"></i></div>
                <div class="title">Top Players</div>
                <div class="subtitle">Can you beat them?</div>
                <div class="minileaderboard">
                    <%
                    PreparedStatement ps2 = con.prepareStatement("SELECT * from users order by total_points desc limit 3");
                    ResultSet rs2 = ps2.executeQuery();
                    int rank1 = 0;
                    while (rs2.next()) {
                        rank1++;
                    %>
                        <div class="lcard">
                            <div class="rank">#<%= rank1 %></div>
                            <div class="name"><%= rs2.getString(2) %></div>
                            <div class="points"><%= rs2.getInt(5) %></div>
                        </div>
                    <%
                    }
                    %>
                </div>
                <a href="leaderboard.jsp"><button id="view">View Full</button></a>
            </div>
        <%
        }
        %>
    </div>
<%@ include file="footer.jsp"%>