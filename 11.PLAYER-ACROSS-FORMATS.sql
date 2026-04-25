USE cricket_db;

CREATE TABLE player_format_career (
    rec_id       INT AUTO_INCREMENT PRIMARY KEY,
    player_name  VARCHAR(100),
    country      VARCHAR(50),
    match_format VARCHAR(10),
    total_runs   INT,
    batting_avg  DECIMAL(6,2)
);

-- Player performance across Test / ODI / T20I — must have played >=2 formats
SELECT
    player_name AS "Player",
    country     AS "Country",
    SUM(CASE WHEN match_format='Test' THEN total_runs END) AS "Test Runs",
    SUM(CASE WHEN match_format='ODI'  THEN total_runs END) AS "ODI Runs",
    SUM(CASE WHEN match_format='T20I' THEN total_runs END) AS "T20I Runs",
    ROUND(AVG(batting_avg),2)                              AS "Overall Avg"
FROM player_format_career
GROUP BY player_name, country
HAVING SUM(CASE WHEN total_runs>0 THEN 1 ELSE 0 END) >= 2
ORDER BY "Overall Avg" DESC;
