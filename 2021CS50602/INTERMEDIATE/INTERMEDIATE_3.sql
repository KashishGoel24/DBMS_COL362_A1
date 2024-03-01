WITH AlcoholDiagnosesCounts AS (
    SELECT
        subject_id,
        COUNT( hadm_id) AS diagnoses_count
    FROM
        drgcodes
    WHERE 
        LOWER(drgcodes.description) LIKE '%alcoholic%'
    GROUP BY
        subject_id
    HAVING
        COUNT(distinct hadm_id) > 1
)
SELECT
    ADC.subject_id,
    ADC.diagnoses_count
FROM
    AlcoholDiagnosesCounts ADC
ORDER BY
    diagnoses_count DESC, subject_id DESC;