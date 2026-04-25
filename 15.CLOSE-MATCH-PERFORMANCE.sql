USE cricket_db;

CREATE TABLE close_match_performance (
    rec_id     INT AUTO_INCREMENT PRIMARY KEY,
    player     VARCHAR(100),
    country    VARCHAR(50),
    innings    INT,
    total_runs INT,
    wins       INT,
    avg_runs   DECIMAL(6,2),
    win_pct    DECIMAL(6,2)
);

-- Players in close matches (<50-run or <5-wicket margins)
SELECT
    player     AS "Player",
    country    AS "Country",
    innings    AS "Close Innings",
    total_runs AS "Total Runs",
    wins       AS "Team Wins",
    avg_runs   AS "Avg Runs",
    win_pct    AS "Win %"
FROM close_match_performance
ORDER BY win_pct DESC, avg_runs DESC;
