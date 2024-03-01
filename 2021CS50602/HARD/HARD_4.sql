WITH Nodes AS (
        SELECT *
        FROM admissions 
        ORDER BY admittime
        LIMIT 500
    ) 
    -- WHERE admittime < dischtime
    ,

Edges as (SELECT DISTINCT
        a1.subject_id AS node1,
        a2.subject_id AS node2
    FROM
        Nodes a1 
        JOIN Nodes a2 ON a1.admittime <= a1.dischtime and a2.admittime <= a2.dischtime and (a1.admittime <= a2.dischtime AND a1.dischtime >= a2.admittime)
        JOIN diagnoses_icd d1 ON a1.hadm_id = d1.hadm_id
        JOIN diagnoses_icd d2 ON a2.hadm_id = d2.hadm_id and
        a1.subject_id <> a2.subject_id AND
        d1.icd_code = d2.icd_code 
        AND d1.icd_version = d2.icd_version)

-- select count(*) from Edges

SELECT
  CASE WHEN COUNT(*) > 0 THEN 'True' ELSE 'False' END AS pathexists
FROM Edges e1
JOIN Edges e2 ON e1.node2 = e2.node1
WHERE e1.node1 = 18237734 AND e2.node2 = 13401124;