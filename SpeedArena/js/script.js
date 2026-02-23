var testDuration = 15;
var startTime = 0;
var timer = null;
var testFinished = false;
let multiplier = 1;
var display = document.getElementById("textDisplay");
var input = document.getElementById("input");

function loadText() {
  display.innerHTML = "";

  for (var i = 0; i < text.length; i++) {
    var span = document.createElement("span");
    span.innerText = text[i];
    span.className = "char";
    display.appendChild(span);
  }

  if (display.children.length > 0) {
    display.children[0].classList.add("current");
  }
}

loadText();

function startTimer() {
  startTime = Date.now();

  timer = setInterval(function () {
    var elapsed = (Date.now() - startTime) / 1000;
    var remaining = testDuration - elapsed;

    if (remaining <= 0) {
      document.getElementById("time").innerText = "0.00";
      finishTest();
      return;
    }

    document.getElementById("time").innerText = remaining.toFixed(2);
  }, 50);
}

function finishTest() {
  if (testFinished) return;
  testFinished = true;

  clearInterval(timer);
  timer = null;

  input.disabled = true;

  var wpm = parseInt(document.getElementById("wpm").innerText);
  var accuracy = parseFloat(document.getElementById("accuracy").innerText);

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

  var points = Math.round(wpm * (accuracy / 100) * multiplier);

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
    body: "points=" + points + "&pp=" + wpm,
  });
}

input.addEventListener("input", function () {
  if (testFinished) return;

  if (!timer) startTimer();

  var typed = input.value;
  var spans = display.querySelectorAll("span");

  var correct = 0;

  for (var i = 0; i < spans.length; i++) {
    spans[i].className = "char";

    if (typed[i] == null) {
      if (i === typed.length) {
        spans[i].classList.add("current");
      }
    } else if (typed[i] === spans[i].innerText) {
      spans[i].classList.add("correct");
      correct++;
    } else {
      spans[i].classList.add("wrong");
    }
  }

  updateStats(correct, typed.length);

  if (typed === text) {
    finishTest();
  }
});

function updateStats(correctChars, totalTyped) {
  var elapsed = (Date.now() - startTime) / 1000;

  if (elapsed < 1) return;

  var wpm = (correctChars / 5 / elapsed) * 60;
  document.getElementById("wpm").innerText = Math.max(0, Math.round(wpm));

  var accuracy = totalTyped > 0 ? (correctChars / totalTyped) * 100 : 0;

  document.getElementById("accuracy").innerText = accuracy.toFixed(1);
}

function resetTest() {
  clearInterval(timer);
  timer = null;
  testFinished = false;

  input.disabled = false;
  input.value = "";

  document.getElementById("time").innerText = testDuration.toFixed(2);
  document.getElementById("wpm").innerText = "0";
  document.getElementById("accuracy").innerText = "0";
  document.getElementById("pointsDisplay").innerText = "";
  document.getElementById("total").innerText = "";
  window.location.reload();

  loadText();
}

document.body.onclick = function () {
  input.focus();
};
