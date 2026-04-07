
-- Author: Sandeep Chintabathina
-- April 2026

-- Building queries relating the party and cases 
--Listing by case numbers  --> 8,044,968 rows
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
-- 21,255,256 rows took 7 min 19s
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
	where --c.case_id like '113542190';
		c.create_date >= convert(nvarchar,'2025-06-01',21) -- format 21 yyyy-mm-dd hh:mm:ss.zzzz
		and q.questionset_id in ('ADMINISTRATIVE','DEMOGRAPHIC','CLINICAL');