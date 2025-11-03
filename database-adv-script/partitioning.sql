-- =========================================
-- FILE: partitioning.sql
-- PROJECT: Airbnb Booking System (Performance Optimization)
-- DESCRIPTION:
--   1. Implement partitioning on the 'bookings' table by start_date
--   2. Analyze query performance before and after partitioning
-- =========================================

-- =====================================================
-- 1️⃣ DROP AND RECREATE ORIGINAL BOOKINGS TABLE (if exists)
-- =====================================================
DROP TABLE IF EXISTS bookings CASCADE;

-- Simulate a large table with booking records
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    status VARCHAR(50)
);

-- Insert mock data (for testing)
-- Assume thousands of records spread across multiple years
INSERT INTO bookings (user_id, property_id, booking_date, start_date, end_date, total_amount, status)
SELECT
    (RANDOM() * 1000)::INT,
    (RANDOM() * 500)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT + 3,
    ROUND(RANDOM() * 500 + 100, 2),
    CASE WHEN RANDOM() < 0.5 THEN 'Confirmed' ELSE 'Pending' END
FROM generate_series(1, 100000);  -- 100K rows for testing

-- =====================================================
-- 2️⃣ BASELINE PERFORMANCE TEST (BEFORE PARTITIONING)
-- =====================================================
-- Measure how long it takes to fetch bookings for a specific date range
EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31';


-- =====================================================
-- 3️⃣ CREATE PARTITIONED TABLE STRUCTURE
-- =====================================================
-- Drop old table and recreate it with RANGE partitioning
DROP TABLE IF EXISTS bookings CASCADE;

CREATE TABLE bookings (
    booking_id SERIAL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    status VARCHAR(50),
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Create partitions for specific year ranges
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Optional: Default partition for future dates
CREATE TABLE bookings_future PARTITION OF bookings
    DEFAULT;

-- =====================================================
-- 4️⃣ INSERT DATA INTO PARTITIONED TABLE
-- =====================================================
-- Populate partitions with same simulated data
INSERT INTO bookings (user_id, property_id, booking_date, start_date, end_date, total_amount, status)
SELECT
    (RANDOM() * 1000)::INT,
    (RANDOM() * 500)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT,
    DATE '2023-01-01' + (RANDOM() * 700)::INT + 3,
    ROUND(RANDOM() * 500 + 100, 2),
    CASE WHEN RANDOM() < 0.5 THEN 'Confirmed' ELSE 'Pending' END
FROM generate_series(1, 100000);

-- =====================================================
-- 5️⃣ PERFORMANCE TEST (AFTER PARTITIONING)
-- =====================================================
-- This query should now only scan relevant partitions, not the entire dataset
EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31';


-- =====================================================
-- 6️⃣ EXPECTED RESULTS
-- =====================================================
-- ✅ BEFORE partitioning:
--    - Full table scan on all rows (~100,000)
--    - High execution time (e.g., 150–250ms)
--
-- ✅ AFTER partitioning:
--    - Partition pruning: only 'bookings_2024' is scanned
--    - Execution time reduced to ~40–60ms
--
-- ✅ Improvement: ~70% reduction in query runtime
--
-- Note: Actual results depend on your database size and system specs.

-- =====================================================
-- END OF SCRIPT
-- =====================================================
