USE cricket_db;

CREATE TABLE toss_advantage (
    rec_id        INT AUTO_INCREMENT PRIMARY KEY,
    team          VARCHAR(80),
    toss_decision VARCHAR(10),
    toss_wins     INT,
    match_wins    INT,
    match_win_pct DECIMAL(6,2)
);

-- How often did teams win the match when they also won the toss?
SELECT
    team          AS "Team",
    toss_decision AS "Toss Decision",
    toss_wins     AS "Toss Wins",
    match_wins    AS "Match Wins",
    match_win_pct AS "Match Win %"
FROM toss_advantage
ORDER BY match_win_pct DESC;
