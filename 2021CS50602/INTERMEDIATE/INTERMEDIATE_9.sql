SELECT DISTINCT
    a1.subject_id
FROM 
    admissions a1
JOIN
    admissions a2 ON a1.subject_id = a2.subject_id AND a2.hadm_id <> a1.hadm_id AND a1.dischtime < a2.admittime
JOIN
    diagnoses_icd d1 ON a1.subject_id = d1.subject_id AND a1.hadm_id = d1.hadm_id AND d1.icd_code LIKE 'I21%'
ORDER BY 
    a1.subject_id DESC
LIMIT 1000