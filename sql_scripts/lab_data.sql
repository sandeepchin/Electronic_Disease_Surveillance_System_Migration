
-- Understanding where lab results are stored

-- The data in Answer table is not related to lab results
-- There is one field that stores the ELR signal and that is all.
select cases.case_id,
		convert(varchar,cases.modification_date,23) as case_modified_date,
		cases.MODIFICATION_DATE,
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
    where cases.case_id in ('113948983');


-- Checking out ids_investigation table and ids_investigation_result and ids_investigation_result_attr tables
-- Data in IDS_INVESTIGATION table is used for linking data and does not appear on user interface 
-- Most fields in IDS_INVESTIGATION_RESULT are blank except for result_date and result_code (which co-occur)
-- IDS_INVESTIGATION_RESULT_ATTR has most of the data for the lab including results, specimen date, loinc and snomed codes
-- Codes that appear in the query results can be further mapped to descriptions(names of tests etc.) using IDS_REFERENCE_CODE table

select  ia.NAME,
		ia.value,
		ir.RESULT_CODE,
		ir.RESULT_DATE,
		i.PARTICIPANT_ID,
		ir.INVESTIGATION_ID,
		ia.investigation_result_id
		--ir.*
	from 
		IDS_INVESTIGATION_RESULT_ATTR ia join IDS_INVESTIGATION_RESULT ir
		on ia.INVESTIGATION_RESULT_ID = ir.UNID
		join IDS_INVESTIGATION i
		on	ir.INVESTIGATION_ID = i.UNID 
		join IDS_PARTICIPANT participant 
		on i.PARTICIPANT_ID = participant.UNID
		join IDS_CASE c
		on participant.case_id = c.unid
	where c.case_id in ('114033422');
	--order by ia.name;

-- Codes that appear for Loinc and Snomed can be mapped to a description using the Reference_code table used for various codes
-- Just a simple attempt to map codes to descriptions but there are some unintended mappings
select x.*, y.description 
from
	(select  ia.NAME,
			ia.value as value
			--ir.RESULT_DATE
		from 
			IDS_INVESTIGATION_RESULT_ATTR ia join IDS_INVESTIGATION_RESULT ir
			on ia.INVESTIGATION_RESULT_ID = ir.UNID
			join IDS_INVESTIGATION i
			on	ir.INVESTIGATION_ID = i.UNID 
			join IDS_PARTICIPANT participant 
			on i.PARTICIPANT_ID = participant.UNID
			join IDS_CASE c
			on participant.case_id = c.unid
			where c.case_id in ('113948983')
			) x left join
	(select ref.DESCRIPTION,
			ref.REFERENCE_CODE as reference_code
		from 
			IDS_REFERENCE_CODE ref
			) y 
	on x.value = y.reference_code;

select * from IDS_REFERENCE_CODE
where REFERENCE_GROUP like 'LAB_FACILITY_NAME%';

select * from IDS_REFERENCE_CODE
where REFERENCE_GROUP like '%LABS';

-- Case with multiple labs (2) and multiple results(2) per lab
-- Each case

select  
		max(i.PARTICIPANT_ID) as participant_id,
		max(ir.INVESTIGATION_ID) as investigation_id,
		--max(ia.investigation_result_id) as investigation_result_id,
		ir.UNID as investigation_result_id,
		max(ir.RESULT_CODE) as result_code,
		max(ir.RESULT_DATE) as result_date,
		ia.name as name,
		max(ia.value) as value
	from 
		IDS_INVESTIGATION_RESULT_ATTR ia join IDS_INVESTIGATION_RESULT ir
		on ia.INVESTIGATION_RESULT_ID = ir.UNID
		join IDS_INVESTIGATION i
		on	ir.INVESTIGATION_ID = i.UNID 
		join IDS_PARTICIPANT participant 
		on i.PARTICIPANT_ID = participant.UNID
		join IDS_CASE c
		on participant.case_id = c.unid
	where c.case_id in ('114033422')
	and ia.NAME in ('Test','SpecimenNumber','Result','Facility_Other','ResultValueNumeric')
	group by ir.unid, ia.name
	;

select ia.NAME from ids_investigation_result_attr ia group by ia.NAME;

-- Checking to see if resultValue and resultValueNumeric are the same
select ia.value as numeric_result,
		ia1.value as result
		from ids_investigation_result_attr ia
		join ids_investigation_result_attr ia1 on
		ia.INVESTIGATION_RESULT_ID = ia1.INVESTIGATION_RESULT_ID
		where ia.NAME like 'ResultValueNumeric'
		and ia1.NAME like 'ResultValue'
		group by ia.value,ia1.value ;

-- Create a list of cases and their corresponding lab data
select c.case_id,
		ir.investigation_id as maven_lab_id,
		ia.investigation_result_id as maven_lab_result_id,
		ir.result_code as data_type,
		ia.NAME as field_name,
		ia.value as field_value
		,max(rc.description) as description
		,'' as IH_field_name
		,'' as IH_field_value
from 
		IDS_INVESTIGATION_RESULT_ATTR ia join IDS_INVESTIGATION_RESULT ir
		on ia.INVESTIGATION_RESULT_ID = ir.UNID
		join IDS_INVESTIGATION i
		on	ir.INVESTIGATION_ID = i.UNID 
		join IDS_PARTICIPANT participant 
		on i.PARTICIPANT_ID = participant.UNID
		join IDS_CASE c
		on participant.case_id = c.unid
		left join ids_reference_code rc
		on ia.value = rc.reference_code
		where 
		c.case_id in ('114033422') and
		convert(varchar,c.CREATE_DATE,23) > '2026-02-01' and
		ia.NAME in
		('SignalId',
		'Facility_Other',
		'Name',
		'Address',
		'City',
		'State',
		'PostalCode',
		'SpecimenNumber',
		'SpecimenDate',
		'SpecimenReceivedDate',
		'SpecimenSource',
		'LOINC',
		'TestLocalDescription',
		'SNOMED',
		'ResultLocalDescription',
		'ResultValue',
		'ResultUnits',
		'Comments') 
		group by c.case_id,ir.investigation_id,ia.investigation_result_id,ir.result_code,ia.name,ia.value
		order by c.case_id,ir.investigation_id,ia.investigation_result_id;


select * from ids_reference_code rc
where rc.reference_code like '738986003';

-- Outbreak stats

select * from ids_case c where c.model_name like 'ClusterModel' and convert(varchar,c.modification_date,23) > '2026-01-01';