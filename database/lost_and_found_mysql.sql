-- Lost and Found System - MySQL Database Script
-- Run this script in MySQL Workbench or mysql CLI.

CREATE DATABASE IF NOT EXISTS lost_and_found_system
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE lost_and_found_system;

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone_number VARCHAR(30) NULL,
    role ENUM('Student', 'Staff', 'Security', 'Admin') NOT NULL DEFAULT 'Student',
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS locations (
    location_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    location_name VARCHAR(120) NOT NULL,
    description VARCHAR(500) NULL,
    PRIMARY KEY (location_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS lost_items (
    lost_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    description VARCHAR(1000) NULL,
    category VARCHAR(100) NULL,
    color VARCHAR(80) NULL,
    date_lost DATE NOT NULL,
    time_lost TIME NULL,
    location_lost VARCHAR(150) NULL,
    location_id BIGINT UNSIGNED NULL,
    status ENUM('Lost', 'Found', 'Claimed') NOT NULL DEFAULT 'Lost',
    reported_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (lost_item_id),
    INDEX idx_lost_items_reported_by (reported_by),
    INDEX idx_lost_items_location_id (location_id),
    CONSTRAINT fk_lost_items_reported_by FOREIGN KEY (reported_by) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_lost_items_location FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS found_items (
    found_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    description VARCHAR(1000) NULL,
    category VARCHAR(100) NULL,
    color VARCHAR(80) NULL,
    date_found DATE NOT NULL,
    time_found TIME NULL,
    location_found VARCHAR(150) NULL,
    location_id BIGINT UNSIGNED NULL,
    status ENUM('Available', 'Claimed') NOT NULL DEFAULT 'Available',
    found_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (found_item_id),
    INDEX idx_found_items_found_by (found_by),
    INDEX idx_found_items_location_id (location_id),
    CONSTRAINT fk_found_items_found_by FOREIGN KEY (found_by) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_found_items_location FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS matched_items (
    lost_item_id BIGINT UNSIGNED NOT NULL,
    found_item_id BIGINT UNSIGNED NOT NULL,
    matched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (lost_item_id, found_item_id),
    INDEX idx_matched_items_lost_item_id (lost_item_id),
    INDEX idx_matched_items_found_item_id (found_item_id),
    CONSTRAINT fk_matched_items_lost_item FOREIGN KEY (lost_item_id) REFERENCES lost_items (lost_item_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_matched_items_found_item FOREIGN KEY (found_item_id) REFERENCES found_items (found_item_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS claims (
    claim_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    item_type ENUM('LOST', 'FOUND') NOT NULL,
    item_id BIGINT UNSIGNED NOT NULL,
    claim_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verification_status ENUM('Pending', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
    approved_by BIGINT UNSIGNED NULL,
    PRIMARY KEY (claim_id),
    INDEX idx_claims_user_id (user_id),
    INDEX idx_claims_item_type_item_id (item_type, item_id),
    INDEX idx_claims_approved_by (approved_by),
    CONSTRAINT fk_claims_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_claims_approved_by FOREIGN KEY (approved_by) REFERENCES users (user_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS admin_security_logs (
    log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    action_performed VARCHAR(255) NOT NULL,
    date_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    item_affected_type ENUM('Lost_Item', 'Found_Item', 'Claim') NULL,
    item_affected_id BIGINT UNSIGNED NULL,
    PRIMARY KEY (log_id),
    INDEX idx_admin_security_logs_user_id (user_id),
    CONSTRAINT fk_admin_security_logs_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

