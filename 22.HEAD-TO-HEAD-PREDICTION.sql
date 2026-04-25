USE cricket_db;

CREATE TABLE head_to_head (
    rec_id            INT AUTO_INCREMENT PRIMARY KEY,
    team_a            VARCHAR(80),
    team_b            VARCHAR(80),
    fmt               VARCHAR(10),
    played            INT,
    a_wins            INT,
    b_wins            INT,
    others            INT,
    a_win_pct         DECIMAL(6,2),
    b_win_pct         DECIMAL(6,2),
    predicted_winner  VARCHAR(80)
);

-- Head-to-head record and simple predicted winner (higher historical win %)
SELECT
    CONCAT(team_a,' vs ',team_b) AS "Matchup",
    fmt               AS "Format",
    played            AS "Played",
    a_wins            AS "Team A Wins",
    b_wins            AS "Team B Wins",
    a_win_pct         AS "Team A Win %",
    b_win_pct         AS "Team B Win %",
    predicted_winner  AS "Predicted Winner"
FROM head_to_head
ORDER BY played DESC;
