USE cricket_db;

CREATE TABLE batting_partnerships (
    rec_id     INT AUTO_INCREMENT PRIMARY KEY,
    match_id   INT,
    innings    INT,
    wicket_no  INT,
    batter1    VARCHAR(80),
    batter2    VARCHAR(80),
    runs       INT,
    balls      INT
);

-- Partnerships where the two batsmen scored >= 100 combined runs
SELECT
    match_id                            AS "Match ID",
    innings                             AS "Innings",
    CONCAT(batter1,' & ',batter2)       AS "Partnership",
    runs                                AS "Runs",
    balls                               AS "Balls",
    ROUND(runs*100.0/balls, 2)          AS "Run Rate"
FROM batting_partnerships
WHERE runs >= 100
ORDER BY runs DESC;
