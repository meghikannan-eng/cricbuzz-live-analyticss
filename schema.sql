-- ══════════════════════════════════════════════════════════════════════
--  Cricbuzz Live Analytics  --  Consolidated Database Schema
--  ─────────────────────────────────────────────────────────
--  Creates the `cricket_db` database plus every table used by
--  the 25 SQL analytical questions, with a small sample-data
--  seed so queries return output out of the box.
--
--  Usage:
--      mysql -u root -p < schema.sql
-- ══════════════════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS cricket_db;
USE cricket_db;

-- ── Core reference tables ────────────────────────────────────────────

DROP TABLE IF EXISTS players;
CREATE TABLE players (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100),
    fullName     VARCHAR(150),
    role         VARCHAR(100),
    battingStyle VARCHAR(100),
    bowlingStyle VARCHAR(100),
    teamName     VARCHAR(100)
);

DROP TABLE IF EXISTS teams;
CREATE TABLE teams (
    team_id   INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) UNIQUE,
    country   VARCHAR(100)
);

DROP TABLE IF EXISTS matches;
CREATE TABLE matches (
    matchId     VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255),
    team1       VARCHAR(100),
    team2       VARCHAR(100),
    winner      VARCHAR(100),
    venueName   VARCHAR(150),
    venueCity   VARCHAR(100),
    matchDate   VARCHAR(50)
);

DROP TABLE IF EXISTS team_wins;
CREATE TABLE team_wins (
    team_name  VARCHAR(100) PRIMARY KEY,
    total_wins INT
);

DROP TABLE IF EXISTS cricket_venues;
CREATE TABLE cricket_venues (
    venue_id   INT AUTO_INCREMENT PRIMARY KEY,
    venue_name VARCHAR(150) NOT NULL,
    city       VARCHAR(100),
    country    VARCHAR(100),
    capacity   INT
);

DROP TABLE IF EXISTS odi_run_scorers;
CREATE TABLE odi_run_scorers (
    player_id   INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    country     VARCHAR(50),
    total_runs  INT,
    batting_avg DECIMAL(6,2),
    centuries   INT
);

DROP TABLE IF EXISTS player_role_count;
CREATE TABLE player_role_count (
    role_id      INT AUTO_INCREMENT PRIMARY KEY,
    playing_role VARCHAR(50) UNIQUE,
    player_count INT
);

-- ── Analytical tables (Q7 .. Q25) ────────────────────────────────────

DROP TABLE IF EXISTS highest_individual_scores;
CREATE TABLE highest_individual_scores (
    player_name VARCHAR(120),
    format      VARCHAR(10),
    score       INT,
    opponent    VARCHAR(80),
    venue       VARCHAR(150),
    match_date  DATE
);

DROP TABLE IF EXISTS cricket_series;
CREATE TABLE cricket_series (
    series_id     INT AUTO_INCREMENT PRIMARY KEY,
    series_name   VARCHAR(200),
    host_country  VARCHAR(80),
    match_type    VARCHAR(20),
    start_date    DATE,
    total_matches INT
);

DROP TABLE IF EXISTS allrounders;
CREATE TABLE allrounders (
    player_name  VARCHAR(120) PRIMARY KEY,
    country      VARCHAR(80),
    format       VARCHAR(10),
    runs         INT,
    wickets      INT
);

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

DROP TABLE IF EXISTS player_format_stats;
CREATE TABLE player_format_stats (
    player_name VARCHAR(120),
    format      VARCHAR(10),
    runs        INT,
    batting_avg DECIMAL(6,2)
);

DROP TABLE IF EXISTS home_away_performance;
CREATE TABLE home_away_performance (
    team     VARCHAR(80),
    location VARCHAR(10),
    played   INT,
    won      INT,
    lost     INT
);

DROP TABLE IF EXISTS partnerships;
CREATE TABLE partnerships (
    match_id     INT,
    innings_no   INT,
    wicket_no    INT,
    batter1      VARCHAR(120),
    batter2      VARCHAR(120),
    runs         INT
);

DROP TABLE IF EXISTS bowler_venue_stats;
CREATE TABLE bowler_venue_stats (
    bowler   VARCHAR(120),
    venue    VARCHAR(150),
    matches  INT,
    wickets  INT,
    economy  DECIMAL(5,2)
);

DROP TABLE IF EXISTS close_matches;
CREATE TABLE close_matches (
    match_id   INT PRIMARY KEY,
    team1      VARCHAR(80),
    team2      VARCHAR(80),
    winner     VARCHAR(80),
    margin     INT,
    match_date DATE
);

DROP TABLE IF EXISTS player_yearly_stats;
CREATE TABLE player_yearly_stats (
    player_name VARCHAR(120),
    year        INT,
    runs        INT,
    average     DECIMAL(6,2)
);

DROP TABLE IF EXISTS toss_results;
CREATE TABLE toss_results (
    match_id    INT PRIMARY KEY,
    toss_winner VARCHAR(80),
    decision    VARCHAR(10),
    match_winner VARCHAR(80)
);

