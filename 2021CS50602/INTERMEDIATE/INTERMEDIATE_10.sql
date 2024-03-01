SELECT
        p.subject_id,
        p.anchor_year,
        pres.drug
    FROM 
        patients p
        JOIN admissions a ON p.subject_id = a.subject_id
        JOIN prescriptions pres ON a.subject_id = pres.subject_id and a.hadm_id = pres.hadm_id
    GROUP BY 
        p.subject_id, pres.drug 
    HAVING 
        count(DISTINCT a.hadm_id ) > 1
    ORDER BY 
        p.subject_id DESC, p.anchor_year DESC, pres.drug DESC
    LIMIT 1000