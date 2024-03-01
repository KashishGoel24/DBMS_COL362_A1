select patients.subject_id, patients.anchor_age
    FROM
        patients,
        diagnoses_icd,
        d_icd_diagnoses,
        icustays
    WHERE 
        patients.subject_id = diagnoses_icd.subject_id and icustays.subject_id = patients.subject_id 
        and diagnoses_icd.hadm_id = icustays.hadm_id
        and diagnoses_icd.icd_code = d_icd_diagnoses.icd_code and diagnoses_icd.icd_version = d_icd_diagnoses.icd_version and d_icd_diagnoses.long_title = 'Typhoid Fever'
    GROUP BY 
        patients.subject_id
    ORDER BY 
        patients.subject_id, patients.anchor_age