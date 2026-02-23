<%@ page import="java.sql.*" %> 
<%
String pointsStr = request.getParameter("points");
String point = request.getParameter("pp");
if(pointsStr != null && point != null)
{
int points = Integer.parseInt(pointsStr);
int score = Integer.parseInt(point);

    Connection con = null;
    PreparedStatement ps = null;

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
        ps.setDouble(3, points);
        ps.setInt(4, score);

        ps.executeUpdate();

        PreparedStatement ps1 = con.prepareStatement("SELECT SUM(max_score) AS total_best_score FROM (SELECT MAX(score) AS max_score FROM scores WHERE user_id = ? GROUP BY test_id) AS best_scores");

        ps1.setInt(1, (Integer) session.getAttribute("userid"));

        ResultSet rs = ps1.executeQuery();

        if(rs.next()) {
            int totalPoints = rs.getInt(1);
            String rank;

            if (totalPoints >= 150) {
                rank = "Apex";
            } else if (totalPoints >= 130) {
                rank = "GrandMaster";
            } else if (totalPoints >= 100) {
                rank = "Master";
            } else if (totalPoints >= 80) {
                rank = "Elite";
            } else {
                rank = "Rookie";
            }

            PreparedStatement ps2 = con.prepareStatement("update users set total_points = ?, rank_name = ? where user_id = ?");
            ps2.setInt(1, totalPoints);
            ps2.setString(2, rank);
            ps2.setInt(3, (Integer) session.getAttribute("userid"));
            ps2.executeUpdate();
        }

    } catch(Exception e) {
    out.print("error");
  }
}
%>
