
-- Query to get questions from conditions that are relevant to IMB

--Questions from a list of diseases also grouped by disease
select c.model_name,
		q.QUESTIONSET_ID,
		a.QUESTION_ID,
		max(a.value),
		p.CODE,
		p.NAME
	from
	 IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	on c.PRODUCT_ID = p.UNID
	where p.code in ('AFP','DIP','DIPT','HFLU','HEPA',
					'HEPB_A',
					'HEPB_C',
					'HEPB_CNCT',
					'HEPB_PERI',
					'HEPB_PG',
					'MEAS',
					'NMEN',
					'COV_MIS',
					'MUMPS',
					'PERT',
					'POLN',
					'POL',
					'RUB',
					'RUBCONG',
					'SPX',
					'PNE',
					'TET',
					'CPX')
		group by a.QUESTION_ID, c.MODEL_NAME, q.QUESTIONSET_ID,p.code,p.name

-- Just questions in the list of diseases but not grouped by disease
select c.model_name,
		q.QUESTIONSET_ID,
		a.QUESTION_ID,
		max(a.value) as max_value
		--,STRING_AGG(cast(a.value as nvarchar(MAX)),',') 
	from
	 IDS_ANSWER a join IDS_QUESTIONSET q
	on a.QUESTIONSET_ID = q.UNID
	join IDS_CASE c
	on q.CASE_ID = c.UNID
	join IDS_PRODUCT p
	on c.PRODUCT_ID = p.UNID
	where p.code in ('AFP','DIP','DIPT','HFLU','HEPA',
					'HEPB_A',
					'HEPB_C',
					'HEPB_CNCT',
					'HEPB_PERI',
					'HEPB_PG',
					'MEAS',
					'NMEN',
					'COV_MIS',
					'MUMPS',
					'PERT',
					'POLN',
					'POL',
					'RUB',
					'RUBCONG',
					'SPX',
					'PNE',
					'TET',
					'CPX')
		and a.QUESTION_ID not like 'DSETOCBYGHY%'
		and a.QUESTION_ID not like 'DSFBIFTYIIKI%'
		group by a.QUESTION_ID, c.MODEL_NAME, q.QUESTIONSET_ID
		order by a.QUESTION_ID;



-- Get number of cases
select count(c.UNID) as case_counts,
		c.MODEL_NAME
		--,p.NAME as disease_name
		from dbo.ids_case c join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		and p.code in ('AFP','DIP','DIPT','HFLU','HEPA',
					'HEPB_A',
					'HEPB_C',
					'HEPB_CNCT',
					'HEPB_PERI',
					'HEPB_PG',
					'MEAS',
					'NMEN',
					'COV_MIS',
					'MUMPS',
					'PERT',
					'POLN',
					'POL',
					'RUB',
					'RUBCONG',
					'SPX',
					'PNE',
					'TET',
					'CPX')
		group by c.MODEL_NAME

-- Combined queries

select x.MODEL_NAME as model_name,
		x.QUESTIONSET_ID as question_package,
		x.QUESTION_ID as field_name,
		x.max_value,
		x.count_of_values,
		y.case_counts
	from 
	( select c.model_name,
		q.QUESTIONSET_ID,
		a.QUESTION_ID,
		max(a.value) as max_value,
		count(a.value) as count_of_values
		--,STRING_AGG(cast(a.value as nvarchar(MAX)),',') 
		from
		 IDS_ANSWER a join IDS_QUESTIONSET q
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c
		on q.CASE_ID = c.UNID
		join IDS_PRODUCT p
		on c.PRODUCT_ID = p.UNID
		where p.code in ('AFP','DIP','DIPT','HFLU','HEPA',
						'HEPB_A',
						'HEPB_C',
						'HEPB_CNCT',
						'HEPB_PERI',
						'HEPB_PG',
						'MEAS',
						'NMEN',
						'COV_MIS',
						'MUMPS',
						'PERT',
						'POLN',
						'POL',
						'RUB',
						'RUBCONG',
						'SPX',
						'PNE',
						'TET',
						'CPX')
		and a.QUESTION_ID not like 'DSETOCBYGHY%'
		and a.QUESTION_ID not like 'DSFBIFTYIIKI%'
		and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
		group by a.QUESTION_ID, c.MODEL_NAME, q.QUESTIONSET_ID
		) x join
		(
			select count(c.UNID) as case_counts,
			c.MODEL_NAME
			--,p.NAME as disease_name
			from dbo.ids_case c join IDS_PRODUCT p
			on c.PRODUCT_ID = p.UNID
			where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
			and p.code in ('AFP','DIP','DIPT','HFLU','HEPA',
						'HEPB_A',
						'HEPB_C',
						'HEPB_CNCT',
						'HEPB_PERI',
						'HEPB_PG',
						'MEAS',
						'NMEN',
						'COV_MIS',
						'MUMPS',
						'PERT',
						'POLN',
						'POL',
						'RUB',
						'RUBCONG',
						'SPX',
						'PNE',
						'TET',
						'CPX')
			group by c.MODEL_NAME
		) y 
		on x.MODEL_NAME = y.MODEL_NAME
		order by x.QUESTION_ID;