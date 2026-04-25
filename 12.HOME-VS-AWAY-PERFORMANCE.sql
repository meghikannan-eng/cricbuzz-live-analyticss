USE cricket_db;

CREATE TABLE team_home_away (
    rec_id   INT AUTO_INCREMENT PRIMARY KEY,
    team     VARCHAR(80),
    location VARCHAR(10),
    played   INT,
    wins     INT,
    win_pct  DECIMAL(6,2)
);

-- Home vs Away performance for each team
SELECT
    team     AS "Team",
    location AS "Location",
    played   AS "Matches Played",
    wins     AS "Wins",
    win_pct  AS "Win %"
FROM team_home_away
ORDER BY team, location;
