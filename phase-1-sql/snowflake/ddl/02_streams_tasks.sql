-- ============================================================
-- Hospital Management System - DDL
-- Script 02: Streams + Task (Auto Bill Creation)
-- Snowflake equivalent of MySQL TRIGGER
-- ============================================================

USE ROLE SYSADMIN;
USE WAREHOUSE hms_wh;
USE DATABASE hospital_db;
USE SCHEMA core;

-- =============================================
-- 1. Create Stream on Appointments Table
-- =============================================
CREATE OR REPLACE STREAM appointments_stream
    ON TABLE appointments
    APPEND_ONLY = FALSE
COMMENT = 'Stream to detect when appointment status changes to completed';

-- =============================================
-- 2. Create Task to Auto-create Bill
-- =============================================
CREATE OR REPLACE TASK auto_bill_task
    WAREHOUSE         = hms_wh
    SCHEDULE          = '1 minute'
    COMMENT           = 'Auto creates bill when appointment status becomes completed'
    WHEN SYSTEM$STREAM_HAS_DATA('appointments_stream')
AS
    INSERT INTO bills (bill_id, patient_id, amount, paid, date)
    SELECT 
        COALESCE(MAX(b.bill_id), 0) + ROW_NUMBER() OVER (ORDER BY s.appt_id),
        s.patient_id,
        1500.00,                    -- Default consultation fee (can be updated later)
        'no',
        CURRENT_DATE()
    FROM appointments_stream s
    WHERE s.status = 'completed'
      AND s.METADATA$ACTION = 'INSERT'
      AND s.METADATA$ISUPDATE = TRUE
      AND NOT EXISTS (
            SELECT 1 FROM bills b 
            WHERE b.patient_id = s.patient_id 
              AND b.date = CURRENT_DATE()
          );

-- =============================================
-- 3. Resume the Task (Important!)
-- =============================================
ALTER TASK auto_bill_task RESUME;

-- =============================================
-- Verification
-- =============================================
SHOW STREAMS   IN SCHEMA core;
SHOW TASKS     IN SCHEMA core;

SELECT name, state, scheduled_time 
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE name = 'AUTO_BILL_TASK'
ORDER BY scheduled_time DESC 
LIMIT 5;