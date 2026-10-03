
-- Queries requested by Debbie

-- All time cases = 8,179,287 (May 30, 2026)
-- Number of cases created for the years 2024-2026 = 1,849,677
select cases.case_id as case_id, -- application id seen in system
		cases.create_date as case_creation_month,
		cases.status as status,
		party.first_name as first_name,
		party.last_name as last_name,
		party.birth_date as birth_date
	from
		dbo.IDS_CASE cases join dbo.IDS_PARTICIPANT participant
		on cases.UNID = participant.case_id
		join dbo.IDS_PARTY party
		on participant.PARTY_ID = party.UNID 
	where cases.CREATE_DATE >= '2024-01-01'
	order by cases.create_date desc;

-- Get counts by month
select  
		convert(varchar(7),cases.create_date,126)as creation_date,
		count(*) as num_cases_created		
	from
		dbo.IDS_CASE cases 
	where cases.CREATE_DATE >= '2024-01-01'
	group by convert(varchar(7),cases.create_date,126)
	order by  convert(varchar(7),cases.create_date,126) desc;





