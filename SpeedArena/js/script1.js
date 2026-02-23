var testDuration = 5;
var startTime = 0;
var timer = null;
var clicks = 0;
var points = 0;
let multiplier = 1;
var clickBtn = document.getElementById("clickBtn");
var restartBtn = document.getElementById("restartBtn");
var timeDisplay = document.getElementById("time");
var cpsDisplay = document.getElementById("cps");
var clickDisplay = document.getElementById("click");

function startTimer() {
  startTime = Date.now();

  timer = setInterval(function () {
    var elapsed = (Date.now() - startTime) / 1000;
    var remaining = testDuration - elapsed;

    if (remaining <= 0.0) {
      timeDisplay.innerText = "0.00";
      finishTest();
      return;
    }

    timeDisplay.innerText = remaining.toFixed(2);
  }, 10);
}

function finishTest() {
  clearInterval(timer);
  timer = null;

  clickBtn.disabled = true;

  var cps = clicks / testDuration;

  cpsDisplay.innerText = cps.toFixed(2);

  if (streak >= 15) {
    multiplier = 1.75;
  } else if (streak >= 10) {
    multiplier = 1.5;
  } else if (streak >= 5) {
    multiplier = 1.25;
  } else if (streak >= 1) {
    multiplier = 1.1;
  } else {
    multiplier = 1;
  }

  points = Math.round(clicks * multiplier);

  document.getElementById("pointsDisplay").innerText =
    "Score: " +
    Math.round(points / multiplier) +
    " X " +
    multiplier +
    " (Streak Bonus!!!)";

  document.getElementById("total").innerText = "Total: " + Math.round(points);
  fetch("saveScore.jsp", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: "points=" + points + "&pp=" + clicks,
  });
}

clickBtn.addEventListener("click", function () {
  if (!timer) startTimer();
  clicks++;
  clickDisplay.innerText = clicks;
});

function resetTest() {
  clearInterval(timer);
  timer = null;

  clicks = 0;

  clickBtn.disabled = false;
  document.getElementById("total").innerText = "";

  timeDisplay.innerText = testDuration.toFixed(2);
  cpsDisplay.innerText = "0.00";
  document.getElementById("pointsDisplay").innerText = "";
  clickDisplay.innerText = "0";
}

restartBtn.addEventListener("click", function () {
  resetTest();
});
