<%@ include file="navbar.jsp"%>
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="head">
    <div class="trophy2"><i class="fa-solid fa-computer-mouse"></i></div>
    <div class="title2">Clicking Test</div></div>
    <div class="subtitle2">Click as fast as you can</div>
    <div class="card-holder"><div class="card">
            <div class="card-icon">Click</div>
            <div class="card-title"><div class="orange" id="click">0</div></div>
            <div class="card-desc">Total times clicked.</div>
        </div>
    <div class="card">
            <div class="card-icon">CPS</div>
            <div class="card-title"><div class="orange" id="cps">0</div></div>
            <div class="card-desc">Click per second.</div>
        </div>
        <div class="card">
            <div class="card-icon">Time</div>
            <div class="card-title"><div class="orange" id="time">0s</div></div>
            <div class="card-desc">Total elapsed duration of the challenge.</div>
        </div>
    </div>
    <button id="clickBtn" class="cbtn">Click me </button><br>
    <div class="textarea1" id="pointsDisplay"></div>
    <div class="textarea1" id="total"></div>
    <button id="restartBtn" class="btn1"> Restart</button><br>
    <%
        session.setAttribute("tid", 2);
    %>
    </form>
    <script src="js/script1.js"></script>
<%@ include file="footer.jsp"%>