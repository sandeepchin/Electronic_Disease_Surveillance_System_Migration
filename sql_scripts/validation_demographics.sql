-- Query to check validity of the following fields
-- BIRTH_DATE (IDS_PARTY, IDS_ANSWER)
-- CITY (IDS_CONTACTPOINT, IDS_ANSWER)
-- CURRENT_GENDER_IDENTITY (IDS_ANSWER)
-- FIRST_NAME (IDS_PARTY)
-- GENDER (IDS_PARTY, IDS_ANSWER)
-- GENDER_BIRTH (IDS_ANSWER)
-- INVESTIGATION_START_DATE (IDS_ANSWER)
-- INVESTIGATION_STATUS_ASSIGNED_TO (IDS_ANSWER)
-- LAST_NAME (IDS_PARTY)
-- MMWR_WEEK (IDS_ANSWER)
-- MMWR_YEAR (IDS_ANSWER)
-- RACE (IDS_ANSWER)
-- REPORT_TO_CDC (IDS_ANSWER)
-- STATE (IDS_CONTACTPOINT,IDS_ANSWER)
-- STREET_1 (IDS_CONTACTPOINT, IDS_ANSWER)
-- STREET_2 (IDS_CONTACTPOINT, IDS_ANSWER)
-- ZIP (IDS_ANSWER)  

select * from IDS_ANSWER where QUESTION_ID like 'CURRENT_GENDER%'

select  * from IDS_ANSWER where QUESTION_ID like 'GENDER%'

select  * from IDS_ANSWER where QUESTION_ID like 'BIRTH_DATE%'

select  * from IDS_ANSWER where QUESTION_ID like 'RACE%'

select c.model_name as model_name 
	,c.CASE_ID as case_id
	,q.QUESTIONSET_ID as  question_package
	,a.QUESTION_ID as field_name
	,a.VALUE as field_value
	,max(p.FIRST_NAME) as first_name
	,max(p.last_name) as last_name
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID=c.UNID
		join IDS_PARTICIPANT par
		on par.CASE_ID = c.UNID
		join ids_party p
		on par.PARTY_ID = p.UNID
	where 
		convert(varchar,c.MODIFICATION_DATE,23) > '2026-02-01' and
		(a.QUESTION_ID like 'BIRTH_DATE' or
		a.QUESTION_ID like 'CITY' or
		a.QUESTION_ID like 'CURRENT_GENDER_IDENTITY' or
		a.QUESTION_ID like 'GENDER%' or
		a.QUESTION_ID like 'GENDER_BIRTH%' or
		a.QUESTION_ID like 'INVESTIGATION_START_DATE' or
		--a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO' or
		a.QUESTION_ID like 'MMWR_WEEK' or
		a.QUESTION_ID like 'MMWR_YEAR' or
		a.QUESTION_ID like 'RACE%' or
		a.QUESTION_ID like 'REPORT_TO_CDC' or
		a.QUESTION_ID like 'STATE' or
		a.QUESTION_ID like 'STREET_1' or
		a.QUESTION_ID like 'STREET_2' or
		a.QUESTION_ID like 'ZIP'
		)
	group by a.question_id,a.value,c.case_id,q.QUESTIONSET_ID,c.MODEL_NAME
	order by c.CASE_ID,a.QUESTION_ID

-- For assigned investigator
	select a.QUESTION_ID
		,p.FIRST_NAME
		,p.LAST_NAME
		,c.CASE_ID
	from 
		IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join IDS_PARTY p
		on a.value = p.UNID
	join
	(select max(a1.ITERATION) as it
		,a1.questionset_id
		,max(c1.CASE_ID) as case_id
		from 
			IDS_ANSWER  a1 join IDS_QUESTIONSET q1 
			on a1.QUESTIONSET_ID = q1.UNID
			join IDS_CASE c1 
			on q1.CASE_ID = c1.UNID
		where 
			convert(varchar,c1.MODIFICATION_DATE,23) > '2026-02-01' and
			a1.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
			group by a1.QUESTIONSET_ID
		) sub
		on a.ITERATION = sub.it and
		a.QUESTIONSET_ID =sub.QUESTIONSET_ID and
		c.CASE_ID = sub.case_id
	where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
	order by  c.CASE_ID



select x.model_name 
		,x.case_id
		,x.question_package
		,x.field_name
		,x.field_value
		,x.first_name
		,x.last_name
		,concat(y.FIRST_NAME,' ',y.LAST_NAME) as current_investigator_name
	from 
	(select c.model_name as model_name 
	,c.CASE_ID as case_id
	,q.QUESTIONSET_ID as  question_package
	,a.QUESTION_ID as field_name
	,a.VALUE as field_value
	,max(p.FIRST_NAME) as first_name
	,max(p.last_name) as last_name
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID=c.UNID
		join IDS_PARTICIPANT par
		on par.CASE_ID = c.UNID
		join ids_party p
		on par.PARTY_ID = p.UNID
	where 
		convert(varchar,c.MODIFICATION_DATE,23) > '2026-02-01' and
		(a.QUESTION_ID like 'BIRTH_DATE' or
		a.QUESTION_ID like 'CITY' or
		a.QUESTION_ID like 'CURRENT_GENDER_IDENTITY' or
		a.QUESTION_ID like 'GENDER%' or
		a.QUESTION_ID like 'GENDER_BIRTH%' or
		a.QUESTION_ID like 'INVESTIGATION_START_DATE' or
		--a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO' or
		a.QUESTION_ID like 'MMWR_WEEK' or
		a.QUESTION_ID like 'MMWR_YEAR' or
		a.QUESTION_ID like 'RACE%' or
		a.QUESTION_ID like 'REPORT_TO_CDC' or
		a.QUESTION_ID like 'STATE' or
		a.QUESTION_ID like 'STREET_1' or
		a.QUESTION_ID like 'STREET_2' or
		a.QUESTION_ID like 'ZIP'
		)
	group by a.question_id,a.value,c.case_id,q.QUESTIONSET_ID,c.MODEL_NAME
	--order by c.CASE_ID,a.QUESTION_ID
	)x left join
	(
		select a.QUESTION_ID
		,p.FIRST_NAME
		,p.LAST_NAME
		,c.CASE_ID
	from 
		IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join IDS_PARTY p
		on a.value = p.UNID
	join
	(select max(a1.ITERATION) as it
		,a1.questionset_id
		,max(c1.CASE_ID) as case_id
		from 
			IDS_ANSWER  a1 join IDS_QUESTIONSET q1 
			on a1.QUESTIONSET_ID = q1.UNID
			join IDS_CASE c1 
			on q1.CASE_ID = c1.UNID
		where 
			convert(varchar,c1.MODIFICATION_DATE,23) > '2026-02-01' and
			a1.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
			group by a1.QUESTIONSET_ID
		) sub
		on a.ITERATION = sub.it and
		a.QUESTIONSET_ID =sub.QUESTIONSET_ID and
		c.CASE_ID = sub.case_id
	where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
	--rder by  c.CASE_ID
	)y 
	on x.case_id=y.case_id
	order by x.case_id,x.field_name


	-- Checking to see if Gender_birth fields are found in the STI model

	select a.question_id,
			a.value,
			c.case_id,
			c.model_name
		from IDS_ANSWER a join IDS_QUESTIONSET q 
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c 
			on q.CASE_ID = c.UNID
		where a.question_id like 'GENDER_BIRTH%' 
		--and c.model_name like 'DiseaseSurveillanceModel_STD'