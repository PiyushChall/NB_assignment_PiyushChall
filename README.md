# OPD & Doctor Performance Analytics – Assignment Submission

## Overview
This assignment implements a complete OPD (Outpatient Department) analytics system using SQLite and Python. 
The solution includes database schema design, synthetic data generation, and SQL-based analytical reporting.

The project is structured in a modular and easy-to-understand manner, keeping the SQLite workflow simple 
and fully aligned with the assignment requirements.

---

## Project Structure

opd_assignment/
│
├── opd.db                     # SQLite database containing all tables and data
├── schema.sql                 # SQL script used to create all required tables
│
├── populate.py                # Script to generate branches, doctors, and 80,000 OPD visits
├── populate_extra.py          # Script to generate diagnosis, prescriptions, and billing entries
│
├── sql_solutions.sql          # All analytical SQL queries (Tasks 1–8)
│
└── README.md                  # Complete explanation of approach, tools, decisions

---

## Tools & Libraries Used

### SQLite (VS Code Extension)
SQLite was chosen for simplicity and ease of setup.  
The VS Code extension was used to:
. Create and browse the database  
. Execute schema.sql  
. Run analysis queries interactively  

No server installation or migrations were required.

### Python
Python was used to generate realistic synthetic OPD data.  
Major libraries used:
. Faker: Generate random names, dates, diagnoses, medicines
. Random: Random selection of values
. SQLite3: Direct interaction with OPD database

---

## Step-by-Step Explanation

### 1. Database Schema
The schema.sql file defines the six required tables:
. branch  
. doctor  
. opd_visit  
. opd_diagnosis  
. opd_prescription  
. opd_billing  

Each table includes proper foreign key links to model real hospital OPD workflows.

### 2. Base Data Generation (populate.py)
This script generates:
. 4 branches  
. 40 doctors across specializations  
. 80,000 OPD visits  
Each visit has:
. patient ID  
. doctor ID  
. branch ID  
. timestamp  
. consultation type (New or Follow-up)

### 3. Additional Data (populate_extra.py)
Adds real-world supportive information:
. Diagnoses for each visit  
. 1–3 prescriptions per visit  
. Billing entries with fees, charges, discounts, payment modes  

This completes the dataset required for all analytics tasks.

### 4. Analytical SQL Queries (sql_solutions.sql)
Implements all 8 assignment queries:
1. Monthly doctor-wise OPD load and top 5 busiest doctors  
2. New vs follow-up ratio per month per branch  
3. Top diagnoses per specialization  
4. Most prescribed medicines  
5. Monthly branch revenue (Gross & Net)  
6. Average ticket size by payment mode  
7. Doctor performance (visits, revenue, avg fee)  
8. Peak-hour OPD traffic per branch  

Each query is optimized and properly commented.

---

## How to Run the Project

### Step 1: Create Tables
Open VS Code → SQLite extension → Run `schema.sql`.

### Step 2: Generate Data
Run:
python populate.py
python populate_extra.py

### Step 3: Execute Analytics
Open `sql_solutions.sql` in VS Code and run queries directly on `opd.db`.

---

## Final Notes
. The project follows a simple and scalable structure.  
. Data generation is reproducible and realistic.  
. SQL queries meet all assignment evaluation parameters.  
