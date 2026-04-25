USE cricket_db;

CREATE TABLE batsman_consistency (
    rec_id            INT AUTO_INCREMENT PRIMARY KEY,
    player            VARCHAR(100),
    innings           INT,
    avg_runs          DECIMAL(6,2),
    score_stdev       DECIMAL(6,2),
    consistency_score DECIMAL(6,3)
);

-- Most consistent batsmen (higher score = higher avg with lower std-dev)
SELECT
    player            AS "Player",
    innings           AS "Innings",
    avg_runs          AS "Avg Runs",
    score_stdev       AS "Score StdDev",
    consistency_score AS "Consistency"
FROM batsman_consistency
ORDER BY consistency_score DESC;
