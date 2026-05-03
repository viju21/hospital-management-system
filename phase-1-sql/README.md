# Phase 1 — SQL Implementation (Snowflake)

> Hospital database built using Snowflake SQL with GitHub repository integration

---

## 📂 Project Structure

```text
phase-1-sql/
├── dataset/            # Python scripts to generate synthetic hospital data
├── snowflake/
│   ├── setup/          # Initial Snowflake config (DB, Warehouse, Git Integration, Stages)
│   ├── ddl/            # Data Definition Language (Tables, Streams, Tasks)
│   ├── dml/            # Data Manipulation Language (Loading data)
│   └── queries/        # Analytical queries and reporting
```

## 🚀 Quick Start Guide

Follow these steps in order to set up the Phase 1 Snowflake environment.

### Step 1 — Generate Synthetic Data
First, generate the synthetic dataset (CSV files) locally.
```bash
cd dataset
pip install -r requirements.txt
python generate_data.py
```
This will create `patients.csv`, `doctors.csv`, `appointments.csv`, `prescriptions.csv`, and `bills.csv` inside the `dataset/generated/` folder.

### Step 2 — Snowflake Setup
You can run these scripts either via the **Snowflake Web UI (Snowsight)** or using the **SnowSQL CLI**. 

1. **Git Integration:** Run `snowflake/setup/00_snowflake_git_setup.sql`. 
   > **Note:** Requires `ACCOUNTADMIN` role. Replace the placeholder GitHub username and PAT token before running.
2. **Create Database & Warehouse:** Run `snowflake/setup/01_create_warehouse_db.sql`.
3. **Create Stage & File Format:** Run `snowflake/setup/02_create_stage.sql`.

### Step 3 — Create Tables (DDL)
Set up the schema structure.
1. Run `snowflake/ddl/01_create_tables.sql` to build the core tables.
2. Run `snowflake/ddl/02_streams_tasks.sql` to set up continuous data pipelines.

### Step 4 — Load Data (DML)
Upload your generated CSV files to the Snowflake internal stage (`hms_csv_stage`), then run the loading scripts.

If using SnowSQL, you can upload all generated files to the stage using the `PUT` command:
```bash
snowsql -a <account_identifier> -u <username> -q "USE DATABASE hospital_db; USE SCHEMA core; PUT file://dataset/generated/*.csv @hms_csv_stage auto_compress=true;"
```

Then execute the DML scripts in order to copy the data into your tables:
1. `snowflake/dml/01_load_patients.sql`
2. `snowflake/dml/02_load_doctors.sql`
3. `snowflake/dml/03_load_appointments.sql`
4. `snowflake/dml/04_load_prescriptions.sql`
5. `snowflake/dml/05_load_bills.sql`

### Step 5 — Analytics & Queries
Once data is loaded, run the analytical queries in the `snowflake/queries/` directory to test the database:
- `01_basic_selects.sql`
- `02_joins.sql`
- `03_aggregates.sql`
- `04_date_functions.sql`
- `05_advanced_queries.sql`