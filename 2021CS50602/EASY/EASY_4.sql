select count(distinct concat(icd_code, '|', icd_version)) 
from procedures_icd 
where procedures_icd.subject_id = '10000117' 