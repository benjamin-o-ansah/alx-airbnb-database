\# Database Normalization – AirBnB Database



\## Overview



This document explains how the \*\*AirBnB Database Schema\*\* (consisting of `User`, `Property`, `Booking`, `Payment`, `Review`, and `Message` entities) adheres to \*\*Third Normal Form (3NF)\*\*.  



Normalization ensures data is organized efficiently, eliminating redundancy and maintaining data integrity across all tables.



---



\## Step 1: Unnormalized Data (UNF)



Before normalization, data might be stored in a single large table or multiple loosely structured tables that include repeating groups and redundant data.



\### Example (UNF)

| user\_id | user\_name | property\_name | booking\_dates | payment\_amount |

|----------|------------|----------------|----------------|----------------|

| U001 | John Doe | Sea View Apartment | 2025-03-01 to 2025-03-05 | 450.00 |

| U001 | John Doe | Cozy Cottage | 2025-04-10 to 2025-04-15 | 600.00 |



\*\*Issues:\*\*

\- Repetition of user information (`John Doe`) across multiple rows.

\- `booking\_dates` field contains multiple values (violates atomicity).

\- Payment details depend indirectly on booking and user.



---



\## Step 2: First Normal Form (1NF)



\### Rule:

Each field must contain \*\*atomic (indivisible)\*\* values, and each record must be unique.



\### Actions Taken:

\- Each table now has a \*\*Primary Key (PK)\*\* (e.g., `user\_id`, `property\_id`, `booking\_id`).

\- Repeating or composite fields (like `booking\_dates`) were split into individual columns (`start\_date`, `end\_date`).

\- Each entity (User, Property, Booking, etc.) was separated into its own table.



&nbsp;\*\*Result:\*\*  

All tables have atomic values and unique primary keys.



---



\## Step 3: Second Normal Form (2NF)



\### Rule:

\- The database must be in \*\*1NF\*\*.

\- Every \*\*non-key attribute\*\* must depend on the \*\*whole primary key\*\*, not just part of it.



\### Actions Taken:

\- Verified that all non-key attributes in each table depend \*\*entirely\*\* on their primary key.

\- No composite keys exist in the schema, so partial dependency is not an issue.



\*\*Example:\*\*

\- In the \*\*Booking\*\* table, all attributes (`property\_id`, `user\_id`, `start\_date`, `end\_date`, `total\_price`, `status`) depend on the `booking\_id`.

\- No attribute depends only on `property\_id` or `user\_id`.



&nbsp;\*\*Result:\*\*  

No partial dependencies exist; every non-key attribute depends on its full primary key.



---



\## Step 4: Third Normal Form (3NF)



\### Rule:

\- The database must be in \*\*2NF\*\*.

\- There should be \*\*no transitive dependencies\*\* (i.e., non-key attributes must not depend on other non-key attributes).



\### Actions Taken:



\#### 1. \*\*User Table\*\*

\- Each attribute (`first\_name`, `last\_name`, `email`, `password\_hash`, `role`, etc.) depends directly on `user\_id`.

\- No transitive dependency (e.g., `role` does not depend on `email`).



&nbsp;\*\*In 3NF\*\*



---



\#### 2. \*\*Property Table\*\*

\- `host\_id` references `User(user\_id)`, establishing a relationship instead of duplicating host data.

\- Attributes like `name`, `description`, `pricepernight`, and `location` all depend only on `property\_id`.



&nbsp;\*\*In 3NF\*\*



---



\#### 3. \*\*Booking Table\*\*

\- `property\_id` and `user\_id` are foreign keys.

\- Non-key attributes (`start\_date`, `end\_date`, `total\_price`, `status`) depend solely on `booking\_id`.

\- `total\_price` is derived but stored for performance reasons — acceptable as long as it is computed accurately at booking time.



&nbsp;\*\*In 3NF\*\* (with justified denormalization for efficiency)



---



\#### 4. \*\*Payment Table\*\*

\- `payment\_id` is the primary key.

\- `booking\_id`, `amount`, `payment\_date`, and `payment\_method` all depend directly on `payment\_id`.

\- No transitive dependency — payment details relate only to the specific booking.



&nbsp;\*\*In 3NF\*\*



---



\#### 5. \*\*Review Table\*\*

\- `review\_id` is the primary key.

\- `property\_id` and `user\_id` are foreign keys.

\- Attributes `rating` and `comment` depend solely on `review\_id`.



\*\*In 3NF\*\*



---



\#### 6. \*\*Message Table\*\*

\- `message\_id` is the primary key.

\- `sender\_id` and `recipient\_id` are foreign keys referencing users.

\- `message\_body` and `sent\_at` depend only on `message\_id`.



&nbsp;\*\*In 3NF\*\*



---



\## Additional Normalization Insights



| Entity | Normalization Action | Justification |

|---------|----------------------|----------------|

| \*\*User\*\* | Split roles into ENUM values instead of a lookup table | Reduces unnecessary joins while maintaining referential integrity |

| \*\*Booking\*\* | Avoids storing redundant `user\_email` or `property\_name` | Ensures no duplication of user or property data |

| \*\*Payment\*\* | Linked directly to `Booking` to prevent storing user or property info | Prevents transitive dependencies |

| \*\*Review\*\* | References both `Property` and `User` via foreign keys | Avoids repeating property or user information |

| \*\*Message\*\* | Sender and recipient both reference the `User` table | Maintains consistency and eliminates data redundancy |



---



\## Final Schema Normalization Summary



| Normal Form | Description | Status |

|--------------|-------------|---------|

| \*\*1NF\*\* | Atomic values, unique records |  Achieved |

| \*\*2NF\*\* | Full functional dependency on PK |  Achieved |

| \*\*3NF\*\* | No transitive dependency |  Achieved |

