USE cricket_db;

CREATE TABLE bowler_venue_stats (
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    bowler      VARCHAR(100),
    country     VARCHAR(50),
    venue       VARCHAR(150),
    matches     INT,
    wickets     INT,
    bowling_avg DECIMAL(6,2)
);

-- Bowlers with >= 3 matches at each venue, ranked by wickets
SELECT
    bowler      AS "Bowler",
    country     AS "Country",
    venue       AS "Venue",
    matches     AS "Matches",
    wickets     AS "Wickets",
    bowling_avg AS "Bowling Avg"
FROM bowler_venue_stats
WHERE matches >= 3
ORDER BY wickets DESC;
