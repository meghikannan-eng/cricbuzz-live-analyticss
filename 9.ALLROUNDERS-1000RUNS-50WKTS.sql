USE cricket_db;

CREATE TABLE allrounders (
    rec_id        INT AUTO_INCREMENT PRIMARY KEY,
    player_name   VARCHAR(100),
    country       VARCHAR(50),
    match_format  VARCHAR(10),
    total_runs    INT,
    total_wickets INT
);

-- All-rounders with >1000 runs AND >50 wickets, grouped by format
SELECT
    player_name    AS "Player",
    country        AS "Country",
    match_format   AS "Format",
    total_runs     AS "Runs",
    total_wickets  AS "Wickets"
FROM allrounders
WHERE total_runs > 1000
  AND total_wickets > 50
ORDER BY match_format, total_runs DESC;
