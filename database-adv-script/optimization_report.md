# SQL Query Performance Tuning

This document explains the process of analyzing and optimizing a SQL query, as demonstrated in the `performance.sql` script. The goal is to identify performance bottlenecks in an initial query and refactor it to improve its execution time and reduce resource consumption.

## Assumed Database Schema

The queries are based on a hypothetical schema for a property rental application:

-   **`Users`**: `user_id` (PK), `username`, `email`, `created_at`
-   **`Properties`**: `property_id` (PK), `title`, `location`, `price_per_night`
-   **`Bookings`**: `booking_id` (PK), `user_id` (FK), `property_id` (FK), `start_date`, `end_date`
-   **`Payments`**: `payment_id` (PK), `booking_id` (FK), `amount`, `payment_date`, `payment_status`

## Step 1: The Initial Query

The first step is to write the query that fulfills the business requirement. In this case, we need to retrieve complete details for all bookings.

```sql
-- Initial Query
SELECT *
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
JOIN Payments py ON b.booking_id = py.booking_id;
```

**Potential Issues:**
-   **`SELECT *`**: This is generally inefficient as it retrieves every column from all joined tables, increasing data transfer from the database to the application and consuming more memory.
-   **Full Table Joins**: Without proper indexes on the foreign key columns (`user_id`, `property_id`, `booking_id`), the database may have to perform a **Sequential Scan** (or Full Table Scan) on each table to find matching rows for the joins. This is extremely slow on large datasets.

## Step 2: Performance Analysis with `EXPLAIN`

Before optimizing, we must measure the current performance. Most SQL databases provide a command like `EXPLAIN` or `EXPLAIN ANALYZE` to show the query execution plan.

```sql
EXPLAIN ANALYZE SELECT * FROM Bookings ... -- (full initial query)
```

**Example `EXPLAIN` Output (Simplified & Inefficient):**
```
QUERY PLAN
--------------------------------------------------------------------------------------
Hash Join  (cost=60.00..120.00 rows=1000 width=256)
  Hash Cond: (py.booking_id = b.booking_id)
  ->  Seq Scan on payments py  (cost=0.00..50.00 rows=1000 width=32)
  ->  Hash Join  (cost=30.00..75.00 rows=1000 width=224)
        Hash Cond: (b.property_id = p.property_id)
        ->  Hash Join  (cost=15.00..45.00 rows=1000 width=160)
              Hash Cond: (b.user_id = u.user_id)
              ->  Seq Scan on bookings b  (cost=0.00..25.00 rows=1000 width=16)
              ->  Seq Scan on users u  (cost=0.00..15.00 rows=500 width=144)
        ->  Seq Scan on properties p  (cost=0.00..35.00 rows=800 width=64)
Execution Time: 150.5 ms
```
The key inefficiency here is the **`Seq Scan`** on all tables. This confirms the database is reading every single row because it cannot use a more efficient lookup method.

## Step 3: The Refactored Query

Based on the analysis, we can refactor the query.

```sql
-- Refactored Query
SELECT
    b.booking_id, b.start_date, b.end_date,
    u.username, u.email,
    p.title AS property_title, p.location,
    py.amount, py.payment_status, py.payment_date
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
JOIN Payments py ON b.booking_id = py.booking_id
WHERE u.username = 'john_doe';
```

**Improvements Made:**
1.  **Replaced `SELECT *`**: We now select only the specific columns needed by the application.
2.  **Relies on Indexing**: The query is written with the assumption that indexes exist on the `user_id`, `property_id`, and `booking_id` foreign key columns. These indexes are critical for making the `JOIN` operations fast. (See `database_index.sql` for index creation).
3.  **Added a Filter (`WHERE` clause)**: A realistic filter was added. When an index exists on `u.username`, the database can very quickly find the user 'john_doe' and then efficiently look up their related bookings, properties, and payments using the other indexes.

## Step 4: Performance After Refactoring

Running `EXPLAIN ANALYZE` on the refactored query would show a much more efficient plan.

**Example `EXPLAIN` Output (Simplified & Efficient):**
```
QUERY PLAN
--------------------------------------------------------------------------------------
Nested Loop Join  (cost=0.57..25.00 rows=5 width=128)
  ->  Nested Loop Join  (cost=0.43..18.00 rows=5 width=96)
        ->  Index Scan using idx_users_username on users u  (cost=0.15..8.17 rows=1 width=32)
              Index Cond: (username = 'john_doe')
        ->  Index Scan using idx_bookings_user_id on bookings b  (cost=0.28..9.50 rows=5 width=16)
              Index Cond: (user_id = u.user_id)
  ->  Index Scan using idx_properties_property_id on properties p (cost=0.14..1.20 rows=1 width=64)
        Index Cond: (property_id = b.property_id)
-- (Join to payments would also use an index)
Execution Time: 1.2 ms
```
The new plan uses an **`Index Scan`**, which is vastly superior to a `Seq Scan`. The database can directly look up the required rows instead of scanning the whole table. The estimated "cost" and the actual "Execution Time" are drastically reduced.