USE cricket_db;
CREATE TABLE cricket_venues (
    venue_id    INT AUTO_INCREMENT PRIMARY KEY,
    venue_name  VARCHAR(150) NOT NULL,
    city        VARCHAR(100),
    country     VARCHAR(100),
    capacity    INT
);
SELECT * FROM cricket_venues;
SELECT
    RANK() OVER (ORDER BY capacity DESC) AS rank_position,
    venue_name,
    city,
    country,
    capacity
FROM cricket_venues
WHERE capacity > 30000
ORDER BY capacity DESC;
