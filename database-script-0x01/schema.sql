-- ==========================================================
-- MySQL-compatible AirBnB Schema (UUIDs stored as CHAR(36))
-- ==========================================================

DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS `User`;

-- ===========================
-- 1) User
-- ===========================
CREATE TABLE `User` (
    user_id CHAR(36) NOT NULL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest','host','admin') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE INDEX idx_user_email ON `User`(email);

-- ===========================
-- 2) Property
-- ===========================
CREATE TABLE Property (
    property_id CHAR(36) NOT NULL PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES `User`(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_id ON Property(property_id);

-- ===========================
-- 3) Booking
-- ===========================
CREATE TABLE Booking (
    booking_id CHAR(36) NOT NULL PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending','confirmed','canceled') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES `User`(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_status ON Booking(status);

-- ===========================
-- 4) Payment
-- ===========================
CREATE TABLE Payment (
    payment_id CHAR(36) NOT NULL PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card','paypal','stripe') NOT NULL,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- ===========================
-- 5) Review
-- ===========================
CREATE TABLE Review (
    review_id CHAR(36) NOT NULL PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES `User`(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);

-- ===========================
-- 6) Message
-- ===========================
CREATE TABLE Message (
    message_id CHAR(36) NOT NULL PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES `User`(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES `User`(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);
