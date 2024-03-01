SELECT
    admissions.subject_id,
    admissions.hadm_id,
    COUNT(DISTINCT diagnoses_icd.icd_code) AS distinct_diagnoses_count,
    drug
FROM
    admissions
JOIN
    diagnoses_icd ON admissions.subject_id = diagnoses_icd.subject_id and admissions.hadm_id = diagnoses_icd.hadm_id
JOIN
    prescriptions ON diagnoses_icd.subject_id = prescriptions.subject_id and diagnoses_icd.hadm_id = prescriptions.hadm_id
WHERE
    diagnoses_icd.icd_code LIKE 'V4%'
    AND (
        LOWER(prescriptions.drug) LIKE '%prochlorperazine%'
        OR LOWER(prescriptions.drug) LIKE '%bupropion%'
    )
GROUP BY
    admissions.subject_id,
    admissions.hadm_id,
    drug
HAVING
    COUNT(DISTINCT diagnoses_icd.icd_code) > 1
ORDER BY
    distinct_diagnoses_count DESC,
    subject_id DESC,
    hadm_id DESC,
    drug ASC