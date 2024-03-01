WITH PatientDiagnosis AS (
    SELECT
        d.subject_id,
        COUNT(DISTINCT d.hadm_id) AS diagnosis_count
    FROM
        diagnoses_icd d
    WHERE
        d.icd_code = '5723'
    GROUP BY
        d.subject_id
)

SELECT
    p.subject_id,
    p.gender,
    COUNT(DISTINCT a.hadm_id) AS total_admissions,
    MAX(a.admittime) AS last_admission,
    MIN(a.admittime) AS first_admission,
    COALESCE(pd.diagnosis_count, 0) AS diagnosis_count
FROM
    patients p
JOIN
    admissions a ON p.subject_id = a.subject_id
LEFT JOIN
    PatientDiagnosis pd ON p.subject_id = pd.subject_id
WHERE
    p.subject_id IN (SELECT subject_id FROM diagnoses_icd WHERE icd_code = '5723')
GROUP BY
    p.subject_id, p.gender, pd.diagnosis_count
ORDER BY
    total_admissions DESC,
    diagnosis_count DESC,
    last_admission DESC,
    first_admission DESC,
    gender DESC,
    subject_id DESC

LIMIT 1000