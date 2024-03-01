SELECT subject_id, COUNT(hadm_id) FROM admissions GROUP BY subject_id
HAVING COUNT(hadm_id) = (
    SELECT MAX(num_admissions)
    FROM (
        SELECT subject_id, COUNT(hadm_id) as num_admissions FROM admissions GROUP BY subject_id
    ) AS max_admissions
)
ORDER BY subject_id ASC