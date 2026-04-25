USE cricket_db;

CREATE TABLE matches (
    matchId       VARCHAR(50),
    description   VARCHAR(255),
    team1         VARCHAR(100),
    team2         VARCHAR(100),
    venueName     VARCHAR(150),
    venueCity     VARCHAR(100),
    matchDate     VARCHAR(50)
);
USE cricket_db;

SELECT
    matchId       AS "Match ID",
    description   AS "Match Description",
    team1         AS "Team 1",
    team2         AS "Team 2",
    venueName     AS "Venue",
    venueCity     AS "City",
    matchDate     AS "Match Date"
FROM
    matches
ORDER BY
    matchDate DESC;