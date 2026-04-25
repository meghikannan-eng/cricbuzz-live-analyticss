USE cricket_db;

CREATE TABLE recent_form (
    rec_id          INT AUTO_INCREMENT PRIMARY KEY,
    player          VARCHAR(100),
    innings_sampled INT,
    recent_avg      DECIMAL(6,2),
    recent_stdev    DECIMAL(6,2),
    form            VARCHAR(20)
);

-- Player form bucket based on last 10-innings average
SELECT
    player          AS "Player",
    innings_sampled AS "Innings",
    recent_avg      AS "Recent Avg",
    recent_stdev    AS "StdDev",
    form            AS "Form"
FROM recent_form
ORDER BY recent_avg DESC;
