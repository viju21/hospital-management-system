"""
Hospital Management System - Dataset Generator
Generates realistic synthetic data for all 5 tables
Output: CSV files in phase-1-sql/dataset/generated/
"""

import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta
import os

# ── Initialize Faker ───────────────────────────────────────
fake = Faker()
random.seed(42)
Faker.seed(42)

# ── Configuration ──────────────────────────────────────────
NUM_PATIENTS      = 200
NUM_DOCTORS       = 30
NUM_APPOINTMENTS  = 500
OUTPUT_DIR        = os.path.join(os.path.dirname(__file__), "generated")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ── Reference Data ─────────────────────────────────────────
BLOOD_GROUPS = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

SPECIALIZATIONS = [
    "Cardiology", "Neurology", "Orthopedics", "Pediatrics",
    "Dermatology", "Oncology", "Radiology", "General Medicine",
    "Psychiatry", "ENT"
]

DEPARTMENTS = [
    "Cardiology Dept", "Neurology Dept", "Orthopedics Dept",
    "Pediatrics Dept", "Dermatology Dept", "Oncology Dept",
    "Radiology Dept", "General Medicine Dept",
    "Psychiatry Dept", "ENT Dept"
]

STATUSES = ["scheduled", "completed", "cancelled"]

MEDICINES = [
    "Paracetamol", "Amoxicillin", "Ibuprofen", "Metformin",
    "Atorvastatin", "Omeprazole", "Lisinopril", "Cetirizine",
    "Azithromycin", "Pantoprazole", "Aspirin", "Ciprofloxacin"
]

DOSAGES = [
    "500mg twice daily", "250mg thrice daily", "10mg once daily",
    "5mg twice daily", "20mg once daily", "1 tablet after meals",
    "2 tablets before bed", "15ml syrup thrice daily"
]


# ── 1. Generate Patients ───────────────────────────────────
def generate_patients():
    patients = []
    for i in range(1, NUM_PATIENTS + 1):
        dob = fake.date_of_birth(minimum_age=1, maximum_age=90)
        patients.append({
            "patient_id": i,
            "name": fake.name(),
            "dob": dob.strftime("%Y-%m-%d"),
            "phone": fake.numerify("##########"),
            "blood_group": random.choice(BLOOD_GROUPS)
        })
    
    df = pd.DataFrame(patients)
    df.to_csv(f"{OUTPUT_DIR}/patients.csv", index=False)
    print(f"✅ patients.csv     → {len(df)} rows")
    return df


# ── 2. Generate Doctors ────────────────────────────────────
def generate_doctors():
    doctors = []
    for i in range(1, NUM_DOCTORS + 1):
        spec_idx = (i - 1) % len(SPECIALIZATIONS)
        doctors.append({
            "doctor_id": i,
            "name": "Dr. " + fake.name(),
            "specialization": SPECIALIZATIONS[spec_idx],
            "department": DEPARTMENTS[spec_idx]
        })
    
    df = pd.DataFrame(doctors)
    df.to_csv(f"{OUTPUT_DIR}/doctors.csv", index=False)
    print(f"✅ doctors.csv      → {len(df)} rows")
    return df


# ── 3. Generate Appointments ───────────────────────────────
def generate_appointments(patients_df, doctors_df):
    appointments = []
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2025, 1, 1)
    
    for i in range(1, NUM_APPOINTMENTS + 1):
        appt_date = fake.date_between(start_date=start_date, end_date=end_date)
        appointments.append({
            "appt_id": i,
            "patient_id": random.choice(patients_df["patient_id"].tolist()),
            "doctor_id": random.choice(doctors_df["doctor_id"].tolist()),
            "date": appt_date.strftime("%Y-%m-%d"),
            "status": random.choice(STATUSES)
        })
    
    df = pd.DataFrame(appointments)
    df.to_csv(f"{OUTPUT_DIR}/appointments.csv", index=False)
    print(f"✅ appointments.csv → {len(df)} rows")
    return df


# ── 4. Generate Prescriptions ──────────────────────────────
def generate_prescriptions(appointments_df):
    # Only completed appointments get prescriptions
    completed = appointments_df[appointments_df["status"] == "completed"]["appt_id"].tolist()
    
    prescriptions = []
    pres_id = 1
    
    for appt_id in completed:
        num_medicines = random.randint(1, 2)
        chosen = random.sample(MEDICINES, num_medicines)
        for medicine in chosen:
            prescriptions.append({
                "pres_id": pres_id,
                "appt_id": appt_id,
                "medicine": medicine,
                "dosage": random.choice(DOSAGES)
            })
            pres_id += 1
    
    df = pd.DataFrame(prescriptions)
    df.to_csv(f"{OUTPUT_DIR}/prescriptions.csv", index=False)
    print(f"✅ prescriptions.csv → {len(df)} rows")
    return df


# ── 5. Generate Bills ──────────────────────────────────────
def generate_bills(patients_df):
    bills = []
    bill_id = 1
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2025, 1, 1)
    
    for patient_id in patients_df["patient_id"].tolist():
        num_bills = random.randint(1, 3)
        for _ in range(num_bills):
            bill_date = fake.date_between(start_date=start_date, end_date=end_date)
            bills.append({
                "bill_id": bill_id,
                "patient_id": patient_id,
                "amount": round(random.uniform(500, 15000), 2),
                "paid": random.choice(["yes", "no"]),
                "date": bill_date.strftime("%Y-%m-%d")
            })
            bill_id += 1
    
    df = pd.DataFrame(bills)
    df.to_csv(f"{OUTPUT_DIR}/bills.csv", index=False)
    print(f"✅ bills.csv        → {len(df)} rows")
    return df


# ── Main Execution ─────────────────────────────────────────
if __name__ == "__main__":
    print("\n🏥 Hospital Management System — Data Generator")
    print("=" * 50)
    
    patients_df = generate_patients()
    doctors_df = generate_doctors()
    appointments_df = generate_appointments(patients_df, doctors_df)
    prescriptions_df = generate_prescriptions(appointments_df)
    bills_df = generate_bills(patients_df)
    
    print("=" * 50)
    print(f"✅ All CSV files saved to: {OUTPUT_DIR}")