-- =========================================
-- FILE: performance.sql
-- PROJECT: Airbnb Booking System (Performance Optimization)
-- DESCRIPTION:
--   1. Retrieve bookings with user, property, and payment details
--   2. Analyze performance using EXPLAIN
--   3. Refactor the query for optimization
-- =========================================


-- =====================================================
-- 1️⃣ INITIAL QUERY (UNOPTIMIZED)
-- =====================================================
-- This query retrieves all bookings with user, property, and payment details.
-- It includes multiple joins which might cause performance bottlenecks if the
-- tables are large and not indexed properly.

SELECT
    b.booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.property_name,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM bookings b
INNER JOIN users u
    ON b.user_id = u.user_id
INNER JOIN properties p
    ON b.property_id = p.property_id
LEFT JOIN payments pay
    ON b.booking_id = pay.booking_id
ORDER BY b.booking_date DESC;

-- =====================================================
-- 2️⃣ PERFORMANCE ANALYSIS USING EXPLAIN
-- =====================================================
-- Run EXPLAIN to view the query execution plan and check for inefficiencies.
-- Look for full table scans, nested loops, and missing index warnings.

EXPLAIN
SELECT
    b.booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.property_name,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM bookings b
INNER JOIN users u
    ON b.user_id = u.user_id
INNER JOIN properties p
    ON b.property_id = p.property_id
LEFT JOIN payments pay
    ON b.booking_id = pay.booking_id
ORDER BY b.booking_date DESC;

-- ❗ Possible inefficiencies detected:
-- - Full table scans on 'bookings' or 'users' if no indexes exist
-- - Sorting (ORDER BY) may trigger temporary disk usage
-- - Multiple JOINs increase computational cost


-- =====================================================
-- 3️⃣ REFACTORED QUERY (OPTIMIZED)
-- =====================================================
-- Optimization techniques applied:
-- ✅ Added indexes to JOIN and ORDER BY columns
-- ✅ Limited selected columns to only required fields
-- ✅ Removed unnecessary sorting
-- ✅ Used INNER JOIN only where necessary

-- Create relevant indexes (run once)
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_properties_property_id ON properties(property_id);
CREATE INDEX IF NOT EXISTS idx_users_user_id ON users(user_id);

-- Refactored optimized query
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.booking_date,
    u.first_name || ' ' || u.last_name AS customer_name,
    p.property_name,
    pay.amount AS total_paid
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;

-- ✅ Expected Performance Improvements:
-- - Reduced I/O cost from full table scans
-- - Faster joins due to indexed foreign keys
-- - Lower sorting cost due to removal of ORDER BY
-- - Overall query runtime reduction by 40–70% (depending on dataset size)

-- =====================================================
-- END OF SCRIPT
-- =====================================================
