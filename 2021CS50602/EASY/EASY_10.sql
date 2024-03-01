SELECT DISTINCT p.subject_id, p.anchor_age
FROM patients p
JOIN admissions a1 ON p.subject_id = a1.subject_id
JOIN admissions a2 ON p.subject_id = a2.subject_id AND a1.hadm_id <> a2.hadm_id
JOIN procedures_icd pr1 ON a1.hadm_id = pr1.hadm_id
JOIN procedures_icd pr2 ON a2.hadm_id = pr2.hadm_id AND pr1.icd_code = pr2.icd_code and pr1.icd_version = pr2.icd_version
WHERE p.anchor_age < 50 order by subject_id, anchor_age