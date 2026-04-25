-- Create database
CREATE DATABASE IF NOT EXISTS cricket_db;
USE cricket_db;

CREATE TABLE odi_run_scorers (
    player_id    INT AUTO_INCREMENT PRIMARY KEY,
    player_name  VARCHAR(100) NOT NULL,
    country      VARCHAR(50),
    total_runs   INT,
    batting_avg  DECIMAL(6,2),
    centuries    INT
);
SELECT
    RANK() OVER (ORDER BY total_runs DESC) AS rank_position,
    player_name,
    country,
    total_runs,
    batting_avg,
    centuries
FROM odi_run_scorers
ORDER BY total_runs DESC