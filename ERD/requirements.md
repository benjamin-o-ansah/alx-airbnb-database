

# AirBnB Database Design

## Overview
This database schema models a simplified version of the **AirBnB system**, capturing key entities such as **Users**, **Properties**, **Bookings**, **Payments**, **Reviews**, and **Messages**.  
It defines how users (guests, hosts, and admins) interact with properties and each other through bookings, reviews, and messages.

---

## Entities and Attributes

### 1. **User**
Stores user information including their role within the platform.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `user_id` | UUID | **PK**, Indexed | Unique identifier for each user |
| `first_name` | VARCHAR | NOT NULL | User's first name |
| `last_name` | VARCHAR | NOT NULL | User's last name |
| `email` | VARCHAR | UNIQUE, NOT NULL | User's email address |
| `password_hash` | VARCHAR | NOT NULL | Encrypted password |
| `phone_number` | VARCHAR | NULL | Optional contact number |
| `role` | ENUM(`guest`, `host`, `admin`) | NOT NULL | User type/role |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |

---

### 2. **Property**
Represents accommodation listings created by hosts.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `property_id` | UUID | **PK**, Indexed | Unique identifier for each property |
| `host_id` | UUID | **FK → User(user_id)** | Owner/Host of the property |
| `name` | VARCHAR | NOT NULL | Name of the property |
| `description` | TEXT | NOT NULL | Detailed description |
| `location` | VARCHAR | NOT NULL | Address or location of the property |
| `pricepernight` | DECIMAL | NOT NULL | Cost per night |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Timestamp of last update |

---

### 3. **Booking**
Tracks reservations made by users for specific properties.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `booking_id` | UUID | **PK**, Indexed | Unique identifier for each booking |
| `property_id` | UUID | **FK → Property(property_id)** | Booked property |
| `user_id` | UUID | **FK → User(user_id)** | User who made the booking |
| `start_date` | DATE | NOT NULL | Check-in date |
| `end_date` | DATE | NOT NULL | Check-out date |
| `total_price` | DECIMAL | NOT NULL | Total cost for stay |
| `status` | ENUM(`pending`, `confirmed`, `canceled`) | NOT NULL | Booking state |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Booking creation timestamp |

---

### 4. **Payment**
Records payment transactions associated with bookings.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `payment_id` | UUID | **PK**, Indexed | Unique payment identifier |
| `booking_id` | UUID | **FK → Booking(booking_id)** | Related booking |
| `amount` | DECIMAL | NOT NULL | Payment amount |
| `payment_date` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Date and time of payment |
| `payment_method` | ENUM(`credit_card`, `paypal`, `stripe`) | NOT NULL | Payment option used |

---

### 5. **Review**
Captures user feedback on properties after a stay.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `review_id` | UUID | **PK**, Indexed | Unique identifier for each review |
| `property_id` | UUID | **FK → Property(property_id)** | Property being reviewed |
| `user_id` | UUID | **FK → User(user_id)** | Reviewer (guest) |
| `rating` | INTEGER | CHECK (1 ≤ rating ≤ 5), NOT NULL | Rating score (1–5) |
| `comment` | TEXT | NOT NULL | User’s written feedback |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Review creation timestamp |

---

### 6. **Message**
Handles communication between users on the platform.

| Attribute | Type | Constraints | Description |
|------------|------|-------------|--------------|
| `message_id` | UUID | **PK**, Indexed | Unique message identifier |
| `sender_id` | UUID | **FK → User(user_id)** | Message sender |
| `recipient_id` | UUID | **FK → User(user_id)** | Message recipient |
| `message_body` | TEXT | NOT NULL | Content of the message |
| `sent_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Timestamp of message sending |

---

## Entity Relationships

| Relationship | Description |
|---------------|--------------|
| **User → Property** | A **User (host)** can list multiple **Properties** (1:N) |
| **User → Booking** | A **User (guest)** can make multiple **Bookings** (1:N) |
| **Property → Booking** | A **Property** can have multiple **Bookings** (1:N) |
| **Booking → Payment** | Each **Booking** has one corresponding **Payment** (1:1) |
| **Property → Review** | A **Property** can have multiple **Reviews** (1:N) |
| **User → Review** | A **User (guest)** can leave multiple **Reviews** (1:N) |
| **User → Message (sender/recipient)** | Users can send and receive multiple **Messages** (N:M through sender and recipient relationships) |


##  ER Diagram

You can view the full **Entity-Relationship Diagram (ERD)** here:  
![AirBnB ERD](https://github.com/benjamin-o-ansah/alx-airbnb-database/blob/main/ERD_airbnb.png)

