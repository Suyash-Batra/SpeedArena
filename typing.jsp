<%@ include file="navbar.jsp" %>
<a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>

<div class="head">
    <div class="trophy2"><i class="fa-regular fa-keyboard"></i></div>
    <div class="title2">Typing Test</div>
</div>

<div class="subtitle2">Type the paragraph below as fast as you can</div>

<div class="card-holder">
    <div class="card">
        <div class="card-icon">WPM</div>
        <div class="card-title"><div class="orange" id="wpm">0</div></div>
        <div class="card-desc">Words per minute.</div>
    </div>
    <div class="card">
        <div class="card-icon">Accuracy</div>
        <div class="card-title"><div class="orange" id="accuracy">0%</div></div>
        <div class="card-desc">Percentage of successful hits vs total attempts.</div>
    </div>
    <div class="card">
        <div class="card-icon">Time</div>
        <div class="card-title"><div class="orange" id="time">0s</div></div>
        <div class="card-desc">Total elapsed duration of the challenge.</div>
    </div>
</div>

<h4 style="color: #666; font-family: 'Orbitron', sans-serif;">Click the below textarea to start.</h4><br>

<div id="textDisplay" class="textarea"></div>
<div id="pointsDisplay" class="textarea1"></div>
<div class="textarea1" id="total"></div><br>

<textarea id="input" onpaste="return false"></textarea>
<button onclick="resetTest()" class="btn1">Restart</button>

<%
    session.setAttribute("tid", 1);
    String randtext = "";

    try {
    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");
            Connection conLocal = DriverManager.getConnection(url, user, pass);
            PreparedStatement rt = conLocal.prepareStatement("SELECT * FROM para ORDER BY RANDOM() LIMIT 1");
            ResultSet rpara = rt.executeQuery();

        Class.forName("org.postgresql.Driver");

        if (rpara.next()) {
            randtext = rpara.getString("paragraphs");
        }

    } catch(Exception e) {
        out.println("Error fetching paragraph: " + e.getMessage());
    }
%>
</form>

<script>
    var text = `<%= randtext.replace("`","\\`") %>`;
</script>

<%@ include file="footer.jsp" %>
<script src="js/script.js"></script>
</body>
</html>