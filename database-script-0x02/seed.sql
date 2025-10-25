-- ==========================================================
-- 🏠 AIRBNB DATABASE SAMPLE DATA INSERTION SCRIPT
-- Compatible with MySQL schema using CHAR(36) UUID storage
-- Database: alx_airbnb_database
-- ==========================================================

USE alx_airbnb_database;

-- ----------------------------------------------------------
-- 👤 USER TABLE
-- ----------------------------------------------------------
INSERT INTO `User` (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(UUID(), 'Benjamin', 'Ansah', 'benjamin@alx.com', 'hashed_pwd_1', '+233201234567', 'host'),
(UUID(), 'Ama', 'Boateng', 'ama.boateng@example.com', 'hashed_pwd_2', '+233502223344', 'guest'),
(UUID(), 'Kofi', 'Mensah', 'kofi.mensah@example.com', 'hashed_pwd_3', '+233509998877', 'host'),
(UUID(), 'Esi', 'Adjei', 'esi.adjei@example.com', 'hashed_pwd_4', '+233240112233', 'guest'),
(UUID(), 'Kwame', 'Owusu', 'kwame.owusu@example.com', 'hashed_pwd_5', '+233208888777', 'admin');

-- ----------------------------------------------------------
-- 🏡 PROPERTY TABLE
-- ----------------------------------------------------------
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'benjamin@alx.com'),
 'Accra Luxury Apartment',
 'Modern 2-bedroom apartment in East Legon with swimming pool, air conditioning, and Wi-Fi.',
 'East Legon, Accra',
 120.00),

(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'kofi.mensah@example.com'),
 'Kumasi Garden Villa',
 'Spacious villa surrounded by gardens — ideal for family vacations.',
 'Ahodwo, Kumasi',
 95.00),

(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'benjamin@alx.com'),
 'Cape Coast Beach Cottage',
 'Cozy beachfront cottage perfect for weekend getaways.',
 'Cape Coast, Central Region',
 80.00);

-- ----------------------------------------------------------
-- 📅 BOOKING TABLE
-- ----------------------------------------------------------
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
(UUID(),
 (SELECT property_id FROM Property WHERE name = 'Accra Luxury Apartment'),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 '2025-11-01', '2025-11-05', 480.00, 'confirmed'),

(UUID(),
 (SELECT property_id FROM Property WHERE name = 'Kumasi Garden Villa'),
 (SELECT user_id FROM `User` WHERE email = 'esi.adjei@example.com'),
 '2025-12-10', '2025-12-15', 475.00, 'pending'),

(UUID(),
 (SELECT property_id FROM Property WHERE name = 'Cape Coast Beach Cottage'),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 '2025-12-20', '2025-12-22', 160.00, 'confirmed');

-- ----------------------------------------------------------
-- 💳 PAYMENT TABLE
-- ----------------------------------------------------------
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
(UUID(),
 (SELECT booking_id FROM Booking WHERE total_price = 480.00),
 480.00, 'credit_card'),

(UUID(),
 (SELECT booking_id FROM Booking WHERE total_price = 160.00),
 160.00, 'paypal');

-- ----------------------------------------------------------
-- ⭐ REVIEW TABLE
-- ----------------------------------------------------------
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
(UUID(),
 (SELECT property_id FROM Property WHERE name = 'Accra Luxury Apartment'),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 5,
 'Fantastic stay — the apartment was spotless and exactly as described.'),

(UUID(),
 (SELECT property_id FROM Property WHERE name = 'Cape Coast Beach Cottage'),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 4,
 'Beautiful beachfront cottage, peaceful and cozy. Only downside was patchy Wi-Fi.');

-- ----------------------------------------------------------
-- 💬 MESSAGE TABLE
-- ----------------------------------------------------------
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 (SELECT user_id FROM `User` WHERE email = 'benjamin@alx.com'),
 'Hello Benjamin, I would like to confirm if the Accra Luxury Apartment has parking space.'),

(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'benjamin@alx.com'),
 (SELECT user_id FROM `User` WHERE email = 'ama.boateng@example.com'),
 'Hi Ama, yes! There is free and secure parking available for all guests.'),

(UUID(),
 (SELECT user_id FROM `User` WHERE email = 'esi.adjei@example.com'),
 (SELECT user_id FROM `User` WHERE email = 'kofi.mensah@example.com'),
 'Hi Kofi, is the Kumasi Garden Villa available for a family trip this December?');

-- ----------------------------------------------------------
-- ✅ CHECK RESULTS
-- ----------------------------------------------------------
SELECT '✅ USERS' AS section;      SELECT * FROM `User`;
SELECT '✅ PROPERTIES' AS section; SELECT * FROM Property;
SELECT '✅ BOOKINGS' AS section;   SELECT * FROM Booking;
SELECT '✅ PAYMENTS' AS section;   SELECT * FROM Payment;
SELECT '✅ REVIEWS' AS section;    SELECT * FROM Review;
SELECT '✅ MESSAGES' AS section;   SELECT * FROM Message;
