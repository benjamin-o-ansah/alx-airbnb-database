-- ========================================
-- DATABASE INDEX SCRIPT
-- Project: Airbnb Booking System (Example)
-- Description: Creates indexes on high-usage columns to optimize JOIN, WHERE, and ORDER BY performance.
-- ========================================

-- Identify High-Usage Columns:
-- USERS table: user_id, email
-- BOOKINGS table: booking_id, user_id, property_id, booking_date
-- PROPERTIES table: property_id, location, property_name

-- ========================================
-- 1. CREATE INDEXES
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
-- 2. TEST QUERY PERFORMANCE BEFORE AND AFTER INDEXES
-- ========================================
-- Use EXPLAIN (MySQL/PostgreSQL) or ANALYZE (PostgreSQL) to measure execution plan and cost.

-- Example A: Query Before Indexing
-- (Run this before executing CREATE INDEX commands)
EXPLAIN SELECT 
    bookings.booking_id,
    bookings.property_id,
    bookings.booking_date,
    users.first_name,
    users.last_name
FROM bookings
INNER JOIN users ON bookings.user_id = users.user_id
WHERE bookings.booking_date > '2025-01-01'
ORDER BY bookings.booking_date DESC;

-- Example B: Query After Indexing
-- (Run this after executing CREATE INDEX commands)
EXPLAIN SELECT 
    bookings.booking_id,
    bookings.property_id,
    bookings.booking_date,
    users.first_name,
    users.last_name
FROM bookings
INNER JOIN users ON bookings.user_id = users.user_id
WHERE bookings.booking_date > '2025-01-01'
ORDER BY bookings.booking_date DESC;

-- ========================================
-- 3. OPTIONAL: DROP INDEXES (if re-testing)
-- ========================================
-- DROP INDEX idx_users_email ON users;
-- DROP INDEX idx_bookings_user_id ON bookings;
-- DROP INDEX idx_properties_location ON properties;

-- ========================================
-- END OF SCRIPT
