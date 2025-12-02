import sqlite3
from faker import Faker
import random

fake = Faker()

conn = sqlite3.connect("opd.db")
cur = conn.cursor()

# Insert branches
branches = [
    ("Central Hospital", "Mumbai"),
    ("WestCare Hospital", "Thane"),
    ("CityMed Clinic", "Bhayandar"),
    ("HealthPlus Center", "Borivali")
]

cur.executemany(
    "INSERT INTO branch (branch_name, city) VALUES (?, ?)",
    branches
)

# Insert doctors
specializations = ["Cardiology", "Dermatology", "Orthopedics", "Pediatrics", "General Medicine"]

doctors = []
for _ in range(40):
    doctors.append((
        random.randint(1, 4),
        fake.name(),
        random.choice(specializations),
        fake.date_between(start_date="-5y", end_date="today")
    ))

cur.executemany(
    "INSERT INTO doctor (branch_id, doctor_name, specialization, joining_date) VALUES (?, ?, ?, ?)",
    doctors
)

# Insert OPD visits
visits = []
for _ in range(80000):
    visits.append((
        random.randint(1, 30000),
        random.randint(1, 40),
        random.randint(1, 4),
        fake.date_time_between(start_date="-1y", end_date="now"),
        random.choice(["New", "Follow-up"])
    ))

cur.executemany(
    "INSERT INTO opd_visit (patient_id, doctor_id, branch_id, visit_datetime, consultation_type) VALUES (?, ?, ?, ?, ?)",
    visits
)

conn.commit()
conn.close()

print("Data inserted successfully.")