DROP TABLE IF EXISTS bowler_stats;
CREATE TABLE bowler_stats (
    bowler  VARCHAR(120) PRIMARY KEY,
    matches INT,
    overs   DECIMAL(6,1),
    runs    INT,
    wickets INT,
    economy DECIMAL(5,2)
);

DROP TABLE IF EXISTS batsman_consistency;
CREATE TABLE batsman_consistency (
    batsman     VARCHAR(120) PRIMARY KEY,
    innings     INT,
    runs        INT,
    average     DECIMAL(6,2),
    strike_rate DECIMAL(6,2),
    stddev      DECIMAL(6,2)
);

DROP TABLE IF EXISTS format_dominance;
CREATE TABLE format_dominance (
    player_name VARCHAR(120),
    format      VARCHAR(10),
    runs        INT,
    wickets     INT
);

DROP TABLE IF EXISTS player_ranking;
CREATE TABLE player_ranking (
    player_name    VARCHAR(120) PRIMARY KEY,
    batting_points INT,
    bowling_points INT,
    fielding_points INT,
    overall_points INT
);

DROP TABLE IF EXISTS head_to_head;
CREATE TABLE head_to_head (
    team_a VARCHAR(80),
    team_b VARCHAR(80),
    played INT,
    a_wins INT,
    b_wins INT
);

DROP TABLE IF EXISTS recent_form;
CREATE TABLE recent_form (
    player_name VARCHAR(120),
    innings     INT,
    runs        INT,
    match_date  DATE
);

DROP TABLE IF EXISTS partnership_pairs;
CREATE TABLE partnership_pairs (
    batter1   VARCHAR(120),
    batter2   VARCHAR(120),
    total_runs INT,
    avg_partnership DECIMAL(6,2),
    partnerships_count INT
);

DROP TABLE IF EXISTS quarterly_stats;
CREATE TABLE quarterly_stats (
    player_name VARCHAR(120),
    year        INT,
    quarter     INT,
    runs        INT,
    wickets     INT
);

-- ══════════════════════════════════════════════════════════════════════
--  Sample seed data - a handful of rows per table so the dashboard has
--  something to display even before the API-populated notebooks run.
-- ══════════════════════════════════════════════════════════════════════

INSERT INTO players (name, fullName, role, battingStyle, bowlingStyle, teamName) VALUES
 ('V Kohli',    'Virat Kohli',    'Batsman',       'Right-hand',  'Right-arm medium', 'India'),
 ('R Sharma',   'Rohit Sharma',   'Batsman',       'Right-hand',  'Right-arm off-break', 'India'),
 ('J Bumrah',   'Jasprit Bumrah', 'Bowler',        'Right-hand',  'Right-arm fast', 'India'),
 ('B Azam',     'Babar Azam',     'Batsman',       'Right-hand',  '-', 'Pakistan'),
 ('K Williamson','Kane Williamson','Batsman',      'Right-hand',  'Right-arm off-break', 'New Zealand');

INSERT INTO teams (team_name, country) VALUES
 ('India','India'),('Australia','Australia'),('England','England'),
 ('Pakistan','Pakistan'),('New Zealand','New Zealand'),('South Africa','South Africa');

INSERT INTO matches VALUES
 ('101','1st ODI','India','Australia','India','Wankhede Stadium','Mumbai','2025-12-08'),
 ('102','2nd ODI','India','Australia','Australia','Eden Gardens','Kolkata','2025-12-11'),
 ('103','3rd ODI','India','Australia','India','M. Chinnaswamy Stadium','Bengaluru','2025-12-14');

INSERT INTO team_wins VALUES
 ('India',58),('Australia',55),('England',46),('Pakistan',40),
 ('New Zealand',38),('South Africa',36);

INSERT INTO cricket_venues (venue_name, city, country, capacity) VALUES
 ('Narendra Modi Stadium','Ahmedabad','India',132000),
 ('Melbourne Cricket Ground','Melbourne','Australia',100024),
 ('Eden Gardens','Kolkata','India',68000),
 ('Lord''s','London','England',31100),
 ('The Oval','London','England',25500);

INSERT INTO odi_run_scorers (player_name, country, total_runs, batting_avg, centuries) VALUES
 ('Sachin Tendulkar','India',18426,44.83,49),
 ('Virat Kohli','India',13848,58.18,50),
 ('Ricky Ponting','Australia',13704,42.03,30),
 ('Kumar Sangakkara','Sri Lanka',14234,41.98,25),
 ('Mahela Jayawardene','Sri Lanka',12650,33.37,19);

INSERT INTO player_role_count (playing_role, player_count) VALUES
 ('Batsman',120),('Bowler',95),('All-rounder',60),('Wicket-keeper',32);

INSERT INTO cricket_series (series_name, host_country, match_type, start_date, total_matches) VALUES
 ('ICC Men''s T20 World Cup 2024','USA & W.Indies','T20I','2024-06-01',55),
 ('India tour of Sri Lanka 2024','Sri Lanka','Mixed','2024-07-27',6),
 ('Australia tour of India 2024-25 (BGT)','Australia','Test','2024-11-22',5);

-- End of schema.sql
