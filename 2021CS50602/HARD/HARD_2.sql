WITH DiedPatients AS (
    SELECT DISTINCT
        d.subject_id,
        d.icd_code,
        d.icd_version
    FROM
        diagnoses_icd d
        JOIN admissions a ON d.hadm_id = a.hadm_id
    WHERE
        a.hospital_expire_flag = 1
    GROUP BY
        d.subject_id, d.icd_code, d.icd_version
    HAVING
        COUNT(*) > 0
),

SurvivedPatients AS (
    SELECT DISTINCT
        diagnoses_icd.subject_id, 
        diagnoses_icd.icd_code,
        diagnoses_icd.icd_version
    FROM diagnoses_icd
    WHERE NOT EXISTS (
        SELECT 1
        FROM DiedPatients
        WHERE diagnoses_icd.subject_id = DiedPatients.subject_id and DiedPatients.icd_code = diagnoses_icd.icd_code and diagnoses_icd.icd_version = DiedPatients.icd_version
    )
),

SurvivedAverageAge AS (
    SELECT
        SP.icd_code,
        SP.icd_version,
        AVG(p.anchor_age) AS survived_avg_age
    FROM
        SurvivedPatients SP
        JOIN patients p ON SP.subject_id = p.subject_id
    GROUP BY
        SP.icd_code, SP.icd_version
),

DifferentDiagnoses AS (
    SELECT
        d.icd_code,
        d.icd_version,
        dicd.long_title,
        ROUND((SUM(CASE WHEN a.hospital_expire_flag = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS mortality_rate
    FROM
        admissions a
        JOIN diagnoses_icd d ON d.subject_id = a.subject_id AND d.hadm_id = a.hadm_id
        JOIN d_icd_diagnoses dicd ON d.icd_code = dicd.icd_code AND d.icd_version = dicd.icd_version
    GROUP BY
        d.icd_code, d.icd_version, dicd.long_title
    ORDER BY
        mortality_rate DESC, dicd.long_title ASC
    LIMIT 245
)

SELECT
    dd.long_title,
    saa.survived_avg_age
FROM
    DifferentDiagnoses dd
    JOIN SurvivedAverageAge saa ON dd.icd_code = saa.icd_code AND dd.icd_version = saa.icd_version
ORDER BY
    dd.long_title ASC, saa.survived_avg_age DESC;