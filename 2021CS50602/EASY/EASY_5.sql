SELECT
    icustays.subject_id,
    patients.anchor_age,
    COUNT(distinct icustays.stay_id) 
FROM
    icustays
JOIN
    patients ON icustays.subject_id = patients.subject_id
WHERE
    icustays.first_careunit = 'Coronary Care Unit (CCU)'
GROUP BY
    icustays.subject_id, patients.anchor_age
HAVING
    COUNT(distinct icustays.stay_id) = (
        SELECT MAX(num_admissions)
        FROM (
            SELECT
                icustays.subject_id,
                COUNT(distinct icustays.stay_id) AS num_admissions
            FROM
                icustays
            WHERE
                icustays.first_careunit = 'Coronary Care Unit (CCU)'
            GROUP BY
                icustays.subject_id
        ) AS max_admissions
    )
ORDER BY
    patients.anchor_age DESC, icustays.subject_id DESC