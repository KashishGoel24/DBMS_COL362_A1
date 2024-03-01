WITH LatestAdmissions AS (
    SELECT
        p.subject_id,
        p.gender,
        a.hadm_id,
        a.admittime
    FROM
        patients p
    JOIN
        admissions a ON p.subject_id = a.subject_id
    WHERE
        (a.subject_id, a.admittime) IN (
            SELECT
                subject_id,
                MAX(admittime) AS latest_admit_time
            FROM
                admissions
            GROUP BY
                subject_id
        )
)

SELECT
    la.gender,
    100.0 * SUM(CASE WHEN a.hospital_expire_flag = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT la.subject_id) AS mortality_rate
FROM
    LatestAdmissions la, 
    diagnoses_icd d,  
    d_icd_diagnoses dicd, 
    admissions a 
WHERE
    la.subject_id = a.subject_id AND la.hadm_id = a.hadm_id AND d.subject_id = a.subject_id AND d.hadm_id = a.hadm_id
    AND d.icd_code = dicd.icd_code and d.icd_version = dicd.icd_version AND
    dicd.long_title LIKE '%Meningitis%'
GROUP BY
    la.gender
ORDER BY
    mortality_rate ASC, la.gender DESC