-- ========================================
-- JOIN QUERIES SCRIPT
-- Project: Airbnb Booking System (Example)
-- Description: Demonstrates INNER JOIN, LEFT JOIN, and FULL OUTER JOIN queries.
-- ========================================

-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT 
    bookings.booking_id,
    bookings.property_id,
    bookings.booking_date,
    bookings.total_amount,
    users.user_id,
    users.first_name,
    users.last_name,
    users.email
FROM bookings
INNER JOIN users
ON bookings.user_id = users.user_id
ORDER BY bookings.booking_date DESC;

-- ========================================

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    properties.property_id,
    properties.property_name,
    properties.location,
    reviews.review_id,
    reviews.rating,
    reviews.comment
FROM properties
LEFT JOIN reviews
ON properties.property_id = reviews.property_id
ORDER BY properties.property_name ASC;

-- ========================================

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking
--    or a booking is not linked to a user
-- NOTE: MySQL does not support FULL OUTER JOIN directly; you can simulate it using UNION.
SELECT 
    users.user_id,
    users.first_name,
    users.last_name,
    bookings.booking_id,
    bookings.booking_date
FROM users
LEFT JOIN bookings
ON users.user_id = bookings.user_id

UNION

SELECT 
    users.user_id,
    users.first_name,
    users.last_name,
    bookings.booking_id,
    bookings.booking_date
FROM users
RIGHT JOIN bookings
ON users.user_id = bookings.user_id
ORDER BY booking_date DESC, user_id ASC;

-- ========================================
-- END OF SCRIPT
