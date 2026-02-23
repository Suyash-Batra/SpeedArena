<%@ include file="navbar.jsp"%>
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="head">
    <div class="trophy2"><i class="fa-solid fa-bolt"></i></div>
    <div class="title2">Reaction Test</div></div>
    <div class="subtitle2">Click as soon as the box turns green.</div>
    <div class="card-holder">
        <div class="card">
            <div class="card-icon">Time</div>
            <div class="card-title"><div class="orange" id="time">0s</div></div>
            <div class="card-desc">Total elapsed duration of the challenge.</div>
        </div>
    </div>
    <button id="ReactBtn" class="cbtn">Click me </button><br>
    <div class="textarea1" id="pointsDisplay"></div>
    <div class="textarea1" id="total"></div>
    <button id="restartBtn" class="btn1"> Restart</button><br>
    <%
        session.setAttribute("tid", 3);
    %>
    </form>
    <script src="js/script2.js"></script>
<%@ include file="footer.jsp"%>