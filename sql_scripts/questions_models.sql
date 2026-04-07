
-- Author: Sandeep Chintabathina
-- March 2026

/* Query to list all questions and answers along with model name*/
/* WARNING: Takes over 42 mintutes to execute and another 42 mins to download  - 31,589,577 rows */
 
select a.QUESTION_ID,  -- Question text with answer appended sometimes
		a.value,       -- The answer for the question
		q.QUESTIONSET_ID,  -- the category of the question
		--c.CASE_ID,
		c.MODEL_NAME     -- the model to which the question belongs
	from 
		dbo.IDS_ANSWER a join dbo.ids_questionset q
		on a.QUESTIONSET_ID=q.UNID
		join dbo.ids_case c on q.CASE_ID = c.UNID
	--where c.model_name like 'Childhood_Lead_Child_Model'
	--where a.question_ID like '%AUTOIMMUNE_DISORDER%'
	group by a.QUESTION_ID,
	a.value,
	q.QUESTIONSET_ID,
	--c.CASE_ID,
	c.MODEL_NAME
	order by c.model_name;


/* Identify over all question-answers for all case */
/* Warning takes over 20 minutes and gives 517,747,541 as count */

--select count(*) from (
select a.QUESTION_ID,  -- Question text with answer appended sometimes
		a.value,       -- The answer for the question
		--q.QUESTIONSET_ID,  -- the category of the question
		c.CASE_ID
		--c.MODEL_NAME     -- the model to which the question belongs
	from 
		dbo.IDS_ANSWER a join dbo.ids_questionset q
		on a.QUESTIONSET_ID=q.UNID
		join dbo.ids_case c on q.CASE_ID = c.UNID
	where c.MODEL_NAME in ('Childhood_Lead_Investigation_Model')
	group by a.QUESTION_ID,
	a.value,
	--q.QUESTIONSET_ID,
	c.CASE_ID
	--c.MODEL_NAME
	--order by c.model_name
--) a	
;

/* All models - number of rows
DiseaseSurveillanceModel_General        23347256
DiseaseSurveillanceModel_STD             4044742
DiseaseSurveillanceModel_Hep             3831346
Childhood_Lead_Child_Model                346595
ClusterModel                               14386
PortalApplicationModel                      2535
DiseaseSurveillanceModel_AggNETSS           1747
Childhood_Lead_Investigation_Model           687
DiseaseSurveillanceModel_Coinfection         145
IsolationAndControlModel                     103
EHRAndScreeningModel_STD                      35
*/