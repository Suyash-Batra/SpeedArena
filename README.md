Speed Arena

Speed Arena is a web application to test and improve user skills in typing, clicking, and reaction time. Users compete for points, rank tiers, and leaderboard positions.


Features

- Three Tests: Typing speed, click speed, reaction time.
- Ranking System: 5 tiers – Rookie, Elite, Master, GrandMaster, Apex.
- Leaderboard: Shows top performers and total points.
- Streak System: Daily login streak gives bonus multipliers.
- User Profile: Displays personal bests and averages for all tests.
- Dynamic Points Update: Scores update total points and rank automatically.

Technologies Used

- Frontend: JSP, HTML, CSS, JavaScript
- Backend: Java Servlets, JSP
- Database: PostgreSQL
- Other: Font Awesome icons, Google Fonts


Database Setup

1. Create a PostgreSQL database (e.g., `speedarena`).
2. Run the provided SQL scripts to create tables:

```sql
-- Example tables:
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    total_points INT DEFAULT 0,
    rank_name VARCHAR(50) DEFAULT 'Rookie',
    streak INT DEFAULT 0,
    last_login DATE
);

CREATE TABLE tests (
    test_id SERIAL PRIMARY KEY,
    test_name VARCHAR(50),
    description TEXT,
    avg_points INT,
    icon TEXT,
    href TEXT
);

CREATE TABLE para (
    para_id SERIAL PRIMARY KEY,
    paragraphs TEXT
);

CREATE TABLE scores (
    score_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    test_id INT REFERENCES tests(test_id) ON DELETE CASCADE,
    score INT,
    point INT
);

3. Insert initial data into tests and para using the provided SQL files.



Project Structure

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


Environment Variables

Set the following environment variables for database connection:

DB_URL – PostgreSQL connection URL (e.g., jdbc:postgresql://localhost:5432/speedarena)

DB_USER – Database username

DB_PASS – Database password


How to Run

1. Deploy the project on a Tomcat server.


2. Ensure PostgreSQL is running and the environment variables are set.


3. Access the application in a browser (e.g., http://localhost:8080/SpeedArena).


4. Register a new user, try all three tests, and watch points, ranks, and leaderboard update dynamically.


Usage Notes

Typing Test: Random paragraphs from para table.

Click Test: Users click a target as fast as possible.

Reaction Test: Users react to prompts with minimal latency.

Profile Page: Shows best and average scores, streak, and rank.

Leaderboard: Shows top performers with ranks and points.


License

This project is open source. You can modify and use it for learning or personal use.