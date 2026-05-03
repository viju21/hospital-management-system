-- ============================================================
-- Hospital Management System
-- Snowflake × GitHub Integration
-- Run as ACCOUNTADMIN
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- ── Step 1: Create Secret (store GitHub PAT) ────────────────
-- This keeps your credentials safe inside Snowflake
CREATE SECRET IF NOT EXISTS hms_github_secret
    TYPE     = PASSWORD
    USERNAME = 'viju21'    -- ← replace with your GitHub username
    PASSWORD = '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';   -- ← replace with your PAT token

-- Verify secret created
SHOW SECRETS;

-- ── Step 2: Create API Integration ─────────────────────────
CREATE API INTEGRATION IF NOT EXISTS hms_github_integration
    API_PROVIDER             = git_https_api
    API_ALLOWED_PREFIXES     = ('https://github.com/viju21/')  -- ← replace
    ALLOWED_AUTHENTICATION_SECRETS = (hms_github_secret)
    ENABLED                  = TRUE;

-- Verify integration
SHOW API INTEGRATIONS;

-- ── Step 3: Create Git Repository Object ───────────────────
CREATE GIT REPOSITORY IF NOT EXISTS hms_git_repo
    API_INTEGRATION  = hms_github_integration
    GIT_CREDENTIALS  = hms_github_secret
    ORIGIN           = 'https://github.com/viju21/hospital-management-system.git'; -- ← replace

-- ── Step 4: Fetch latest from GitHub ───────────────────────
ALTER GIT REPOSITORY hms_git_repo FETCH;

-- ── Step 5: Verify files are visible from GitHub ────────────
LS @hms_git_repo/branches/main/;