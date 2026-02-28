<%@ page import="java.sql.*" %>
<%
String pointsStr = request.getParameter("points");
String pointStr = request.getParameter("pp");

if (pointsStr != null && pointStr != null) {
    int points = Integer.parseInt(pointsStr);
    int score = Integer.parseInt(pointStr);

    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");

        con = DriverManager.getConnection(url, user, pass);

        String sql = "INSERT INTO scores (user_id, test_id, score, point) VALUES (?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setInt(1, (Integer) session.getAttribute("userid"));
        ps.setInt(2, (Integer) session.getAttribute("tid"));
        ps.setInt(3, points);
        ps.setInt(4, score);
        ps.executeUpdate();

        String sumSql = "SELECT SUM(max_score) AS total_best_score " +
                        "FROM (SELECT MAX(score) AS max_score FROM scores WHERE user_id = ? GROUP BY test_id) AS best_scores";
        ps1 = con.prepareStatement(sumSql);
        ps1.setInt(1, (Integer) session.getAttribute("userid"));
        rs = ps1.executeQuery();

        if (rs.next()) {
            int totalPoints = rs.getInt("total_best_score");
            String rank;

            if (totalPoints >= 170) {
                rank = "Apex";
            } else if (totalPoints >= 120) {
                rank = "GrandMaster";
            } else if (totalPoints >= 80) {
                rank = "Master";
            } else if (totalPoints >= 40) {
                rank = "Elite";
            } else {
                rank = "Rookie";
            }

            String updateSql = "UPDATE users SET total_points = ?, rank_name = ? WHERE user_id = ?";
            ps2 = con.prepareStatement(updateSql);
            ps2.setInt(1, totalPoints);
            ps2.setString(2, rank);
            ps2.setInt(3, (Integer) session.getAttribute("userid"));
            ps2.executeUpdate();
        }

    } catch(Exception e) {
        out.print("error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ex){}
        if (ps != null) try { ps.close(); } catch(Exception ex){}
        if (ps1 != null) try { ps1.close(); } catch(Exception ex){}
        if (ps2 != null) try { ps2.close(); } catch(Exception ex){}
        if (con != null) try { con.close(); } catch(Exception ex){}
    }
}
%>