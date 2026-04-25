USE cricket_db;

DROP TABLE IF EXISTS players;

CREATE TABLE players (
    id           INT,
    name         VARCHAR(100),
    fullName     VARCHAR(150),
    role         VARCHAR(100),
    battingStyle VARCHAR(100),
    bowlingStyle VARCHAR(100),
    teamName     VARCHAR(100)
);
SELECT * FROM players;