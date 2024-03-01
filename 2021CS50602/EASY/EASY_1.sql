select count(patients.subject_id) 
from patients 
where gender = 'F' and patients.anchor_age <= 30 and patients.anchor_age >= 18