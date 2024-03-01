SELECT
    icu.subject_id,
    COUNT(DISTINCT icu.stay_id) AS total_stays,
    AVG(icu.LOS) AS avg_length_of_stay
FROM
    icustays icu
WHERE 
    icu.first_careunit LIKE '%MICU%' OR icu.last_careunit LIKE '%MICU%'
GROUP BY
    icu.subject_id
HAVING 
    COUNT(DISTINCT icu.stay_id) >= 5
ORDER BY
    avg_length_of_stay DESC , total_stays DESC, subject_id DESC

LIMIT 500