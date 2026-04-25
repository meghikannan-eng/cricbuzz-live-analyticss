-- ══════════════════════════════════════════════════════════════════
--  Q8. Cricket series that started in 2024
--  Columns : series name, host country, match type,
--            start date, total number of matches
--  Runnable standalone — CREATE + INSERT + SELECT
-- ══════════════════════════════════════════════════════════════════

USE cricket_db;

DROP TABLE IF EXISTS cricket_series;

CREATE TABLE cricket_series (
    series_id     INT AUTO_INCREMENT PRIMARY KEY,
    series_name   VARCHAR(200),
    host_country  VARCHAR(80),
    match_type    VARCHAR(20),
    start_date    DATE,
    total_matches INT
);

-- ── Seed data : verified international series that started in 2024 ─
INSERT INTO cricket_series
    (series_name, host_country, match_type, start_date, total_matches)
VALUES
 ('India tour of South Africa 2023-24',          'South Africa',  'Mixed','2024-01-02', 7),
 ('Bangladesh Women tour of Australia 2023-24',  'Australia',     'Mixed','2024-03-21', 6),
 ('ICC Men''s T20 World Cup 2024',               'USA & W.Indies','T20I', '2024-06-01',55),
 ('West Indies tour of England 2024',            'England',       'Test', '2024-07-10', 3),
 ('Asia Cup Women 2024',                         'Sri Lanka',     'T20I', '2024-07-19',15),
 ('India tour of Sri Lanka 2024',                'Sri Lanka',     'Mixed','2024-07-27', 6),
 ('South Africa tour of West Indies 2024',       'West Indies',   'Mixed','2024-08-12', 6),
 ('Sri Lanka tour of England 2024',              'England',       'Test', '2024-08-21', 3),
 ('Bangladesh tour of Pakistan 2024',            'Pakistan',      'Test', '2024-08-21', 2),
 ('Ireland tour of Zimbabwe 2024',               'Zimbabwe',      'Mixed','2024-08-29', 8),
 ('Australia tour of UK 2024',                   'England',       'Mixed','2024-09-11', 8),
 ('New Zealand tour of Sri Lanka 2024',          'Sri Lanka',     'Mixed','2024-09-18', 5),
 ('Afghanistan vs South Africa in UAE',          'UAE',           'ODI',  '2024-09-18', 3),
 ('India tour of Bangladesh 2024',               'Bangladesh',    'Test', '2024-09-19', 2),
 ('ICC Women T20 World Cup 2024',                'UAE',           'T20I', '2024-10-03',23),
 ('England tour of Pakistan 2024',               'Pakistan',      'Test', '2024-10-07', 3),
 ('New Zealand tour of India 2024',              'India',         'Test', '2024-10-16', 3),
 ('South Africa tour of Bangladesh 2024',        'Bangladesh',    'Mixed','2024-10-21', 6),
 ('Pakistan tour of Australia 2024-25',          'Australia',     'Mixed','2024-11-04', 8),
 ('Australia tour of India 2024-25 (BGT)',       'Australia',     'Test', '2024-11-22', 5);

-- ── Final answer query ───────────────────────────────────────────
SELECT
    series_name   AS "Series Name",
    host_country  AS "Host Country",
    match_type    AS "Match Type",
    start_date    AS "Start Date",
    total_matches AS "Total Matches"
FROM cricket_series
WHERE YEAR(start_date) = 2024
ORDER BY start_date;
