-- Table 1: Store all players
CREATE TABLE players (
    player_id VARCHAR(50) PRIMARY KEY,      -- Unique ID from API
    player_name VARCHAR(150),               -- Player name
    playing_role VARCHAR(50),               -- BATSMEN, BOWLERS, ALL-ROUNDERS, WICKET-KEEPERS
    country VARCHAR(50)                     -- Which team country
);

-- Table 2: Count players by role
CREATE TABLE player_role_count (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    playing_role VARCHAR(50) UNIQUE,        -- Role name
    player_count INT                        -- How many players have this role
);
-- See all players
SELECT * FROM players LIMIT 10;

-- See role counts
SELECT * FROM player_role_count;

-- See percentages
SELECT 
    playing_role,
    player_count,
    ROUND((player_count * 100.0 / (SELECT SUM(player_count) FROM player_role_count)), 2) as percentage
FROM player_role_count
ORDER BY player_count DESC;

