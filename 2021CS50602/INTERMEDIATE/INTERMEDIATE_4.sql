select admissions.subject_id, admissions.hadm_id, diagnoses_icd.icd_code, d_icd_diagnoses.long_title
    FROM admissions JOIN diagnoses_icd ON admissions.hadm_id = diagnoses_icd.hadm_id 
    JOIN d_icd_diagnoses ON diagnoses_icd.icd_code = d_icd_diagnoses.icd_code AND d_icd_diagnoses.icd_version = diagnoses_icd.icd_version
    WHERE admissions.admission_type = 'URGENT' and admissions.hospital_expire_flag = 1
    and d_icd_diagnoses.long_title IS NOT NULL
    ORDER BY admissions.subject_id DESC , admissions.hadm_id DESC, diagnoses_icd.icd_code DESC, d_icd_diagnoses.long_title DESC
    LIMIT 1000