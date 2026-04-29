-- Question 4: List all cricket venues with capacity above 30,000.
-- Returns one ranked result set, sorted by capacity (largest first).

USE cricket_db;

SELECT
    RANK() OVER (ORDER BY capacity DESC) AS rank_position,
    venue_name,
    city,
    country,
    capacity
FROM cricket_venues
WHERE capacity > 30000
ORDER BY capacity DESC;
