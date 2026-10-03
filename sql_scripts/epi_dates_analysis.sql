
select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		max(a.VALUE)
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	where a.QUESTION_ID like 'Result%' 
	--and c.MODEL_NAME like '%General'
	group by c.MODEL_NAME,q.questionset_id,a.QUESTION_ID;

	select * from IDS_PARTY p where p.external_id in ('191447','191439');

	select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		max(a.VALUE),
		e.NAME
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	left join IDS_ENUM_ENTRY e
	on a.value = e.value
	where a.QUESTION_ID like 'ADDRESS_TYPE%' and
	c.MODEL_NAME like '%STD'
	group by c.MODEL_NAME,q.questionset_id,a.QUESTION_ID,e.name;

	select * from ids_party p where p.ALIAS is not null;


	-- Checking specimen date in IDS_ANSWER and IDS_INVESTIGATIONA_RESULT_ATTR tables

	select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		max(a.VALUE)
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID

	where a.QUESTION_ID like '%specimen%'
	and c.model_name like '%lead%'
	--and q.questionset_id like 'CLINICAL'
	group by c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID
	order by a.question_id

-- lab tables
-- Pick the earliest from all the specimen dates for all models

  select 
		c.case_id,
		ira.name,
		ira.value

	from IDS_CASE c join ids_participant p
	on c.unid = p.case_id
	join ids_investigation i on
	i.participant_id = p.unid
	join ids_investigation_result ir on
	ir.investigation_id = i.unid
	join ids_investigation_result_attr ira on
	ira.investigation_result_id = ir.unid
	
	where ira.name like '%SPECIMENDATE%'
	and c.model_name like '%hep%'
	group by c.case_id, ira.name,ira.value
	order by c.case_id;
	--and c.case_id like '100963361';


-- Onset date 
-- Question package
select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		--max(a.value)
		max(cast(a.VALUE as DATE)) 
	
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID

	where a.QUESTION_ID like 'onset_date'
	and c.model_name like '%hep%'
	--and q.questionset_id like 'CLINICAL'
	group by c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID
	--order by a.value desc;

  select 
		c.case_id,
		ira.name,
		ira.value

	from IDS_CASE c join ids_participant p
	on c.unid = p.case_id
	join ids_investigation i on
	i.participant_id = p.unid
	join ids_investigation_result ir on
	ir.investigation_id = i.unid
	join ids_investigation_result_attr ira on
	ira.investigation_result_id = ir.unid
	
	where ira.name like '%diagnosis%'
	and c.model_name like '%general%'
	group by c.case_id, ira.name,ira.value
	order by c.case_id;


-- miscellaneous
select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		a.VALUE 
	
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID

	where a.QUESTION_ID like '%UNREPORT_TO_CDC%'

	select 
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		a.VALUE 
	
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID

	where a.QUESTION_ID like 'TRAVEL'
	and c.model_name like '%STD%';