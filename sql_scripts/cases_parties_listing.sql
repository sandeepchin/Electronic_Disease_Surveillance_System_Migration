
-- Author: Sandeep Chintabathina
-- June 2026

-- Building queries relating the party and cases 
--Listing by case numbers  --> 8,044,968 rows (April 2026)
-- case numbers June 15 ---> 8,206,448
-- For the last 180 days irrespective of status --> 467,434 (april 2026)
-- 447,518 (June 15 2026)
select cases.case_id as case_id, -- application id seen in system
		cases.create_date as creation_date,
		case 
			when participant.type='0' then 'Primary'
			when participant.type='1' then 'Spouse'
			else 'Other'
		end as participant_type,
		cases.status as status,
		party.first_name as first_name,
		party.last_name as last_name,
		party.birth_date as birth_date
	from
		dbo.IDS_CASE cases join dbo.IDS_PARTICIPANT participant
		on cases.UNID = participant.case_id
		join dbo.IDS_PARTY party
		on participant.PARTY_ID = party.UNID 
	where cases.MODIFICATION_DATE >= '2025-12-15'
	order by cases.create_date desc;


-- Listing by party --> 2,563,912 rows
select 
		party.first_name as first_name,
		party.last_name as last_name,
		party.birth_date as birth_date,
		--string_agg(cast(cases.case_id as nvarchar(MAX)),',')  -- cast needed to make data fit in the output column
		--string_agg(cast(cases.create_date as nvarchar(MAX)),',')
		max(cases.case_id) as latest_case_id, 
		max(cases.create_date) as latest_creation_date,
		case 
			when max(participant.type)='0' then 'Primary'
			when max(participant.type)='1' then 'Spouse'
			else 'Other'
		end as participant_type
	from
		dbo.IDS_CASE cases join dbo.IDS_PARTICIPANT participant
		on cases.UNID = participant.case_id
		join dbo.IDS_PARTY party
		on participant.PARTY_ID = party.UNID 
	group by
		party.first_name,party.Last_name,party.birth_date
	order by max(cases.create_date) desc;


-- Linking cases with questions
select cases.case_id,
		string_agg(qs.case_id,',') as question_list
	from	
		dbo.ids_case cases join dbo.ids_questionset qs
		on cases.unid = qs.case_id
	group by cases.case_id
	order by cases.case_id desc;


-- select question set and its answers for cases between June 1 2025 to current
-- Limiting to Admin, demographic and clinical question packages
-- 21,255,256 rows took 7 min 19s since June 1 2025
select a.question_id,  --question text with answer appended sometimes
		a.value,   -- response
		a.questionset_id,
		q.questionset_id as question_category, -- category of the question
		c.case_id,
		c.create_date
	from 
		dbo.IDS_ANSWER a join dbo.ids_questionset q
		on a.QUESTIONSET_ID=q.UNID
		join dbo.ids_case c on q.CASE_ID = c.UNID
	where 
		c.create_date >= convert(nvarchar,'2025-09-19',21) -- format 21 yyyy-mm-dd hh:mm:ss.zzzz
		and q.questionset_id in ('ADMINISTRATIVE','DEMOGRAPHIC','CLINICAL') ;
		--and question_id in ('DISEASE_STATUS_CONFIRMED','DISEASE_STATUS_PROBABLE','DISEASE_STATUS_SUSPECT');


-- cases modified within the last 180 days --> 467,434 which matches with above

select cases.case_id as case_id, -- application id seen in system
		max(cases.MODIFICATION_DATE) as modification_date,
		--max(cases.status) as status,
		max(party_id) as party_id,
		max(party.first_name) as first_name,
		max(party.last_name) as last_name,
		max(party.birth_date) as birth_date
	from
		dbo.IDS_CASE cases join dbo.IDS_PARTICIPANT participant
		on cases.UNID = participant.case_id
		join dbo.IDS_PARTY party
		on participant.PARTY_ID = party.UNID 
	where cases.MODIFICATION_DATE > '2025-09-19'
	group by cases.case_id
	order by cases.case_id desc;

-- Next set of queries to ensure that cases includes all outbreak cases as well

-- Identifying cases that are linked to particular case
select *
	from dbo.IDS_CASE cases
	where cases.case_id like '100395105';

-- Cases linked to the source case, using its primary key to find all its connections
select * 
 FROM dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
 cl.SOURCE_CASE_ID = cases.UNID
 where cases.UNID = 319856780;

 -- pulling source and connecting cases within a date range
 -- 1160 rows
 select cases.CASE_ID as source_case,
		cases2.CASE_ID as target_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19';

-- 307 unique sources?
select cases.CASE_ID as source_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'
	group by cases.case_id;


-- 978 unique targets?
select cases2.CASE_ID as target_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'
	group by cases2.case_id;


select cases.CASE_ID as source_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'
	and cases.case_id in
	(
		select cases2.CASE_ID as target_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'
	group by cases2.case_id
	)
	group by cases.case_id;

-- Checking if cases list contains outbreak cases

select cases.case_id as case_id
	from
		dbo.IDS_CASE cases
	where cases.MODIFICATION_DATE > '2025-09-19'
	and (cases.case_id in
	( select --cases.CASE_ID as source_case
		cases2.CASE_ID as target_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'
	) 
	or
	cases.case_id in
	(select cases.CASE_ID as source_case
		--cases2.CASE_ID as target_case
	from dbo.IDS_CASE_LINK cl join dbo.IDS_CASE cases on
	cl.SOURCE_CASE_ID = cases.UNID
	join dbo.ids_case cases2 on cl.TARGET_CASE_ID = cases2.UNID
	where cl.MODIFICATION_DATE > '2025-09-19'

	)
	)
	;

-- 4509 clustermodels
select cases.case_id as case_id
	from
		dbo.IDS_CASE cases
	--where cases.MODIFICATION_DATE > '2025-09-19'
	where cases.MODEL_NAME like 'Childhood_Lead_Child_Model';

-- Cases related to the 5 models = 1,506,489
-- cases related to the 5 + general model = 7,314,759
select cases.case_id as case_id,
		max(cases.MODEL_NAME)
	from
		dbo.IDS_CASE cases
	where cases.MODEL_NAME in ('DiseaseSurveillanceModel_STD',
	'EHRAndScreeningModel_STD',
	'DiseaseSurveillanceModel_Coinfection',
	'DiseaseSurveillanceModel_Hep',
	'Childhood_Lead_Investigation_Model',  --only 74
	'Childhood_Lead_Child_Model',
	'DiseaseSurveillanceModel_General')
	group by cases.case_id;



-- Miscellaneous
 select * 
 FROM dbo.IDS_CASE_LINK cl
 where cl.source_case_id like '100395105';


 select * 
 FROM dbo.IDS_CASE_LINK cl
 where cl.modification_date > '2025-09-19';


 select * 
 FROM dbo.IDS_CASE_LINK cl
 where cl.target_case_id like '3109890185';

 select * 
 FROM dbo.IDS_CASE_LINK cl
 where cl.source_case_id like '3129728272';

 select *
	from dbo.IDS_CASE cases
	where cases.case_id like '3109890185';