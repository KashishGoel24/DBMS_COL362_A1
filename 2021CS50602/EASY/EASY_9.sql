SELECT COUNT(DISTINCT a.hadm_id) as num_admissions
FROM admissions a
JOIN labevents l ON a.hadm_id = l.hadm_id
WHERE l.flag = 'abnormal' AND a.hospital_expire_flag = 1