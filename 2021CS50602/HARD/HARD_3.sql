WITH procedures AS (
    SELECT DISTINCT subject_id, hadm_id, icd_code, icd_version
    FROM procedures_icd
    GROUP BY subject_id, hadm_id, icd_code, icd_version
),

AverageICUStaysEachPatient AS (
    SELECT 
        SUM(COALESCE(icu.los,0)) AS average_stay_patient,
        picd.hadm_id,
        picd.icd_code,
        picd.icd_version
    FROM 
        icustays icu RIGHT JOIN 
        procedures picd ON picd.hadm_id = icu.hadm_id
    GROUP BY 
        picd.hadm_id,  picd.icd_code, picd.icd_version, picd.subject_id
),

AverageStayDuration AS (
    SELECT
        p.icd_code,
        p.icd_version,
        AVG(icu3.average_stay_patient) AS average_stay
    FROM 
        AverageICUStaysEachPatient icu3 JOIN
        procedures p ON p.hadm_id = icu3.hadm_id and p.icd_code = icu3.icd_code and p.icd_version = icu3.icd_version
    GROUP BY 
        p.icd_code, p.icd_version
)

SELECT DISTINCT ON (p.subject_id, p.gender, icu2.icd_code, icu2.icd_version)
    p.subject_id,
    p.gender,
    icu2.icd_code,
    icu2.icd_version
FROM 
    patients p JOIN 
    admissions a ON p.subject_id = a.subject_id JOIN
    AverageICUStaysEachPatient icu1 ON icu1.hadm_id = a.hadm_id
    JOIN 
    procedures_icd picd ON picd.hadm_id = a.hadm_id JOIN 
    AverageStayDuration icu2 ON icu2.icd_code = picd.icd_code AND icu2.icd_version = picd.icd_version
WHERE 
    icu1.average_stay_patient < icu2.average_stay
ORDER BY 
    p.subject_id ASC, icu2.icd_code DESC, icu2.icd_version DESC, p.gender ASC
LIMIT 1000