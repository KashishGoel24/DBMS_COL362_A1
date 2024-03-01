SELECT
    subject_id,
    COUNT(DISTINCT stay_id) AS stay_count
FROM
    icustays
GROUP BY
    subject_id
HAVING
    COUNT(DISTINCT stay_id) >= 5
ORDER BY
    stay_count DESC, MAX(los) DESC, subject_id DESC
LIMIT 1000