USE cricket_db;

CREATE TABLE quarterly_performance (
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    player      VARCHAR(100),
    quarter     VARCHAR(10),
    runs        INT,
    batting_avg DECIMAL(6,2),
    centuries   INT
);

-- Time-series: quarterly runs, QoQ change, rolling 3-quarter average
SELECT
    player      AS "Player",
    quarter     AS "Quarter",
    runs        AS "Runs",
    batting_avg AS "Avg",
    centuries   AS "100s",
    runs - LAG(runs) OVER (PARTITION BY player ORDER BY quarter) AS "QoQ Change",
    AVG(runs) OVER (PARTITION BY player ORDER BY quarter
                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS "Rolling 3Q Avg"
FROM quarterly_performance
ORDER BY player, quarter;
