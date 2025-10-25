\# AirBnB Database — Sample Data Insertion Script



\## Overview

This SQL script populates the \*\*AirBnB database\*\* (`alx\_airbnb\_database`) with \*\*realistic sample data\*\*.  

It provides example records for \*\*users, properties, bookings, payments, reviews, and messages\*\*, helping to demonstrate and test how different entities interact in the database.



The script assumes that all database tables have already been created using the provided schema creation file (`schema.sql`).



---



\## Script Details



\### Database Used

\*\*Database name:\*\* `alx\_airbnb\_database`



Before running this script, ensure the following:

```sql

USE alx\_airbnb\_database;



Populated Tables and Relationships

\## 1. User Table



\*\*\* Stores information about all users in the system, including hosts, guests, and admins.

| Column          | Description                           |

| --------------- | ------------------------------------- |

| `user\_id`       | Primary key (UUID stored as CHAR(36)) |

| `first\_name`    | User's first name                     |

| `last\_name`     | User's last name                      |

| `email`         | Unique email address                  |

| `password\_hash` | Hashed password                       |

| `phone\_number`  | Optional contact number               |

| `role`          | ENUM: `guest`, `host`, `admin`        |

| `created\_at`    | Timestamp of registration             |



\*\*\* Sample Data Includes:



\*\*\* Benjamin Ansah (Host)



\*\*\* Ama Boateng (Guest)



\*\*\* Kofi Mensah (Host)



\*\*\* Esi Adjei (Guest)



\*\*\* Kwame Owusu (Admin)



\### 2. Property Table



\*\*\* Holds details of properties listed by hosts for rental.



| Column                     | Description                   |

| -------------------------- | ----------------------------- |

| `property\_id`              | Primary key (UUID)            |

| `host\_id`                  | Foreign key → `User(user\_id)` |

| `name`                     | Property title                |

| `description`              | Description of the property   |

| `location`                 | Geographical location         |

| `pricepernight`            | Rental price per night        |

| `created\_at`, `updated\_at` | Audit timestamps              |



\### Sample Properties:



\*\*\* Accra Luxury Apartment — owned by Benjamin (Host)



\*\*\* Kumasi Garden Villa — owned by Kofi (Host)



\*\*\* Cape Coast Beach Cottage — owned by Benjamin (Host)





