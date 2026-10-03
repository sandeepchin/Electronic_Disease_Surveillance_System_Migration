
-- Select random rows from case table
select top 1 percent * from dbo.ids_case cases 
	where cases.MODIFICATION_DATE >= '2026-04-01'
	order by newid();

-- Pick all values associated with a cases and also pick cases randomly

select cases.case_id,
		convert(varchar,cases.modification_date,23) as case_modified_date,
		party.first_name as first_name,
		party.last_name as last_name,
		convert(varchar,party.birth_date,23) as birth_date,
		cases.model_name as model_name,
		q.QUESTIONSET_ID,  -- Question category
		a.QUESTION_ID,  -- Question text with answer appended sometimes
		a.value   

from dbo.IDS_CASE cases join dbo.IDS_PARTICIPANT participant
		on cases.UNID = participant.case_id
		join dbo.IDS_PARTY party
		on participant.PARTY_ID = party.UNID 
		join dbo.ids_questionset q
		on q.CASE_ID = cases.UNID
		join dbo.IDS_ANSWER a
		on a.QUESTIONSET_ID=q.UNID
    where cases.case_id in 
	(
		select top 1 percent cases.case_id from dbo.ids_case cases 
		where cases.MODIFICATION_DATE >= '2026-04-01'
		order by newid()
	);




-- Answer table does not contain any lab data

select * from dbo.IDS_INVESTIGATION_RESULT_ATTR
