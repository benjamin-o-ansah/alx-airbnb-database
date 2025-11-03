\# SQL JOIN Queries



This script (`joins\_queries.sql`) provides examples of different types of SQL JOIN clauses to retrieve data from a relational database, such as one that might power a property rental application like Airbnb.



\## Assumed Database Schema



The queries are based on a hypothetical schema consisting of the following tables:



\-   \*\*`users`\*\*: Stores user information.

&nbsp;   -   `user\_id` (Primary Key)

&nbsp;   -   `username`

&nbsp;   -   `email`

\-   \*\*`properties`\*\*: Stores property listing details.

&nbsp;   -   `property\_id` (Primary Key)

&nbsp;   -   `title`

&nbsp;   -   `location`

\-   \*\*`bookings`\*\*: Stores booking records, linking users to properties.

&nbsp;   -   `booking\_id` (Primary Key)

&nbsp;   -   `user\_id` (Foreign Key to `users`)

&nbsp;   -   `property\_id` (Foreign Key to `properties`)

\-   \*\*`reviews`\*\*: Stores reviews for properties.

&nbsp;   -   `review\_id` (Primary Key)

&nbsp;   -   `property\_id` (Foreign Key to `properties`)

&nbsp;   -   `user\_id` (Foreign Key to `users`)

&nbsp;   -   `rating`

&nbsp;   -   `comment`



\## Queries Included



\### 1. INNER JOIN



\-   \*\*Purpose\*\*: To retrieve all bookings along with the details of the user who made each booking.

\-   \*\*Result\*\*: This query will only return rows where a booking has a corresponding user. Bookings without a user or users without a booking will be excluded.



\### 2. LEFT JOIN



\-   \*\*Purpose\*\*: To retrieve all properties and any reviews they may have.

\-   \*\*Result\*\*: This query lists every property from the `properties` table. If a property has reviews, the review details will be included. If a property has no reviews, the review-related columns will be `NULL`.



\### 3. FULL OUTER JOIN



\-   \*\*Purpose\*\*: To retrieve all users and all bookings, showing the relationship between them.

\-   \*\*Result\*\*: This query combines all records from both the `users` and `bookings` tables. It will show:

&nbsp;   -   Users who have made bookings.

&nbsp;   -   Users who have not made any bookings.

&nbsp;   -   Bookings that are not associated with any user (e.g., orphaned records).



\*\*Note on Compatibility\*\*: The `FULL OUTER JOIN` is standard in SQL databases like PostgreSQL and SQL Server but is not available in MySQL.

