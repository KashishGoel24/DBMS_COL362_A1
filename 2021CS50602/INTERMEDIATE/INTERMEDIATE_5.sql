WITH ICUStaysWithLabTest AS (
    SELECT
        icu.subject_id,
        icu.hadm_id,
        AVG(icu.LOS) AS avg_stay_duration
    FROM
        icustays icu
        JOIN labevents lab ON icu.subject_id = lab.subject_id AND icu.hadm_id = lab.hadm_id
    WHERE
        lab.ITEMID = 50878
        AND icu.LOS IS NOT NULL
    GROUP BY
        icu.subject_id, icu.hadm_id
    ORDER BY
        avg_stay_duration DESC, icu.subject_id DESC
    
)
SELECT
    subject_id,
    AVG(avg_stay_duration) AS avg_stay_duration
FROM
    ICUStaysWithLabTest
GROUP BY
    subject_id, hadm_id
ORDER BY
    avg_stay_duration DESC, subject_id DESC
LIMIT 1000