USE cricket_db;

CREATE TABLE format_dominance (
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    player      VARCHAR(100),
    fmt         VARCHAR(10),
    batting_avg DECIMAL(6,2),
    strike_rate DECIMAL(6,2)
);

-- Dominance per format: ranked by batting average within each format
SELECT
    player      AS "Player",
    fmt         AS "Format",
    batting_avg AS "Batting Avg",
    strike_rate AS "Strike Rate",
    RANK() OVER (PARTITION BY fmt ORDER BY batting_avg DESC) AS "Format Rank"
FROM format_dominance
ORDER BY fmt, "Format Rank";
