# Speed Arena ⚡

Speed Arena is a high-performance web application designed to test and improve user skills in typing speed, clicking accuracy, and reaction time. Compete against others to climb the leaderboard and reach the **Apex** rank!

## 🚀 Deployment Status
The application is officially migrated to the cloud:
* **Hosting:** Render (Tomcat 9 Docker Container)
* **Database:** TiDB Serverless (MySQL Protocol)
* **Live Link:** https://speedarena.onrender.com/login.jsp

## ✨ Features
* **Three Core Tests:** Typing speed, click speed, and reaction time.
* **Ranking System:** 5 tiers – Rookie, Elite, Master, GrandMaster, and Apex.
* **Leaderboard:** Global real-time rankings based on total points.
* **Streak System:** Rewards daily login consistency with point multipliers.
* **Dynamic Dashboard:** Interactive game cards rendering live `<i>` icons from the database.

## 🛠️ Technologies Used
* **Frontend:** JSP, HTML5, CSS3 (Responsive Grid), JavaScript (ES6)
* **Backend:** Java Servlets, JDBC
* **Database:** **TiDB Cloud (MySQL Compatible)**
* **Icons:** Font Awesome 6.5.1 (Solid)

## 🗄️ Database Schema (TiDB / MySQL)
Run the following script in your TiDB console to initialize your tables. 

> **Note:** We use `INT AUTO_INCREMENT` instead of PostgreSQL's `SERIAL`, and icons are stored as full HTML strings (e.g., `<i class="fa-solid fa-trophy"></i>`).

```sql
-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    total_points INT DEFAULT 0,
    rank_name VARCHAR(50) DEFAULT 'Rookie',
    streak INT DEFAULT 0,
    last_login DATE
);

-- 2. Tests Table
CREATE TABLE tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(50),
    description TEXT,
    avg_points INT,
    icon TEXT, 
    href TEXT
);

-- 3. Paragraphs Table
CREATE TABLE para (
    para_id INT AUTO_INCREMENT PRIMARY KEY,
    paragraphs TEXT
);

-- 4. Scores Table
CREATE TABLE scores (
    score_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    test_id INT,
    score INT,
    point INT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_test FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE
);
```

## 📂 Project Structure
```text
SpeedArena/
├─ css/                 # CSS files
├─ js/                  # JavaScript files for typing, clicking, reaction tests
├─ images/              # Icons and rank images
├─ WEB-INF/
│   ├─ classes/         # Compiled Java classes
│   └─ lib/             # Servlet API libraries
├─ navbar.jsp            # Navigation bar
├─ footer.jsp            # Footer
├─ dashboard.jsp         # User dashboard
├─ typing.jsp            # Typing test page
├─ click.jsp             # Click test page
├─ reaction.jsp          # Reaction test page
├─ saveScore.jsp         # Save user scores
├─ profile.jsp           # User profile
├─ leaderboard.jsp       # Full leaderboard
├─ login.jsp             # Login page
├─ register.jsp          # Registration page
└─ README.md            # Project documentation
```

## ⚙️ Environment Variables
The application requires these variables to be set in the Render Dashboard:
* `DB_URL` – `jdbc:mysql://<host>:4000/test?sslMode=VERIFY_IDENTITY`
* `DB_USER` – Your TiDB username
* `DB_PASS` – Your TiDB password

## 📜 License
This project is open-source. Feel free to use it for learning or personal development.
