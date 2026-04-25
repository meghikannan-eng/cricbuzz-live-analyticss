USE cricket_db;

CREATE TABLE economical_bowlers (
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    bowler      VARCHAR(100),
    country     VARCHAR(50),
    fmt         VARCHAR(10),
    wickets     INT,
    economy     DECIMAL(4,2),
    bowling_avg DECIMAL(6,2)
);

-- Most economical bowlers in ODI / T20I, ranked within each format
SELECT
    fmt          AS "Format",
    bowler       AS "Bowler",
    country      AS "Country",
    wickets      AS "Wickets",
    economy      AS "Economy",
    bowling_avg  AS "Bowling Avg",
    RANK() OVER (PARTITION BY fmt ORDER BY economy ASC) AS "Econ Rank"
FROM economical_bowlers
ORDER BY fmt, "Econ Rank";
