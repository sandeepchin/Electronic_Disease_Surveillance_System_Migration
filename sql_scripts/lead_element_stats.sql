-- Query to compute fill rates for Lead models

select c.MODEL_NAME
		,q.QUESTIONSET_ID as Package
		,a.QUESTION_ID as UniqueID
		,max(a.value) as value
	from
		IDS_ANSWER a join IDS_QUESTIONSET q on
		a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c on
		q.CASE_ID = c.UNID
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		group by a.QUESTION_ID,c.MODEL_NAME,q.QUESTIONSET_ID;

-- Getting counts too for each question
select c.MODEL_NAME
		,q.QUESTIONSET_ID as Package
		,a.QUESTION_ID as UniqueID
		,max(a.value) as value
		--,string_agg(cast(a.value as nvarchar(MAX)),',') as list_of_values
		,count(a.value) as count_of_values
	from
		IDS_ANSWER a join IDS_QUESTIONSET q on
		a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c on
		q.CASE_ID = c.UNID
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		group by a.QUESTION_ID,c.MODEL_NAME,q.QUESTIONSET_ID
		order by a.QUESTION_ID;

-- No aggregation to check if descriptions are good - not good, dont run
select c.MODEL_NAME
		,q.QUESTIONSET_ID as Package
		,a.QUESTION_ID as UniqueID
		,a.value as value
		,rc.description as description
	from
		IDS_ANSWER a join IDS_QUESTIONSET q on
		a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c on
		q.CASE_ID = c.UNID
		left join ids_reference_code rc
		on a.value = rc.reference_code
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		--group by a.QUESTION_ID,c.MODEL_NAME,q.QUESTIONSET_ID,a.value
		order by a.QUESTION_ID;


-- Getting total number of cases
select count(*) as case_count
		,c.MODEL_NAME 
	from 
		IDS_CASE c
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		group by c.MODEL_NAME

-- Getting counts together

select x.model_name
		,x.question_package
		,x.UniqueID
		,x.value
		,x.count_of_values
		,y.case_count
	from
	(select c.MODEL_NAME
		,q.QUESTIONSET_ID as question_package
		,a.QUESTION_ID as UniqueID
		,max(a.value) as value
		,count(a.value) as count_of_values
	from
		IDS_ANSWER a join IDS_QUESTIONSET q on
		a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c on
		q.CASE_ID = c.UNID
		left join ids_reference_code rc
		on a.value = rc.reference_code
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		group by a.QUESTION_ID,c.MODEL_NAME,q.QUESTIONSET_ID
	)x join
	(select count(*) as case_count
		,c.MODEL_NAME 
	from 
		IDS_CASE c
		where c.MODEL_NAME in ('Childhood_Lead_Child_Model','Childhood_Lead_Investigation_Model')
		group by c.MODEL_NAME
	)y
	on x.MODEL_NAME = y.MODEL_NAME
	order by x.UniqueID


-- Same query but for other models

select x.model_name
		,x.question_package
		,x.UniqueID
		,x.value
		,x.count_of_values
		,y.case_count
	from
	(select c.MODEL_NAME
		,q.QUESTIONSET_ID as question_package
		,a.QUESTION_ID as UniqueID
		,max(a.value) as value
		,count(a.value) as count_of_values
	from
		IDS_ANSWER a join IDS_QUESTIONSET q on
		a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c on
		q.CASE_ID = c.UNID
		left join ids_reference_code rc
		on a.value = rc.reference_code
		where c.MODEL_NAME in ('DiseaseSurveillanceModel_Hep','DiseaseSurveillanceModel_STD','DiseaseSurveillanceModel_General','ClusterModel','PortalApplicationModel')
		group by a.QUESTION_ID,c.MODEL_NAME,q.QUESTIONSET_ID
	)x join
	(select count(*) as case_count
		,c.MODEL_NAME 
	from 
		IDS_CASE c
		where c.MODEL_NAME in ('DiseaseSurveillanceModel_Hep','DiseaseSurveillanceModel_STD','DiseaseSurveillanceModel_General','ClusterModel','PortalApplicationModel')
		group by c.MODEL_NAME
	)y
	on x.MODEL_NAME = y.MODEL_NAME
	order by x.UniqueID