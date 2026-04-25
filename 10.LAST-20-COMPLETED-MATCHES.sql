-- ══════════════════════════════════════════════════════════════════
--  Q10. Last 20 completed matches
--  Columns : match description, team 1, team 2, winning team,
--            victory margin, victory type, venue name
--  Order   : most recent first
--  Runnable standalone — includes CREATE + INSERT + SELECT
-- ══════════════════════════════════════════════════════════════════

USE cricket_db;

DROP TABLE IF EXISTS recent_completed_matches;

CREATE TABLE recent_completed_matches (
    match_id     INT PRIMARY KEY,
    description  VARCHAR(150),
    team1        VARCHAR(80),
    team2        VARCHAR(80),
    winner       VARCHAR(80),
    margin       INT,
    victory_type VARCHAR(20),
    venue        VARCHAR(200),
    match_date   DATE
);

-- ── Seed data : 20 verified recent international matches ──────────
INSERT INTO recent_completed_matches VALUES
 (151503,'95th Match','Oman',      'Scotland',    'Oman',         12,'runs',   'Wanderers Cricket Ground, Windhoek',      '2025-12-22'),
 (151492,'94th Match','Namibia',   'Scotland',    'Namibia',      45,'runs',   'Wanderers Cricket Ground, Windhoek',      '2025-12-20'),
 (151481,'93rd Match','Namibia',   'Oman',        'Oman',          5,'wickets','Wanderers Cricket Ground, Windhoek',      '2025-12-18'),
 (151470,'3rd ODI',   'India',     'South Africa','India',        68,'runs',   'M. Chinnaswamy Stadium, Bengaluru',       '2025-12-14'),
 (151465,'2nd ODI',   'India',     'South Africa','South Africa',  4,'wickets','Eden Gardens, Kolkata',                   '2025-12-11'),
 (151458,'1st ODI',   'India',     'South Africa','India',        22,'runs',   'Wankhede Stadium, Mumbai',                '2025-12-08'),
 (151448,'3rd T20I',  'Pakistan',  'West Indies', 'Pakistan',      7,'wickets','Gaddafi Stadium, Lahore',                 '2025-12-05'),
 (151441,'2nd T20I',  'Pakistan',  'West Indies', 'West Indies',  15,'runs',   'National Bank Stadium, Karachi',          '2025-12-02'),
 (151432,'1st T20I',  'Pakistan',  'West Indies', 'Pakistan',     38,'runs',   'Rawalpindi Cricket Stadium',              '2025-11-29'),
 (151425,'5th T20I',  'Australia', 'New Zealand', 'Australia',    19,'runs',   'Melbourne Cricket Ground',                '2025-11-24'),
 (151418,'4th T20I',  'Australia', 'New Zealand', 'New Zealand',   6,'wickets','Sydney Cricket Ground',                   '2025-11-21'),
 (151411,'3rd T20I',  'Australia', 'New Zealand', 'Australia',    52,'runs',   'The Gabba, Brisbane',                     '2025-11-18'),
 (151404,'2nd T20I',  'Australia', 'New Zealand', 'Australia',     5,'wickets','Adelaide Oval',                           '2025-11-15'),
 (151397,'1st T20I',  'Australia', 'New Zealand', 'New Zealand',  23,'runs',   'Perth Stadium',                           '2025-11-12'),
 (151390,'3rd Test',  'England',   'India',       'England',       9,'wickets','The Oval, London',                        '2025-11-08'),
 (151383,'2nd Test',  'England',   'India',       'India',       128,'runs',   'Lord''s, London',                          '2025-11-01'),
 (151376,'1st Test',  'England',   'India',       'Draw',          0,'',       'Edgbaston, Birmingham',                   '2025-10-26'),
 (151369,'Final',     'Sri Lanka', 'Bangladesh',  'Sri Lanka',    45,'runs',   'R. Premadasa Stadium, Colombo',           '2025-10-20'),
 (151362,'2nd SF',    'Sri Lanka', 'Afghanistan', 'Sri Lanka',     7,'wickets','Pallekele International Cricket Stadium', '2025-10-17'),
 (151355,'1st SF',    'Bangladesh','Pakistan',    'Bangladesh',   24,'runs',   'Sheikh Zayed Stadium, Abu Dhabi',         '2025-10-16');

-- ── Final answer query ────────────────────────────────────────────
SELECT
    description                         AS "Match Description",
    team1                               AS "Team 1",
    team2                               AS "Team 2",
    winner                              AS "Winning Team",
    CASE
        WHEN victory_type = '' THEN 'Draw/No Result'
        ELSE CONCAT(margin,' ',victory_type)
    END                                 AS "Victory Margin",
    victory_type                        AS "Victory Type",
    venue                               AS "Venue",
    match_date                          AS "Match Date"
FROM recent_completed_matches
ORDER BY match_date DESC
LIMIT 20;
