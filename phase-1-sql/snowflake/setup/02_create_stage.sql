-- ============================================================
-- Hospital Management System
-- Internal Stage for CSV files
-- ============================================================

USE WAREHOUSE hms_wh;
USE DATABASE  hospital_db;
USE SCHEMA    core;

-- ── Create Stage ────────────────────────────────────────────
CREATE STAGE IF NOT EXISTS hms_csv_stage
    COMMENT = 'Internal stage for loading hospital CSV files';

-- ── Create File Format ──────────────────────────────────────
CREATE FILE FORMAT IF NOT EXISTS hms_csv_format
    TYPE                         = CSV
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER                  = 1
    NULL_IF                      = ('NULL', 'null', 'none', '')
    EMPTY_FIELD_AS_NULL          = TRUE
    TRIM_SPACE                   = TRUE
    COMMENT                      = 'CSV format for hospital data files';

-- ── Verify ──────────────────────────────────────────────────
SHOW STAGES       IN SCHEMA hospital_db.core;
SHOW FILE FORMATS IN SCHEMA hospital_db.core;
