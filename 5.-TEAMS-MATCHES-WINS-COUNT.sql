USE cricket_db;

-- Show all tables
SHOW TABLES;

-- ===== TEAMS TABLE =====
SELECT '=== TEAMS TABLE ===' AS info;
SELECT * FROM teams;
SELECT COUNT(*) as 'Total Teams' FROM teams;

-- ===== MATCHES TABLE =====
SELECT '=== MATCHES TABLE ===' AS info;
SELECT * FROM matches LIMIT 10;
SELECT COUNT(*) as 'Total Matches' FROM matches;

-- ===== TEAM_WINS TABLE =====
SELECT '=== TEAM_WINS TABLE ===' AS info;
SELECT * FROM team_wins;
SELECT COUNT(*) as 'Total Teams with Wins' FROM team_wins;

-- ===== SUMMARY =====
SELECT '=== SUMMARY STATISTICS ===' AS info;
SELECT 
    (SELECT COUNT(*) FROM teams) as Total_Teams,
    (SELECT COUNT(*) FROM matches) as Total_Matches,
    (SELECT COUNT(*) FROM team_wins) as Teams_With_Wins;

-- ===== WINNERS BREAKDOWN =====
SELECT '=== WINNERS BREAKDOWN ===' AS info;
SELECT winner, COUNT(*) as count 
FROM matches 
GROUP BY winner 
ORDER BY count DESC;

-- ===== TOP TEAMS =====
SELECT '=== TOP 5 TEAMS BY WINS ===' AS info;
SELECT team_name, total_wins 
FROM team_wins 
ORDER BY total_wins DESC 