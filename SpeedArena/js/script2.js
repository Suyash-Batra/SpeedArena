/* ================= SETTINGS ================= */

var startTime = 0; // When green appears
var timeout = null; // Random delay timer
var waiting = false; // Waiting for green?
var ready = false; // Green appeared?
var reactionTime = 0; // Final reaction time
let multiplier = 1;

/* ================= GET ELEMENTS ================= */

var reactBtn = document.getElementById("ReactBtn");
var restartBtn = document.getElementById("restartBtn");
var timeDisplay = document.getElementById("time");
var pointsDisplay = document.getElementById("pointsDisplay");

/* ================= INITIAL STATE ================= */

timeDisplay.innerText = "0 ms";
pointsDisplay.innerText = "";

/* ================= START TEST ================= */

function startTest() {
  reactBtn.innerText = "Wait for green...";
  reactBtn.style.backgroundColor = "red";

  waiting = true;
  ready = false;

  // Random delay between 2–5 seconds
  var randomDelay = Math.floor(Math.random() * 3000) + 2000;

  timeout = setTimeout(function () {
    reactBtn.innerText = "CLICK!";
    reactBtn.style.backgroundColor = "green";

    startTime = Date.now();
    waiting = false;
    ready = true;
  }, randomDelay);
}

/* ================= BUTTON CLICK ================= */

reactBtn.addEventListener("click", function () {
  // If game hasn't started yet → start
  if (!waiting && !ready) {
    startTest();
    return;
  }

  // If clicked too early
  if (waiting) {
    clearTimeout(timeout);
    reactBtn.innerText = "Too Early! Click to try again";
    reactBtn.style.backgroundColor = "gray";
    waiting = false;
    return;
  }

  // If green and ready
  if (ready) {
    reactionTime = Date.now() - startTime;

    timeDisplay.innerText = reactionTime + " ms";

    // Simple scoring (lower time = more points)
    var maxTime = 1000; // Anything slower than 500ms = 0 points
    var maxPoints = 60; // Match other tests (30–60 range)

    var points = 0;

    if (reactionTime <= maxTime) {
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

      points = Math.floor(
        ((maxTime - reactionTime) / maxTime) * maxPoints * multiplier,
      );
    }

    document.getElementById("pointsDisplay").innerText =
      "Score: " +
      Math.round(points / multiplier) +
      " X " +
      multiplier +
      " (Streak Bonus!!!)";

    document.getElementById("total").innerText = "Total: " + Math.round(points);

    reactBtn.innerText = "Click to try again";
    reactBtn.style.backgroundColor = "gray";

    ready = false;

    // Send score to backend
    fetch("saveScore.jsp", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "points=" + points + "&pp=" + reactionTime,
    });
  }
});

/* ================= RESTART ================= */

restartBtn.addEventListener("click", function () {
  clearTimeout(timeout);

  waiting = false;
  ready = false;

  timeDisplay.innerText = "0 ms";
  pointsDisplay.innerText = "Score: 0";
  document.getElementById("total").innerText = "";
  reactBtn.innerText = "Click me";
  reactBtn.style.backgroundColor = "";
});
