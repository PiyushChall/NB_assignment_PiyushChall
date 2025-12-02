-- Doctor-wise OPD load monthly; top 5 busiest per branch.
-- This query retrieves the total number of outpatient visits for each doctor,
-- grouped by branch and month. The results are ordered by month and the number
-- of visits in descending order.
SELECT
    d.doctor_name,
    v.branch_id,
    SUBSTR (v.visit_datetime, 1, 7) AS month,
    COUNT(*) AS total_visits
FROM
    opd_visit v
    JOIN doctor d ON v.doctor_id = d.doctor_id
GROUP BY
    d.doctor_name,
    v.branch_id,
    month
ORDER BY
    month,
    total_visits DESC;

-- New vs follow-up ratio per branch per month.
-- This query retrieves the top 5 doctors with the highest number of outpatient visits
-- for each branch. It uses a window function to rank doctors within each branch
-- based on the number of visits and filters to include only the top 5.
SELECT
    *
FROM
    (
        SELECT
            d.doctor_name,
            v.branch_id,
            COUNT(*) AS visits,
            ROW_NUMBER() OVER (
                PARTITION BY
                    v.branch_id
                ORDER BY
                    COUNT(*) DESC
            ) AS rn
        FROM
            opd_visit v
            JOIN doctor d ON v.doctor_id = d.doctor_id
        GROUP BY
            d.doctor_name,
            v.branch_id
    )
WHERE
    rn <= 5;

-- Top 3 diagnoses per specialization.
-- This query counts the number of 'New' and 'Follow-up' consultations
-- for each branch, grouped by month. The results are ordered by month and branch ID.
SELECT
    branch_id,
    SUBSTR (visit_datetime, 1, 7) AS month,
    SUM(
        CASE
            WHEN consultation_type = 'New' THEN 1
            ELSE 0
        END
    ) AS new_count,
    SUM(
        CASE
            WHEN consultation_type = 'Follow-up' THEN 1
            ELSE 0
        END
    ) AS followup_count
FROM
    opd_visit
GROUP BY
    branch_id,
    month
ORDER BY
    month,
    branch_id;

-- Most prescribed medicines with patient count.
-- This query retrieves the top 3 most common diagnoses for each doctor specialization. 
-- It uses a window function to rank diagnoses within each specialization
-- based on their frequency and filters to include only the top 3.
SELECT
    *
FROM
    (
        SELECT
            d.specialization,
            diag.diagnosis_name,
            COUNT(*) AS diag_count,
            ROW_NUMBER() OVER (
                PARTITION BY
                    d.specialization
                ORDER BY
                    COUNT(*) DESC
            ) AS rn
        FROM
            opd_diagnosis diag
            JOIN opd_visit v ON diag.visit_id = v.visit_id
            JOIN doctor d ON v.doctor_id = d.doctor_id
        GROUP BY
            d.specialization,
            diag.diagnosis_name
    )
WHERE
    rn <= 3;

-- Monthly revenue per branch (gross & net).
-- This query retrieves the number of unique patients prescribed each medicine. 
-- The results are ordered by patient count in descending order.
SELECT
    medicine_name,
    COUNT(DISTINCT visit_id) AS patient_count
FROM
    opd_prescription
GROUP BY
    medicine_name
ORDER BY
    patient_count DESC;

-- Avg ticket size by payment mode.
-- This query calculates the average ticket size for each payment mode
-- by averaging the total charges (consultation fee + additional charges - discount amount)
-- grouped by payment mode.
SELECT
    payment_mode,
    AVG(
        consultation_fee + additional_charges - discount_amount
    ) AS avg_ticket_size
FROM
    opd_billing
GROUP BY
    payment_mode;

-- Doctor performance: visits, revenue, avg fee.
-- This query retrieves each doctor's total number of outpatient visits,
-- total revenue generated from those visits, and average consultation fee. 
-- The results are ordered by total revenue in descending order.
SELECT
    d.doctor_name,
    COUNT(v.visit_id) AS total_visits,
    SUM(
        b.consultation_fee + b.additional_charges - b.discount_amount
    ) AS total_revenue,
    AVG(b.consultation_fee) AS avg_fee
FROM
    opd_visit v
    JOIN doctor d ON v.doctor_id = d.doctor_id
    JOIN opd_billing b ON v.visit_id = b.visit_id
GROUP BY
    d.doctor_name
ORDER BY
    total_revenue DESC;

-- Peak hour analysis per branch.
-- This query counts the number of outpatient visits for each branch, grouped by hour of the day. 
-- The results are ordered by branch ID and visit count in descending order.
SELECT
    branch_id,
    SUBSTR (visit_datetime, 12, 2) AS hour,
    COUNT(*) AS visit_count
FROM
    opd_visit
GROUP BY
    branch_id,
    hour
ORDER BY
    branch_id,
    visit_count DESC;