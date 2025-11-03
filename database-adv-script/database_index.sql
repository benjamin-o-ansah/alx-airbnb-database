-- ========================================
-- DATABASE INDEX SCRIPT
-- Project: Airbnb Booking System (Example)
-- Description: Creates indexes on high-usage columns to optimize JOIN, WHERE, and ORDER BY performance.
-- Also demonstrates performance analysis using EXPLAIN ANALYZE.
-- ========================================

-- ========================================
-- 1. IDENTIFY HIGH-USAGE COLUMNS
-- ========================================
-- USERS table: user_id, email
-- BOOKINGS table: booking_id, user_id, property_id, booking_date
-- PROPERTIES table: property_id, location, property_name

-- ========================================
-- 2. CREATE INDEXES
-- ========================================

-- USERS Table
CREATE INDEX idx_users_user_id ON users(user_id);
CREATE INDEX idx_users_email ON users(email);

-- BOOKINGS Table
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);

-- PROPERTIES Table
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_property_name ON properties(property_name);

-- ========================================
-- 3. PERFORMANCE ANALYSIS USING EXPLAIN ANALYZE
-- ========================================
-- Run these queries BEFORE and AFTER creating indexes to compare performance.
-- EXPLAIN ANALYZE shows actual execution time and query plan.

-- Example 1: Analyze Join and Filter Query Performance
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.property_id,
    b.booking_date,
    u.first_name,
    u.last_name
FROM bookings b
INNER JOIN users u 
    ON b.user_id = u.user_id
WHERE b.booking_date > '2025-01-01'
ORDER BY b.booking_date DESC;

-- Example 2: Analyze Property Review Query Performance
EXPLAIN ANALYZE
SELECT 
    p.property_name,
    COUNT(r.review_id) AS total_reviews
FROM properties p
LEFT JOIN reviews r
    ON p.property_id = r.property_id
GROUP BY p.property_name
ORDER BY total_reviews DESC;

-- Example 3: Analyze Aggregation and Filtering Query
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b
    ON u.user_id = b.user_id
GROUP BY u.user_id, full_name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_bookings DESC;

-- ========================================
-- 4. OPTIONAL: DROP INDEXES FOR RE-TESTING
-- ========================================
-- DROP INDEX idx_users_email ON users;
-- DROP INDEX idx_bookings_user_id ON bookings;
-- DROP INDEX idx_properties_location ON properties;

-- ========================================
-- END OF SCRIPT
