-- ============================================================
-- Hospital Management System
-- Warehouse + Database + Schema
-- ============================================================

USE ROLE SYSADMIN;

-- ── Warehouse ───────────────────────────────────────────────
CREATE WAREHOUSE IF NOT EXISTS hms_wh
    WAREHOUSE_SIZE   = 'X-SMALL'
    AUTO_SUSPEND     = 60
    AUTO_RESUME      = TRUE
    COMMENT          = 'Hospital Management System Warehouse';

-- ── Database ────────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS hospital_db
    COMMENT = 'Hospital Management System - Phase 1 SQL';

-- ── Schema ──────────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS hospital_db.core
    COMMENT = 'Core schema - patients, doctors, appointments, prescriptions, bills';

-- ── Set context ─────────────────────────────────────────────
USE WAREHOUSE hms_wh;
USE DATABASE  hospital_db;
USE SCHEMA    core;

-- ── Verify ──────────────────────────────────────────────────
SHOW WAREHOUSES  LIKE 'hms_wh';
SHOW DATABASES   LIKE 'hospital_db';
SHOW SCHEMAS     IN DATABASE hospital_db;