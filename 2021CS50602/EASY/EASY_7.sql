SELECT pharmacy_id, COUNT(distinct subject_id) as num_patients_visited
FROM prescriptions
GROUP BY pharmacy_id
HAVING COUNT(distinct subject_id)  = (
    SELECT MIN(num_patients_visited)
    FROM (
        SELECT pharmacy_id, COUNT(distinct subject_id) as num_patients_visited
        FROM prescriptions
        GROUP BY pharmacy_id
    ) AS max_admissions
) order by pharmacy_id ASC 