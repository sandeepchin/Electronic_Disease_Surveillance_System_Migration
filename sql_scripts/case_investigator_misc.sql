
select a.question_id,max(a.value) from IDS_ANSWER a 
where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO%' 
group by a.question_id

select --max(a.value),
c.MODEL_NAME,
q.QUESTIONSET_ID from IDS_ANSWER a join ids_party p
on a.value = p.UNID
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO' 
group by q.QUESTIONSET_ID,c.MODEL_NAME
order by a.value;


select a.question_id,
	a.value,
	c.MODEL_NAME,
	q.QUESTIONSET_ID
	from 
	IDS_ANSWER a 
	join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	where a.QUESTION_ID like '%ONSET_DATE%' 
--group by c.model_name
--order by a.value desc;

select --max(a.value),
c.MODEL_NAME,
q.QUESTIONSET_ID,
a.QUESTION_ID,
a.value,
p.FIRST_NAME,
q.UNID
from IDS_ANSWER a join ids_party p
on a.value = p.UNID
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID

where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
--and a1.QUESTION_ID like 'INVESTIGATION_STATUS_DATE'
and c.CASE_ID like '113238677'

select * from ids_case where CASE_ID  like '113238677';


select a.question_id,c.MODEL_NAME from IDS_ANSWER a 
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
where a.QUESTION_ID like '%CLOSE_DATE%' 
group by a.question_id,c.MODEL_NAME

select a.question_id,a.value from IDS_ANSWER a 
where a.QUESTION_ID like '%CLOSE_DATE%' 
--group by a.question_id

select a.question_id,c.MODEL_NAME from IDS_ANSWER a 
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
where a.QUESTION_ID like '%CASE_CLOSE%' 
group by a.question_id,c.MODEL_NAME

select a.question_id,c.MODEL_NAME from IDS_ANSWER a 
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
where a.QUESTION_ID like '%CREAT%' 
group by a.question_id,c.MODEL_NAME

select a.question_id,c.MODEL_NAME from IDS_ANSWER a 
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
where a.QUESTION_ID like 'CREAT%' 
group by a.question_id,c.MODEL_NAME

select a.question_id,max(a.value) from IDS_ANSWER a 
where a.QUESTION_ID like '%DATE%' 
group by a.question_id
order by a.QUESTION_ID

select a.question_id,max(a.value) from IDS_ANSWER a 
where a.QUESTION_ID like '%INVESTIGATION_STATUS%' 
group by a.question_id
order by a.QUESTION_ID

-- Testing

select * from ids_answer a where a.value like '5978325227' and a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'

select * from IDS_QUESTIONSET where UNID like '12065423790'

select * from ids_answer a where a.QUESTIONSET_ID like '12065423790'

-- When there are more than one investigator listed for a case 
-- you can use iteration field to get the different investigators

select --max(a.value),
c.MODEL_NAME,
q.QUESTIONSET_ID,
a.iteration,
a.QUESTION_ID,
a.value,
a1.QUESTION_ID,
a1.value,
p.FIRST_NAME,
q.UNID
from IDS_ANSWER a join ids_party p
on a.value = p.UNID
join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID
join IDS_CASE c
on q.CASE_ID = c.UNID
join IDS_ANSWER a1
on a1.QUESTIONSET_ID = q.UNID and 
a.ITERATION = a1.ITERATION
where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
and a1.QUESTION_ID like 'INVESTIGATION_STATUS_DATE'
and c.CASE_ID like '113238677'

/* This works for one case */
select a.QUESTION_ID,
		a.value,
		p.FIRST_NAME
	from 
		IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join IDS_PARTY p
		on a.value = p.UNID
	where 
	c.CASE_ID like '113238677' and
	 a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
	and a.ITERATION in
	(select max(a.ITERATION) from IDS_ANSWER  a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		where 
		c.CASE_ID like '113238677' and
		a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO')


-- testing subquery
select max(a1.ITERATION) as it
		,a1.questionset_id
		,max(c1.CASE_ID) as case_id
		from 
			IDS_ANSWER  a1 join IDS_QUESTIONSET q1 
			on a1.QUESTIONSET_ID = q1.UNID
			join IDS_CASE c1 
			on q1.CASE_ID = c1.UNID
		where 
			convert(varchar,c1.MODIFICATION_DATE,23) > '2026-01-01' and
			a1.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
			group by a1.QUESTIONSET_ID
		order by max(c1.CASE_ID)

-- Query to get the latest case investigator for any case

select a.QUESTION_ID
		,p.FIRST_NAME
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
			convert(varchar,c1.MODIFICATION_DATE,23) > '2026-01-01' and
			a1.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
			group by a1.QUESTIONSET_ID
		) sub
		on a.ITERATION = sub.it and
		a.QUESTIONSET_ID =sub.QUESTIONSET_ID and
		c.CASE_ID = sub.case_id
	where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'
	order by  c.CASE_ID
	--and c.CASE_ID like '113238677'


select a.ITERATION from IDS_ANSWER a where a.QUESTION_ID like 'INVESTIGATION_STATUS_ASSIGNED_TO'

-- testing
select count(a.value),a.question_id,c.MODEL_NAME 
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID =q.UNID 
	join IDS_CASE c 
	on q.CASE_ID = c.UNID
	where
	a.question_id like 'INVESTIGATION_STATUS%' 
	and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	group by c.MODEL_NAME,a.QUESTION_ID;

-- looking for suspect, probable, confirmed

select a.QUESTION_ID,max(a.value) from IDS_ANSWER a 
where a.value like 'Suspect'
group by a.question_id

