WITH PrescriptionCounts AS (
    SELECT
        p.drug,
        COUNT(*) AS prescription_count
    FROM
        prescriptions p
        JOIN admissions a ON p.hadm_id = a.hadm_id
    WHERE
        a.admittime <= p.starttime and p.starttime <= a.admittime + INTERVAL '12' HOUR
    GROUP BY
        p.drug
)
SELECT
    drug,
    prescription_count
FROM
    PrescriptionCounts
ORDER BY
    prescription_count DESC, drug DESC