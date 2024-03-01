select count(distinct hadm_id) 
from diagnoses_icd, d_icd_diagnoses 
where diagnoses_icd.icd_version = d_icd_diagnoses.icd_version AND  diagnoses_icd.icd_code = d_icd_diagnoses.icd_code and d_icd_diagnoses.long_title = 'Cholera due to vibrio cholerae'