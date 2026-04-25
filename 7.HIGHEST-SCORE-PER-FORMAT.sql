USE cricket_db;

CREATE TABLE highest_individual_scores (
    record_id    INT AUTO_INCREMENT PRIMARY KEY,
    match_format VARCHAR(10),
    player_name  VARCHAR(100),
    country      VARCHAR(50),
    score        INT,
    opponent     VARCHAR(50),
    match_date   DATE
);

-- Highest score in each format
SELECT
    match_format AS "Format",
    player_name  AS "Player",
    country      AS "Country",
    score        AS "Score",
    opponent     AS "Opponent",
    match_date   AS "Match Date"
FROM highest_individual_scores
ORDER BY FIELD(match_format,'Test','ODI','T20I');
