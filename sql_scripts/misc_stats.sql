
-- Computing some stats for JLo

-- Num of questions by Model

select count(*) from
(	select c.MODEL_NAME,a.QUESTION_ID
	from
			IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.CASE_ID = c.UNID
	where c.MODEL_NAME like 'Childhood_Lead_Child_Model'
	group by c.MODEL_NAME,a.QUESTION_ID
) sub

-- Counts for all cases
select count(*) as num_of_questions, sub.model_name
	from
(
	select  a.QUESTION_ID,c.MODEL_NAME
		from
			IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.CASE_ID = c.UNID
		group by c.MODEL_NAME,a.QUESTION_ID
) sub
group by sub.MODEL_NAME;

-- Get all questions and answers by model to be processed later

select  max(a.value) as value
	,a.QUESTION_ID
	,max(q.questionset_id) as question_package
	,c.MODEL_NAME
		from
			IDS_ANSWER a join IDS_QUESTIONSET q
			on a.QUESTIONSET_ID = q.UNID
			join IDS_CASE c
			on q.CASE_ID = c.UNID
		--where convert(varchar,c.MODIFICATION_DATE,23) >= '2025-07-01' 
		group by c.MODEL_NAME,a.QUESTION_ID