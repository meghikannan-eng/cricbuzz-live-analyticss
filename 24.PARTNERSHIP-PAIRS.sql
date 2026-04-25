USE cricket_db;

CREATE TABLE partnership_pairs (
    rec_id                INT AUTO_INCREMENT PRIMARY KEY,
    batter1               VARCHAR(100),
    batter2               VARCHAR(100),
    innings               INT,
    total_runs            INT,
    avg_partnership       DECIMAL(6,2),
    century_partnerships  INT
);

-- Successful batting pairs ranked by average partnership
SELECT
    CONCAT(batter1,' & ',batter2) AS "Partnership",
    innings                       AS "Innings",
    total_runs                    AS "Total Runs",
    avg_partnership               AS "Avg Partnership",
    century_partnerships          AS "100+ Partnerships"
FROM partnership_pairs
ORDER BY avg_partnership DESC;