-- Value sets for three statuses
select max(a.value),a.question_id 
from IDS_ANSWER a where a.QUESTION_ID like 'DISEASE_STATUS%' group by a.QUESTION_ID

select a.value, a.question_id 
from IDS_ANSWER a where a.QUESTION_ID like 'INVESTIGATION_STATUS' group by a.QUESTION_ID,a.value

select a.value, a.question_id 
from IDS_ANSWER a where a.QUESTION_ID like 'CASE_INVESTIGATION_STATUS%' group by a.QUESTION_ID,a.value

select count(a.value),a.question_id,c.MODEL_NAME 
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID =q.UNID 
	join IDS_CASE c 
	on q.CASE_ID = c.UNID
	where
	a.question_id like 'DISEASE_STATUS%' 
	and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	group by c.MODEL_NAME,a.QUESTION_ID;

select count(*),a.value,a.question_id 
from IDS_ANSWER a where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' group by a.value,a.QUESTION_ID


select count(*),a.value,a.question_id,max(r.DESCRIPTION)
from IDS_ANSWER a left join IDS_REFERENCE_CODE r
on a.value = r.REFERENCE_CODE
where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
group by a.value,a.QUESTION_ID

-- Shows ETIOLOGY
select a.value,a.question_id 
from IDS_ANSWER a where a.value like 'Influenza, Seasonal';

-- Shows disease code that matches with answer table value
select *
from IDS_PRODUCT a where a.NAME like 'Influenza, Seasonal';

-- This one is not it
select *
from IDS_CASE a where a.CASE_NAME like 'Influenza, Seasonal';

-- Grouping cases by model and disease type

select p.NAME,
		c.MODEL_NAME
		,a1.QUESTION_ID
		,max(a1.value) as value
		,count(a1.value) as count_of_values
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	on c.PRODUCT_ID = p.UNID
	--on a.value = p.CODE
	left join IDS_ANSWER a1
	on a1.QUESTIONSET_ID = a.QUESTIONSET_ID
	where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
	and a1.QUESTION_ID like 'INVESTIGATION_STATUS'
	and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	group by c.MODEL_NAME,
		a1.QUESTION_ID,
		p.NAME

-- Case investigation status
select p.NAME,
		c.MODEL_NAME
		,a1.QUESTION_ID
		,max(a1.value) as value
		,count(a1.value) as count_of_values
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	--on a.value = p.CODE
	on c.PRODUCT_ID = p.UNID
	left join IDS_ANSWER a1
	on a1.QUESTIONSET_ID = a.QUESTIONSET_ID
	where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
	and a1.QUESTION_ID like 'CASE_INVESTIGATION_STATUS%'
	and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	group by c.MODEL_NAME,
		a1.QUESTION_ID,
		p.NAME

-- Disease Status

select p.NAME,
		c.MODEL_NAME
		,a1.QUESTION_ID
		,max(a1.value) as value
		,count(a1.value) as count_of_values
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	--on a.value = p.CODE
	on c.PRODUCT_ID = p.UNID
	left join IDS_ANSWER a1
	on a1.QUESTIONSET_ID = a.QUESTIONSET_ID
	where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
	and a1.QUESTION_ID like 'DISEASE_STATUS%'
	and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	group by c.MODEL_NAME,
		a1.QUESTION_ID,
		p.NAME

-- Get case counts by model and disease type

select count(c.UNID) as case_counts,
		c.MODEL_NAME,
		p.NAME
		from dbo.ids_case c join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		group by c.MODEL_NAME, p.name

select  case 
		 when x.model_name like 'DiseaseSurveillanceModel_General' then 'General'
		 when x.model_name like 'DiseaseSurveillanceModel_STD' then 'STD'
		 when x.model_name like 'DiseaseSurveillanceModel_Hep' then 'Hepatitis'
		 when x.model_name like 'Childhood_Lead_Child_Model' then 'Childhood Lead'
		 when x.model_name like 'DiseaseSurveillanceModel_Coinfection' then 'Coinfection'
		 when x.model_name like 'ClusterModel' then 'Cluster'
		 else ''
		 end as model_name
		,x.disease_name
		,x.question_id
		,x.value
		,x.count_of_values
		,y.case_counts as case_count
		from
		(select p.NAME as disease_name,
			c.MODEL_NAME
			,a1.QUESTION_ID
			,max(a1.value) as value
			,count(a1.value) as count_of_values
			from IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.CASE_ID = c.UNID
			join IDS_PRODUCT p
			--on a.value = p.CODE
			on c.PRODUCT_ID = p.UNID
			left join IDS_ANSWER a1
			on a1.QUESTIONSET_ID = a.QUESTIONSET_ID
			where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
			and (a1.QUESTION_ID like 'DISEASE_STATUS%' or a1.QUESTION_ID like 'INVESTIGATION_STATUS' or a1.QUESTION_ID like 'CASE_INVESTIGATION_STATUS%')
			and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
			group by c.MODEL_NAME,
				a1.QUESTION_ID,
				p.NAME
		) x join 
	(select count(c.UNID) as case_counts,
		c.MODEL_NAME,
		p.NAME as disease_name
		from dbo.ids_case c join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		group by c.MODEL_NAME, p.name
		) y
		on x.MODEL_NAME = y.MODEL_NAME and x.disease_name = y.disease_name
		order by x.QUESTION_ID

select a.question_id, c.case_id,c.modification_date
	from IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.case_id = c.unid
		where a.question_id like 'DISEASE_STATUS_P';