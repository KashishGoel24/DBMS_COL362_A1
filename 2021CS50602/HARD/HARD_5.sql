create view Nodes as SELECT *
    FROM admissions 
    ORDER BY admittime
    LIMIT 500;

create view Edges as SELECT DISTINCT
    a1.subject_id AS node1,
    a2.subject_id AS node2
    FROM
    Nodes a1 
    JOIN Nodes a2 ON a1.admittime <= a1.dischtime and a2.admittime <= a2.dischtime and (a1.admittime <= a2.dischtime AND a1.dischtime >= a2.admittime)
    JOIN diagnoses_icd d1 ON a1.hadm_id = d1.hadm_id
    JOIN diagnoses_icd d2 ON a2.hadm_id = d2.hadm_id and
    a1.subject_id <> a2.subject_id AND
    d1.icd_code = d2.icd_code 
    AND d1.icd_version = d2.icd_version;


WITH RECURSIVE PathCTE AS (
  SELECT
    1 AS path_length,
    e.node1 AS start_node,
    e.node2 AS end_node
  FROM Edges e
  WHERE e.node1 = 10001725

  UNION ALL

  SELECT
    pc.path_length + 1,
    e.node1,
    e.node2
  FROM PathCTE pc
  JOIN Edges e ON pc.end_node = e.node1
  WHERE pc.path_length <= 5
)
SELECT
  CASE WHEN COUNT(*) > 0 THEN 'True' ELSE 'False' END AS pathexists
FROM PathCTE
WHERE end_node = 19438360;

drop view Edges;
drop view Nodes;