import sqlite3
import random
from faker import Faker

fake = Faker()

conn = sqlite3.connect("opd.db")
cur = conn.cursor()


# Diagnosis List
diagnosis_list = [
    "Hypertension", "Diabetes", "Migraine", "Skin Infection", "Fracture",
    "Asthma", "Allergy", "Gastritis", "Flu", "Anxiety"
]


# Prescription Medicines
medicines = [
    "Paracetamol", "Ibuprofen", "Amoxicillin", "Cetirizine", "Omeprazole",
    "Vitamin D", "Calcium Tablets", "Metformin", "Aspirin", "Cough Syrup"
]


# Fetch all visit IDs
cur.execute("SELECT visit_id FROM opd_visit")
visit_ids = [row[0] for row in cur.fetchall()]

diagnosis_data = []
prescription_data = []
billing_data = []

for vid in visit_ids:
    # Diagnosis
    diagnosis_data.append((
        vid,
        random.choice(diagnosis_list)
    ))

    # Prescriptions (1–3 medicines)
    for _ in range(random.randint(1, 3)):
        prescription_data.append((
            vid,
            random.choice(medicines),
            f"{random.randint(1,2)} times/day",
            random.randint(3, 10)
        ))

    # Billing
    consult_fee = random.choice([300, 400, 500, 600])
    additional = random.choice([0, 50, 100, 150])
    discount = random.choice([0, 20, 50])

    billing_data.append((
        vid,
        consult_fee,
        additional,
        discount,
        random.choice(["Cash", "UPI", "Card"])
    ))

# Insert diagnosis
cur.executemany(
    "INSERT INTO opd_diagnosis (visit_id, diagnosis_name) VALUES (?,?)",
    diagnosis_data
)

# Insert prescriptions
cur.executemany(
    "INSERT INTO opd_prescription (visit_id, medicine_name, dose, duration_days) VALUES (?,?,?,?)",
    prescription_data
)

# Insert billing
cur.executemany(
    "INSERT INTO opd_billing (visit_id, consultation_fee, additional_charges, discount_amount, payment_mode) VALUES (?,?,?,?,?)",
    billing_data
)

conn.commit()
conn.close()

print("Diagnosis, prescriptions, and billing data inserted successfully.")
