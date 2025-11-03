# Database Indexing Strategy

This document explains the SQL script `database_index.sql`, which contains commands for creating database indexes. Indexes are crucial for optimizing the performance of database queries by allowing the database engine to find rows more quickly.

## What is an Index?

An index is a data structure (most commonly a B-Tree) that improves the speed of data retrieval operations on a database table at the cost of additional writes and storage space. It works like an index in the back of a book; instead of scanning every page (every row) to find a topic, you can look up the topic in the index and go directly to the page number.

## Identifying Columns to Index

The choice of which columns to index is critical for performance. We've identified "high-usage" columns based on common query patterns:

-   **`WHERE` clauses**: Columns frequently used to filter data are prime candidates for indexing.
-   **`JOIN` conditions**: Columns used to join tables (typically foreign keys) should almost always be indexed to speed up the join operation.
-   **`ORDER BY` clauses**: Indexing columns used for sorting can prevent costly full-table sort operations.

## Index Creation Commands

The following indexes are created in the `database_index.sql` script:

### On the `Users` Table
-   `CREATE INDEX idx_users_username ON Users(username);`
    -   **Purpose**: Speeds up searches for users by their username, a common action during login or user lookups.

### On the `Properties` Table
-   `CREATE INDEX idx_properties_location ON Properties(location);`
    -   **Purpose**: Dramatically improves performance when users search for properties in a specific location (e.g., `WHERE location = '...'`).
-   `CREATE INDEX idx_properties_price ON Properties(price);`
    -   **Purpose**: Optimizes sorting properties by price (`ORDER BY price`), a common feature on listing pages.

### On the `Bookings` Table
-   `CREATE INDEX idx_bookings_user_id ON Bookings(user_id);`
    -   **Purpose**: Essential for quickly fetching all bookings for a specific user. This is a very common foreign key lookup.
-   `CREATE INDEX idx_bookings_property_id ON Bookings(property_id);`
    -   **Purpose**: Speeds up retrieving all bookings associated with a particular property, for example, to check its calendar availability.
-   `CREATE INDEX idx_bookings_user_id_booking_date ON Bookings(user_id, booking_date DESC);`
    -   **Purpose**: A **composite index** that optimizes queries filtering by a user and sorting by date simultaneously, such as displaying a user's booking history.

## Measuring Performance Before and After

To see the impact of these indexes, you can use your database's query plan analyzer, such as `EXPLAIN` (in PostgreSQL and MySQL) or `EXPLAIN PLAN FOR` (in Oracle).

### Step 1: Run the Query *Before* the Index

Run `EXPLAIN` on a query that would benefit from an index. For example:

```sql
EXPLAIN ANALYZE SELECT * FROM Bookings WHERE user_id = 123;
```

You will likely see a **Sequential Scan** in the query plan. This means the database had to read through every row in the `Bookings` table to find the ones matching `user_id = 123`. This is very slow on large tables.

**Example Output (Simplified):**
```
QUERY PLAN
---------------------------------------------------------------------
Seq Scan on bookings  (cost=0.00..155.00 rows=5 width=24)
  Filter: (user_id = 123)
```

### Step 2: Create the Index

Now, run the `CREATE INDEX` command:

```sql
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
```

### Step 3: Run the Query *After* the Index

Run the exact same `EXPLAIN` command again:

```sql
EXPLAIN ANALYZE SELECT * FROM Bookings WHERE user_id = 123;
```

The query plan should now show an **Index Scan**. This indicates the database used the index to go directly to the relevant rows, which is significantly faster.

**Example Output (Simplified):**
```
QUERY PLAN
---------------------------------------------------------------------
Index Scan using idx_bookings_user_id on bookings (cost=0.29..8.31 rows=5 width=24)
  Index Cond: (user_id = 123)
```

By comparing the "cost" and execution time before and after, you can tangibly measure the performance improvement.
