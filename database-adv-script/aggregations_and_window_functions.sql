-- AGGREGATION QUERY: Total number of bookings made by each user
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b
ON u.user_id = b.user_id
GROUP BY u.user_id, full_name
ORDER BY total_bookings DESC;

-- ========================================

-- 7. WINDOW FUNCTION QUERY: Rank properties based on total number of bookings
SELECT 
    p.property_id,
    p.property_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_row_number
FROM properties p
LEFT JOIN bookings b
ON p.property_id = b.property_id
GROUP BY p.property_id, p.property_name
ORDER BY total_bookings DESC;