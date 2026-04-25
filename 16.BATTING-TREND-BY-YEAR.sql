USE cricket_db;

CREATE TABLE batting_year_trend (
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    player      VARCHAR(100),
    year        INT,
    runs        INT,
    batting_avg DECIMAL(6,2),
    centuries   INT
);

-- Year-by-year batting trend with year-over-year change
SELECT
    player      AS "Player",
    year        AS "Year",
    runs        AS "Runs",
    batting_avg AS "Avg",
    centuries   AS "100s",
    runs - LAG(runs) OVER (PARTITION BY player ORDER BY year) AS "YoY Change"
FROM batting_year_trend
WHERE year >= 2020
ORDER BY player, year;
