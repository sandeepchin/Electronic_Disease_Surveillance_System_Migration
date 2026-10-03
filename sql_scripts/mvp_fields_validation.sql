
-- Get case ids with corresponding fields

select a.value,a.question_id,c.CASE_ID as case_id,
	c.MODIFICATION_DATE,
	q.QUESTIONSET_ID,
	c.MODEL_NAME
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID 
	join IDS_CASE c
	on q.CASE_ID = c.UNID

where a.QUESTION_ID like 'COUNTRY'
		and a.value is not null
		and c.MODEL_NAME like 'EHRAndScreeningModel_STD'
	 --and c.CASE_ID like '112447691'
	--and convert(varchar,c.MODIFICATION_DATE,23) > '2026-03-01';


select model_name from ids_case group by MODEL_NAME;