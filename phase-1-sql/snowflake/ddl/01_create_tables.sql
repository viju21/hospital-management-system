-- ============================================================
-- Hospital Management System - DDL
-- Script 01: Create All Tables
-- Snowflake Version
-- ============================================================

USE ROLE SYSADMIN;
USE WAREHOUSE hms_wh;
USE DATABASE hospital_db;
USE SCHEMA core;

-- =============================================
-- 1. PATIENTS Table
-- =============================================
CREATE OR REPLACE TABLE patients (
    patient_id   INT             NOT NULL PRIMARY KEY,
    name         VARCHAR(100)    NOT NULL,
    dob          DATE            NOT NULL,
    phone        VARCHAR(15)     NOT NULL UNIQUE,
    blood_group  VARCHAR(5)      NOT NULL,
    
    CONSTRAINT chk_blood_group 
        CHECK (blood_group IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
)
COMMENT = 'Patient demographic information';

-- =============================================
-- 2. DOCTORS Table
-- =============================================
CREATE OR REPLACE TABLE doctors (
    doctor_id      INT          NOT NULL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    specialization VARCHAR(80)  NOT NULL,
    department     VARCHAR(80)  NOT NULL
)
COMMENT = 'Doctor profiles and departments';

-- =============================================
-- 3. APPOINTMENTS Table
-- =============================================
CREATE OR REPLACE TABLE appointments (
    appt_id     INT          NOT NULL PRIMARY KEY,
    patient_id  INT          NOT NULL,
    doctor_id   INT          NOT NULL,
    date        DATE         NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'scheduled',
    
    CONSTRAINT fk_appt_patient 
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    
    CONSTRAINT fk_appt_doctor 
        FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_status 
        CHECK (status IN ('scheduled', 'completed', 'cancelled'))
)
COMMENT = 'Patient appointment records';

-- =============================================
-- 4. PRESCRIPTIONS Table
-- =============================================
CREATE OR REPLACE TABLE prescriptions (
    pres_id   INT           NOT NULL PRIMARY KEY,
    appt_id   INT           NOT NULL,
    medicine  VARCHAR(100)  NOT NULL,
    dosage    VARCHAR(100)  NOT NULL,
    
    CONSTRAINT fk_pres_appt 
        FOREIGN KEY (appt_id) REFERENCES appointments(appt_id) ON DELETE CASCADE
)
COMMENT = 'Prescriptions issued during appointments';

-- =============================================
-- 5. BILLS Table
-- =============================================
CREATE OR REPLACE TABLE bills (
    bill_id     INT            NOT NULL PRIMARY KEY,
    patient_id  INT            NOT NULL,
    amount      DECIMAL(12,2)  NOT NULL,
    paid        VARCHAR(5)     NOT NULL DEFAULT 'no',
    date        DATE           NOT NULL,
    
    CONSTRAINT fk_bill_patient 
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_paid 
        CHECK (paid IN ('yes', 'no'))
)
COMMENT = 'Billing information for patients';

-- =============================================
-- Final Verification
-- =============================================
SHOW TABLES IN SCHEMA core;

SELECT 
    table_name,
    row_count,
    comment
FROM information_schema.tables 
WHERE table_schema = 'CORE'
ORDER BY table_name;