-- Schema definitions for OPD management system
CREATE TABLE branch (
    branch_id INTEGER PRIMARY KEY AUTOINCREMENT,
    branch_name TEXT,
    city TEXT
);

CREATE TABLE doctor (
    doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    branch_id INTEGER,
    doctor_name TEXT,
    specialization TEXT,
    joining_date TEXT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE opd_visit (
    visit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    doctor_id INTEGER,
    branch_id INTEGER,
    visit_datetime TEXT,
    consultation_type TEXT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE opd_diagnosis (
    diagnosis_id INTEGER PRIMARY KEY AUTOINCREMENT,
    visit_id INTEGER,
    diagnosis_name TEXT,
    FOREIGN KEY (visit_id) REFERENCES opd_visit(visit_id)
);

CREATE TABLE opd_prescription (
    prescription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    visit_id INTEGER,
    medicine_name TEXT,
    dose TEXT,
    duration_days INTEGER,
    FOREIGN KEY (visit_id) REFERENCES opd_visit(visit_id)
);

CREATE TABLE opd_billing (
    bill_id INTEGER PRIMARY KEY AUTOINCREMENT,
    visit_id INTEGER,
    consultation_fee REAL,
    additional_charges REAL,
    discount_amount REAL,
    payment_mode TEXT,
    FOREIGN KEY (visit_id) REFERENCES opd_visit(visit_id)
);
