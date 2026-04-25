USE cricket_db;

CREATE TABLE player_rankings (
    rank_id     INT AUTO_INCREMENT PRIMARY KEY,
    rank_pos    INT,
    player      VARCHAR(100),
    country     VARCHAR(50),
    batting_avg DECIMAL(6,2),
    strike_rate DECIMAL(6,2),
    centuries   INT,
    fifties     INT,
    composite   DECIMAL(6,2)
);

-- Composite ranking (weighted avg-40%, SR-30%, 100s-20%, 50s-10%)
SELECT
    rank_pos    AS "Rank",
    player      AS "Player",
    country     AS "Country",
    batting_avg AS "Batting Avg",
    strike_rate AS "Strike Rate",
    centuries   AS "100s",
    fifties     AS "50s",
    composite   AS "Composite Score"
FROM player_rankings
ORDER BY rank_pos;
