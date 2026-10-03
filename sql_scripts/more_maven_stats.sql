-- Checking some adhoc stats and comparisons
select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where a.question_id like 'BIRTH_DATE'
	and convert(varchar,c.modification_date,23) >= '2026-01-01';

-- Is there any discrepancy between birthdates in Answer table and Party table?

select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id,
		par.birth_date
from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join ids_participant p
		on c.unid = p.case_id
		join ids_party par
		on p.party_id = par.unid
	where a.question_id like 'BIRTH_DATE'
	and convert(varchar,c.modification_date,23) >= '2026-01-01'
	and a.value != convert(varchar,par.birth_date,23);

-- Are Dengue questions different from chicken pox?
select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
	from 
		IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join ids_product p
		on c.product_id = p.unid
	where p.code like 'DNF' and 
	c.case_id like 'PHS33190679'

select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
	from 
		IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		join ids_product p
		on c.product_id = p.unid
	where p.code like 'CPX' 
	and c.case_id like 'PHS35290432'

	select * from ids_case where case_id like 'PHS35290432';

	--select * from ids_case c where c.model_name like '%general%' order by c.create_date desc;


-- Are questions from General model different from STD model?
-- Yes, some overlap and some distinct and question packages are different

	select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where c.case_id like '114235334'
	

	--select * from ids_case c where c.model_name like '%STD%' order by c.create_date desc;

	select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where c.case_id like '114318352'

-- Fields for STI
select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name,
		c.case_id
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where c.case_id like '112078244'

-- Find all questions found in STD model?
select a.question_id,
		max(a.value) as value,
		q.questionset_id
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where c.model_name like 'DiseaseSurveillanceModel_STD'
	group by a.question_id, q.questionset_id
	order by q.questionset_id,a.question_id

-- For Kat S
select a.question_id,
		a.value as value,
		q.questionset_id,
		c.case_id
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where a.question_id like 'CASE_CLOSED_REASON_HIDDEN%'

select a.question_id,
		a.value as value,
		a1.question_id,
		a1.value as closed_value,
		q.questionset_id,
		c.case_id
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
		left join ids_answer a1 
		on a1.questionset_id = q.unid
	where a.question_id like 'CASE_CLOSED_REASON_HIDDEN_DEFAULT'
	and a1.question_id like 'CASE_CLOSED_REASON_%'
	and a.question_id != a1.question_id
	

select a.question_id,
		a.value
	from IDS_ANSWER a join IDS_QUESTIONSET q 
		on a.QUESTIONSET_ID = q.UNID
		join IDS_CASE c 
		on q.CASE_ID = c.UNID
	where c.case_id like '101326016'
	order by a.question_id

select case_id from ids_case c
where len(case_id) >= 31

select max(case_id) from ids_case c where case_id not like '%TEST%' 


select a.question_id,
		a.value,
		q.questionset_id,
		c.model_name
	from IDS_ANSWER a
		join ids_questionset q
		on a.questionset_id = q.unid
		join ids_case c
		on q.case_id= c.unid
	where a.question_id like 'ADDRESS_TYPE%'
	group by a.question_id, a.value, q.questionset_id,c.model_name
	order by c.model_name;
	--and c.model_name like '%std%'

-- For STD
select * from IDS_CASE_DATA_PROPERTY
	where question like 'ADDRESS_TYPE'

select type from IDS_CONTACTPOINT group by type

select * from ids_enum_entry where enum_name like 'ContactPoint.Type';

-- Address type is 1 for this STD case indicating 'home'

select con.type from ids_case c join ids_participant p on p.case_id = c.unid
	join ids_party par on p.party_id = par.unid
	join ids_contactpoint con on con.party_id = par.unid
	where c.case_id like '112074017';