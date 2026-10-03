
-- getting questions by disease (product type)

select p.NAME,
		c.MODEL_NAME,
		q.questionset_id,
		a.QUESTION_ID,
		max(a.VALUE)
	from IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	on c.PRODUCT_ID = p.UNID
	--where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
	
	where convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
	and p.name like 'Diphtheria%'
	group by c.MODEL_NAME,
		p.NAME,
		a.QUESTION_ID,
		q.questionset_id
	order by p.name


-- Get number of cases
select count(c.UNID) as case_counts,
		c.MODEL_NAME,
		p.NAME as disease_name
		from dbo.ids_case c join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		and p.name like 'Diphtheria%'
		group by c.MODEL_NAME, p.name


-- to get fill rates

select x.MODEL_NAME as model_name,
		x.QUESTIONSET_ID as question_package,
		x.name as disease_type,
		
		x.QUESTION_ID as field_name,
		x.max_value,
		x.count_of_values,
		y.case_counts

	from 
	(
		select p.NAME,
		c.MODEL_NAME,
		a.QUESTION_ID,
		q.questionset_id,
		max(a.VALUE) as max_value,
		count(a.value) as count_of_values
		from 
			IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.CASE_ID = c.UNID
			join IDS_PRODUCT p
			on c.PRODUCT_ID = p.UNID
			--where a.QUESTION_ID like 'DISEASE%' and not a.QUESTION_ID like 'DISEASE_STATUS%' 
	
			where convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
			and p.name like 'Diphtheria%'
			group by c.MODEL_NAME,
				p.NAME,
				a.QUESTION_ID,
				q.QUESTIONSET_ID
	)x join
	(
		select count(c.UNID) as case_counts,
		c.MODEL_NAME,
		p.NAME as disease_name
		from dbo.ids_case c join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		and p.name like 'Diphtheria%'
		group by c.MODEL_NAME, p.name
	)y
	on x.NAME = y.disease_name and x.MODEL_NAME=y.MODEL_NAME
	order by x.QUESTION_ID