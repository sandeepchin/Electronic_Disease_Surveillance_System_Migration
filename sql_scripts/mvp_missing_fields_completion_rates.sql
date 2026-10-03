/* Calculating field completion percentages */


select count(c.UNID) as case_counts,
		MODEL_NAME
from dbo.ids_case c
where c.MODIFICATION_DATE >=' 2025-07-01'
group by c.MODEL_NAME;


select count(a.value) as count_of_values
	,a.QUESTION_ID
	,c.MODEL_NAME
from dbo.ids_answer a join dbo.IDS_QUESTIONSET qs
on a.QUESTIONSET_ID = qs.unid
join dbo.IDS_CASE c on qs.CASE_ID = c.UNID
where a.question_id in 
('ADD_ALTERNATE_CONTACT'
,'AGE_DAYS'
,'AGE_MONTHS'
,'AGE_YEARS'
,'APGAR_ONE_MINUTE_SCORE_VALUE'
,'APGAR_SCORE'
,'APGAR_SCORE_FIVE_MINUTE_VALUE'
,'BIRTH_FACILITY'
,'BIRTH_FACILITY_ADDRESS1'
,'BIRTH_FACILITY_ADDRESS2'
,'BIRTH_FACILITY_CITY'
,'BIRTH_FACILITY_EXTENSION'
,'BIRTH_FACILITY_PHONE'
,'BIRTH_FACILITY_STATE'
,'BIRTH_FACILITY_ZIP'
,'BIRTH_LENGHT_CM'
,'BIRTH_LENGHT_IN'
,'BIRTH_LENGTH_UNITS'
,'BIRTH_SEQUENCE'
,'BIRTH_WEIGHT_GRAMS_CALC'
,'BIRTH_WEIGHT_LBS_CALC'
,'BIRTH_WEIGHT_OZ_CALC'
,'BRANCH_OF_SERVICE'
,'CHOOSE_ADDRESS_AT_REPORT_MSG'
,'CITY_FIPS'
,'COUNTRY_FIPS'
,'COUNTY_FIPS'
,'CURRENT_SYMPTOMS_MESSAGE'
,'DATE_LAST_COVID_VACCINE'
,'DIAGNOSIS_DATE'
,'EMPLOYER'
,'FIRST_FACILITY_CITY'
,'FIRST_FACILITY_COUNTRY'
,'FIRST_FACILITY_COUNTY'
,'FIRST_FACILITY_EMAIL'
,'FIRST_FACILITY_FAX'
,'FIRST_FACILITY_ISLAND'
,'FIRST_FACILITY_NAME_ADDRESS_MSG'
,'FIRST_FACILITY_STATE'
,'FIRST_FACILITY_STREET_ADDRESS_1'
,'FIRST_FACILITY_STREET_ADDRESS_2'
,'FIRST_FACILITY_TELEPHONE'
,'FIRST_FACILITY_TYPE'
,'FIRST_FACILITY_ZIP_CODE'
,'GC_DRUG_RESISTANCE'
,'GUARDIAN_TELEPHONE_CELL'
,'HAS_PREVIOUS_CONFIRMATORY_TEST'
,'HAZARD_PAINT_PLAY'
,'HAZARD_WATER_SOURCE'
,'HEALTHCARE_JOB_TITLE'
,'HEALTHCARE_WORK_SETTING'
,'HEALTHCARE_WORK_SITE_NAME'
,'HIGHEST_BLOOD_LEAD_LEVEL'
,'JOB_TYPE'
,'LAB_FACILITY_TYPE'
,'LAB_VALIDATION_NUMERIC_RESULT'
,'LATEST_CAPILLARY_LEAD_LEVEL'
,'LATEST_CAPILLARY_LEAD_LEVEL_DATE'
,'LINKED_MOTHER_MSG'
,'MORB_AGE'
,'MORB_CASE_DETECTION_METHOD'
,'MORB_OP_CONDITION'
,'MORB_OP_CSE_NUMBER'
,'MORB_OP_DIAGNOSIS_CODE'
,'MORB_OP_EVENT_ID'
,'MOTHER_AGE'
,'MOTHER_CHILDREN_LT_18_IMMUNIZED'
,'MOTHER_CHILDREN_LT_18_IMMUNIZED_NUMBER'
,'MOTHER_CHILDREN_LT_18_IN_HOUSEHOLD_DURING_PREGNANCY_TOTAL'
,'MOTHER_COUNTRY_OF_BIRTH'
,'MOTHER_FAMILY_PLANNING_PRIOR_CONCEPTION'
,'MOTHER_OCCUPATION_CONCEPTION'
,'MOTHER_US_ARRIVAL_DATE'
,'MOTHER_YEARS_IN_COUNTRY'
,'NAME_TYPE_OTHER_SPECIFY'
,'NEW_CASE'
,'NUMBER_OF_INDIVIDUALS_NONCONGREGATE'
,'NUMBER_OF_MULTIPLES'
,'OCCUPATION_PHONE'
,'OCCUPATION_TYPE'
,'OTHER_HEALTHCARE_JOB_TITLE'
,'OTHER_HEALTHCARE_WORK_SETTING'
,'PCN_SUSC'
,'PREVIOUS_CONFIRMATORY_RESULT_INTERPRETATION_CODE'
,'RACE'
,'REPORT_FACILITY'
,'REPORT_FACILITY_CITY'
,'REPORT_FACILITY_COUNTRY'
,'REPORT_FACILITY_FAX'
,'REPORT_FACILITY_FULL_NAME'
,'REPORT_FACILITY_ISLAND'
,'REPORT_FACILITY_NAME_ADDRESS_MSG'
,'REPORT_FACILITY_STATE'
,'REPORT_FACILITY_STREET_ADDRESS_1'
,'REPORT_FACILITY_STREET_ADDRESS_2'
,'REPORT_FACILITY_TELEPHONE'
,'REPORT_FACILITY_ZIP_CODE'
,'STATE_CODE'
,'STDMIS_AGE_AT_DX'
,'STDMIS_ID'
,'TELEPHONE_INTERNATIONAL'
,'TELEPHONE_OTHER'
,'UNREPORT_TO_CDC'
,'WORK_WITHIN_LAST_6_MONTHS'
,'WORKPLACE_TYPE')
and c.MODIFICATION_DATE >= '2025-07-01'
group by /*a.value,*/
a.QUESTION_ID,
c.MODEL_NAME
order by a.QUESTION_ID;



-- Merge the two queries above
select x.count_of_values
		,x.question_id
	    ,case 
		 when x.model_name like 'DiseaseSurveillanceModel_General' then 'General'
		 when x.model_name like 'DiseaseSurveillanceModel_STD' then 'STD'
		 when x.model_name like 'DiseaseSurveillanceModel_Hep' then 'Hepatitis'
		 when x.model_name like 'Childhood_Lead_Child_Model' then 'Lead'
		 else ''
		 end as model_name
		,y.case_counts as case_count
		,x.count_of_values*100.0/y.case_counts as fill_rate
	from
	(	select count(a.value) as count_of_values
			,a.QUESTION_ID as question_id
			,c.MODEL_NAME as model_name
		from dbo.ids_answer a join dbo.IDS_QUESTIONSET qs
		on a.QUESTIONSET_ID = qs.unid
		join dbo.IDS_CASE c on qs.CASE_ID = c.UNID
		where a.question_id in 
		('ADD_ALTERNATE_CONTACT'
		,'AGE_DAYS'
		,'AGE_MONTHS'
		,'AGE_YEARS'
		,'APGAR_ONE_MINUTE_SCORE_VALUE'
		,'APGAR_SCORE'
		,'APGAR_SCORE_FIVE_MINUTE_VALUE'
		,'BIRTH_FACILITY'
		,'BIRTH_FACILITY_ADDRESS1'
		,'BIRTH_FACILITY_ADDRESS2'
		,'BIRTH_FACILITY_CITY'
		,'BIRTH_FACILITY_EXTENSION'
		,'BIRTH_FACILITY_PHONE'
		,'BIRTH_FACILITY_STATE'
		,'BIRTH_FACILITY_ZIP'
		,'BIRTH_LENGHT_CM'
		,'BIRTH_LENGHT_IN'
		,'BIRTH_LENGTH_UNITS'
		,'BIRTH_SEQUENCE_BABY_B'
		,'BIRTH_WEIGHT_GRAMS_CALC'
		,'BIRTH_WEIGHT_LBS_CALC'
		,'BIRTH_WEIGHT_OZ_CALC'
		,'BRANCH_OF_SERVICE'
		,'CHOOSE_ADDRESS_AT_REPORT_MSG'
		,'CITY_FIPS'
		,'COUNTRY_FIPS'
		,'COUNTY_FIPS'
		,'CURRENT_SYMPTOMS_MESSAGE'
		,'DATE_LAST_COVID_VACCINE'
		,'DIAGNOSIS_DATE'
		,'EMPLOYER'
		,'FIRST_FACILITY_CITY'
		,'FIRST_FACILITY_COUNTRY'
		,'FIRST_FACILITY_COUNTY'
		,'FIRST_FACILITY_EMAIL'
		,'FIRST_FACILITY_FAX'
		,'FIRST_FACILITY_ISLAND'
		,'FIRST_FACILITY_NAME_ADDRESS_MSG'
		,'FIRST_FACILITY_STATE'
		,'FIRST_FACILITY_STREET_ADDRESS_1'
		,'FIRST_FACILITY_STREET_ADDRESS_2'
		,'FIRST_FACILITY_TELEPHONE'
		,'FIRST_FACILITY_TYPE'
		,'FIRST_FACILITY_ZIP_CODE'
		,'GC_DRUG_RESISTANCE'
		,'GUARDIAN_TELEPHONE_CELL'
		,'HAS_PREVIOUS_CONFIRMATORY_TEST'
		,'HAZARD_PAINT_PLAY'
		,'HAZARD_WATER_SOURCE'
		,'HEALTHCARE_JOB_TITLE'
		,'HEALTHCARE_WORK_SETTING'
		,'HEALTHCARE_WORK_SITE_NAME'
		,'HIGHEST_BLOOD_LEAD_LEVEL'
		,'JOB_TYPE'
		,'LAB_FACILITY_TYPE'
		,'LAB_VALIDATION_NUMERIC_RESULT'
		,'LATEST_CAPILLARY_LEAD_LEVEL'
		,'LATEST_CAPILLARY_LEAD_LEVEL_DATE'
		,'LINKED_MOTHER_MSG'
		,'MORB_AGE'
		,'MORB_CASE_DETECTION_METHOD'
		,'MORB_OP_CONDITION'
		,'MORB_OP_CSE_NUMBER'
		,'MORB_OP_DIAGNOSIS_CODE'
		,'MORB_OP_EVENT_ID'
		,'MOTHER_AGE'
		,'MOTHER_CHILDREN_LT_18_IMMUNIZED'
		,'MOTHER_CHILDREN_LT_18_IMMUNIZED_NUMBER'
		,'MOTHER_CHILDREN_LT_18_IN_HOUSEHOLD_DURING_PREGNANCY_TOTAL'
		,'MOTHER_COUNTRY_OF_BIRTH'
		,'MOTHER_FAMILY_PLANNING_PRIOR_CONCEPTION'
		,'MOTHER_OCCUPATION_CONCEPTION'
		,'MOTHER_US_ARRIVAL_DATE'
		,'MOTHER_YEARS_IN_COUNTRY'
		,'NAME_TYPE_OTHER_SPECIFY'
		,'NEW_CASE'
		,'NUMBER_OF_INDIVIDUALS_NONCONGREGATE'
		,'NUMBER_OF_MULTIPLES'
		,'OCCUPATION_PHONE'
		,'OCCUPATION_TYPE'
		,'OTHER_HEALTHCARE_JOB_TITLE'
		,'OTHER_HEALTHCARE_WORK_SETTING'
		,'PCN_SUSC'
		,'PREVIOUS_CONFIRMATORY_RESULT_INTERPRETATION_CODE'
		,'RACE'
		,'REPORT_FACILITY'
		,'REPORT_FACILITY_CITY'
		,'REPORT_FACILITY_COUNTRY'
		,'REPORT_FACILITY_FAX'
		,'REPORT_FACILITY_FULL_NAME'
		,'REPORT_FACILITY_ISLAND'
		,'REPORT_FACILITY_NAME_ADDRESS_MSG'
		,'REPORT_FACILITY_STATE'
		,'REPORT_FACILITY_STREET_ADDRESS_1'
		,'REPORT_FACILITY_STREET_ADDRESS_2'
		,'REPORT_FACILITY_TELEPHONE'
		,'REPORT_FACILITY_ZIP_CODE'
		,'STATE_CODE'
		,'STDMIS_AGE_AT_DX'
		,'STDMIS_ID'
		,'TELEPHONE_INTERNATIONAL'
		,'TELEPHONE_OTHER'
		,'UNREPORT_TO_CDC'
		,'WORK_WITHIN_LAST_6_MONTHS'
		,'WORKPLACE_TYPE')
		and c.MODIFICATION_DATE >= '2025-07-01'
		group by /*a.value,*/
		a.QUESTION_ID,
		c.MODEL_NAME
	) x join
	(select count(c.UNID) as case_counts,
		MODEL_NAME
		from dbo.ids_case c
		where c.MODIFICATION_DATE >=' 2025-07-01'
		group by c.MODEL_NAME) y
on x.model_name = y.MODEL_NAME
order by x.question_id;


select * from dbo.IDS_ANSWER where QUESTION_ID like 'BIRTH_LENGTH%';

-- Adjusting above query to be able to find all child questions since the parent questions are truncated

select x.count_of_values
		,x.question_id
	    ,case 
		 when x.model_name like 'DiseaseSurveillanceModel_General' then 'General'
		 when x.model_name like 'DiseaseSurveillanceModel_STD' then 'STD'
		 when x.model_name like 'DiseaseSurveillanceModel_Hep' then 'Hepatitis'
		 when x.model_name like 'Childhood_Lead_Child_Model' then 'Lead'
		 else ''
		 end as model_name
		,y.case_counts as case_count
		,x.count_of_values*100.0/y.case_counts as fill_rate
	from
	(	select count(a.value) as count_of_values
			,a.QUESTION_ID as question_id
			,c.MODEL_NAME as model_name
		from dbo.ids_answer a join dbo.IDS_QUESTIONSET qs
		on a.QUESTIONSET_ID = qs.unid
		join dbo.IDS_CASE c on qs.CASE_ID = c.UNID
		where 
		(a.question_id like 'ADD_ALTERNATE_CONTACT%' or
		a.question_id like 'AGE_DAYS%' or
		a.question_id like 'AGE_MONTHS%' or
		a.question_id like 'AGE_YEARS%' or
		a.question_id like 'APGAR_ONE_MINUTE_SCORE_VALUE%' or
		a.question_id like 'APGAR_SCORE%' or
		a.question_id like 'APGAR_SCORE_FIVE_MINUTE_VALUE%' or
		a.question_id like 'BIRTH_FACILITY%' or
		a.question_id like 'BIRTH_FACILITY_ADDRESS1%' or
		a.question_id like 'BIRTH_FACILITY_ADDRESS2%' or
		a.question_id like 'BIRTH_FACILITY_CITY%' or
		a.question_id like 'BIRTH_FACILITY_EXTENSION%' or
		a.question_id like 'BIRTH_FACILITY_PHONE%' or
		a.question_id like 'BIRTH_FACILITY_STATE%' or
		a.question_id like 'BIRTH_FACILITY_ZIP%' or
		a.question_id like 'BIRTH_LENGHT_CM%' or
		a.question_id like 'BIRTH_LENGHT_IN%' or
		a.question_id like 'BIRTH_LENGTH_UNITS%' or
		a.question_id like 'BIRTH_SEQUENCE%' or
		a.question_id like 'BIRTH_WEIGHT_GRAMS_CALC%' or
		a.question_id like 'BIRTH_WEIGHT_LBS_CALC%' or
		a.question_id like 'BIRTH_WEIGHT_OZ_CALC%' or
		a.question_id like 'BRANCH_OF_SERVICE%' or
		a.question_id like 'CHOOSE_ADDRESS_AT_REPORT_MSG%' or
		a.question_id like 'CITY_FIPS%' or
		a.question_id like 'COUNTRY_FIPS%' or
		a.question_id like 'COUNTY_FIPS%' or
		a.question_id like 'CURRENT_SYMPTOMS_MESSAGE%' or
		a.question_id like 'DATE_LAST_COVID_VACCINE%' or
		a.question_id like 'DIAGNOSIS_DATE%' or
		a.question_id like 'EMPLOYER%' or
		a.question_id like 'FIRST_FACILITY_CITY%' or
		a.question_id like 'FIRST_FACILITY_COUNTRY%' or
		a.question_id like 'FIRST_FACILITY_COUNTY%' or
		a.question_id like 'FIRST_FACILITY_EMAIL%' or
		a.question_id like 'FIRST_FACILITY_FAX%' or
		a.question_id like 'FIRST_FACILITY_ISLAND%' or
		a.question_id like 'FIRST_FACILITY_NAME_ADDRESS_MSG%' or
		a.question_id like 'FIRST_FACILITY_STATE%' or
		a.question_id like 'FIRST_FACILITY_STREET_ADDRESS_1%' or
		a.question_id like 'FIRST_FACILITY_STREET_ADDRESS_2%' or
		a.question_id like 'FIRST_FACILITY_TELEPHONE%' or
		a.question_id like 'FIRST_FACILITY_TYPE%' or
		a.question_id like 'FIRST_FACILITY_ZIP_CODE%' or
		a.question_id like 'GC_DRUG_RESISTANCE%' or
		a.question_id like 'GUARDIAN_TELEPHONE_CELL%' or
		a.question_id like 'HAS_PREVIOUS_CONFIRMATORY_TEST%' or
		a.question_id like 'HAZARD_PAINT_PLAY%' or
		a.question_id like 'HAZARD_WATER_SOURCE%' or
		a.question_id like 'HEALTHCARE_JOB_TITLE%' or
		a.question_id like 'HEALTHCARE_WORK_SETTING%' or
		a.question_id like 'HEALTHCARE_WORK_SITE_NAME%' or
		a.question_id like 'HIGHEST_BLOOD_LEAD_LEVEL%' or
		a.question_id like 'JOB_TYPE%' or
		a.question_id like 'LAB_FACILITY_TYPE%' or
		a.question_id like 'LAB_VALIDATION_NUMERIC_RESULT%' or
		a.question_id like 'LATEST_CAPILLARY_LEAD_LEVEL%' or
		a.question_id like 'LATEST_CAPILLARY_LEAD_LEVEL_DATE%' or
		a.question_id like 'LINKED_MOTHER_MSG%' or
		a.question_id like 'MORB_AGE%' or
		a.question_id like 'MORB_CASE_DETECTION_METHOD%' or
		a.question_id like 'MORB_OP_CONDITION%' or
		a.question_id like 'MORB_OP_CSE_NUMBER%' or
		a.question_id like 'MORB_OP_DIAGNOSIS_CODE%' or
		a.question_id like 'MORB_OP_EVENT_ID%' or
		a.question_id like 'MOTHER_AGE%' or
		a.question_id like 'MOTHER_CHILDREN_LT_18_IMMUNIZED%' or
		a.question_id like 'MOTHER_CHILDREN_LT_18_IMMUNIZED_NUMBER%' or
		a.question_id like 'MOTHER_CHILDREN_LT_18_IN_HOUSEHOLD_DURING_PREGNANCY_TOTAL%' or
		a.question_id like 'MOTHER_COUNTRY_OF_BIRTH%' or
		a.question_id like 'MOTHER_FAMILY_PLANNING_PRIOR_CONCEPTION%' or
		a.question_id like 'MOTHER_OCCUPATION_CONCEPTION%' or
		a.question_id like 'MOTHER_US_ARRIVAL_DATE%' or
		a.question_id like 'MOTHER_YEARS_IN_COUNTRY%' or
		a.question_id like 'NAME_TYPE_OTHER_SPECIFY%' or
		a.question_id like 'NEW_CASE%' or
		a.question_id like 'NUMBER_OF_INDIVIDUALS_NONCONGREGATE%' or
		a.question_id like 'NUMBER_OF_MULTIPLES%' or
		a.question_id like 'OCCUPATION_PHONE%' or
		a.question_id like 'OCCUPATION_TYPE%' or
		a.question_id like 'OTHER_HEALTHCARE_JOB_TITLE%' or
		a.question_id like 'OTHER_HEALTHCARE_WORK_SETTING%' or
		a.question_id like 'PCN_SUSC%' or
		a.question_id like 'PREVIOUS_CONFIRMATORY_RESULT_INTERPRETATION_CODE%' or
		a.question_id like 'RACE%' or
		a.question_id like 'REPORT_FACILITY%' or
		a.question_id like 'REPORT_FACILITY_CITY%' or
		a.question_id like 'REPORT_FACILITY_COUNTRY%' or
		a.question_id like 'REPORT_FACILITY_FAX%' or
		a.question_id like 'REPORT_FACILITY_FULL_NAME%' or
		a.question_id like 'REPORT_FACILITY_ISLAND%' or
		a.question_id like 'REPORT_FACILITY_NAME_ADDRESS_MSG%' or
		a.question_id like 'REPORT_FACILITY_STATE%' or
		a.question_id like 'REPORT_FACILITY_STREET_ADDRESS_1%' or
		a.question_id like 'REPORT_FACILITY_STREET_ADDRESS_2%' or
		a.question_id like 'REPORT_FACILITY_TELEPHONE%' or
		a.question_id like 'REPORT_FACILITY_ZIP_CODE%' or
		a.question_id like 'STATE_CODE%' or
		a.question_id like 'STDMIS_AGE_AT_DX%' or
		a.question_id like 'STDMIS_ID%' or
		a.question_id like 'TELEPHONE_INTERNATIONAL%' or
		a.question_id like 'TELEPHONE_OTHER%' or
		a.question_id like 'UNREPORT_TO_CDC%' or
		a.question_id like 'WORK_WITHIN_LAST_6_MONTHS%' or
		a.question_id like 'WORKPLACE_TYPE%')
		and c.MODIFICATION_DATE >= '2025-07-01'
		group by /*a.value,*/
		a.QUESTION_ID,
		c.MODEL_NAME
	) x join
	(select count(c.UNID) as case_counts,
		MODEL_NAME
		from dbo.ids_case c
		where c.MODIFICATION_DATE >=' 2025-07-01'
		group by c.MODEL_NAME) y
on x.model_name = y.MODEL_NAME
order by x.question_id;



-- Checking out values for age_months, age_days, age_years
-- at request of Inductive

select a.value as value
			,a.QUESTION_ID as question_id
			,c.MODEL_NAME as model_name
			,max(c.CASE_ID) as case_id
		from dbo.ids_answer a join dbo.IDS_QUESTIONSET qs
		on a.QUESTIONSET_ID = qs.unid
		join dbo.IDS_CASE c on qs.CASE_ID = c.UNID
		where 
		(
		a.question_id like 'AGE_DAYS%' or
		a.question_id like 'AGE_MONTHS%' or
		a.question_id like 'AGE_YEARS%' )
		group by a.QUESTION_ID,a.VALUE,c.MODEL_NAME
		order by cast(a.value as integer)


-- Adhoc request to find fill rates for 61 elements
select x.count_of_values
		,x.value
		,x.question_id
	    ,case 
		 when x.model_name like 'DiseaseSurveillanceModel_General' then 'General'
		 when x.model_name like 'DiseaseSurveillanceModel_STD' then 'STD'
		 when x.model_name like 'DiseaseSurveillanceModel_Hep' then 'Hepatitis'
		 when x.model_name like 'Childhood_Lead_Child_Model' then 'Childhood Lead'
		 when x.model_name like 'DiseaseSurveillanceModel_Coinfection' then 'Coinfection'
		 when x.model_name like 'ClusterModel' then 'Cluster'
		 else ''
		 end as model_name
		,y.case_counts as case_count
		,x.count_of_values*100.0/y.case_counts as fill_rate
	from
	(	select count(a.value) as count_of_values
			,a.QUESTION_ID as question_id
			,c.MODEL_NAME as model_name
			,max(a.value) as value
		from dbo.ids_answer a join dbo.IDS_QUESTIONSET qs
		on a.QUESTIONSET_ID = qs.unid
		join dbo.IDS_CASE c on qs.CASE_ID = c.UNID
		where (
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'BIRTH_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'BIRTH_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'BIRTH_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'CASE_INVESTIGATION_STATUS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'CASE_INVESTIGATION_STATUS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'SYMPTOMS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'SYMPTOMS_CLINICIAN_OBS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'SYMPTOMS_CLINICIAN_OBS_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'SYMPTOMS_PATIENT_DESCRIBED%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'SYMPTOMS_PATIENT_DESCRIBED_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Coinfection' and a.QUESTION_ID like 'CONTACT_TRAVEL_PURPOSE_1%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'CONTACT_TRAVEL_PURPOSE_1%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'COUNTY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'COUNTY%') or
(c.MODEL_NAME like 'Childhood_Lead_Child_Model' and a.QUESTION_ID like 'COUNTY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'COUNTY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'COVID_CONTACT_SURVEY_LIST_OF_OTHER_SYMPTOMS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'COVID_CONTACT_SURVEY_OTHER_SYMPTOMS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'CURRENT_GENDER_IDENTITY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DAILY_MONITORING_CONTACT_SURVEY_LIST_OTHER_SYMPTOMS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DAILY_MONITORING_CONTACT_SURVEY_OTHER_SYMPTOMS%') or
(c.MODEL_NAME like 'Childhood_Lead_Child_Model' and a.QUESTION_ID like 'DECEASED%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DOMESTIC_TRAVEL_OUTSIDE_HI%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DOMESTIC_TRAVEL_OUTSIDE_HI_ARRIVAL_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DOMESTIC_TRAVEL_OUTSIDE_HI_DEPARTURE_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DOMESTIC_TRAVEL_OUTSIDE_HI_STATES%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'EMPLOYMENT_STATUS%') or
(c.MODEL_NAME like 'ClusterModel' and a.QUESTION_ID like 'EXPOSURE_COUNTY%') or
(c.MODEL_NAME like 'ClusterModel' and a.QUESTION_ID like 'EXPOSURE_STATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'HOSPITAL_ADMISSION_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'HOSPITAL_ADMISSION_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'HOSPITAL_DISCHARGE_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'HOSPITAL_DISCHARGE_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INDUSTRY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INTERNATIONAL_TRAVEL%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INTERNATIONAL_TRAVEL_COUNTRY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INTERNATIONAL_TRAVEL_DEPARTURE_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INTERNATIONAL_TRAVEL_FINAL_RETURN_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INVESTIGATION_START_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'INVESTIGATION_START_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'LABORATORY_SPECIMEN_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'LABORATORY_SPECIMEN_SOURCE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'LABORATORY_TEST_RESULT%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'LANGUAGE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'MMWR_WEEK%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'MMWR_WEEK%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'MMWR_WEEK%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'NUMBER_DOSES_BEFORE_ILLNESS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'OCCUPATION%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'PREP_MEDICATION%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'RACE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'RACE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'RACE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'RACE_OTHER_SPECIFY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'RACE_OTHER_SPECIFY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'RACE_OTHER_SPECIFY%') or
(c.MODEL_NAME like 'Childhood_Lead_Child_Model' and a.QUESTION_ID like 'RACE_OTHER_SPECIFY%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'REPORT_DATE%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'REPORT_TO_CDC%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'REPORT_TO_CDC%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'REPORT_TO_CDC%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'INVESTIGATION_STATUS') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'INVESTIGATION_STATUS') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'INVESTIGATION_STATUS') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_General' and a.QUESTION_ID like 'DISEASE_STATUS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_Hep' and a.QUESTION_ID like 'DISEASE_STATUS%') or
(c.MODEL_NAME like 'DiseaseSurveillanceModel_STD' and a.QUESTION_ID like 'DISEASE_STATUS%')
)and convert(varchar,c.MODIFICATION_DATE,23) >= '2026-01-01'
		group by /*a.value,*/
		a.QUESTION_ID,
		c.MODEL_NAME
	) x join
	(select count(c.UNID) as case_counts,
		MODEL_NAME
		from dbo.ids_case c
		where convert(varchar,c.MODIFICATION_DATE,23) >='2026-01-01'
		group by c.MODEL_NAME) y
on x.model_name = y.MODEL_NAME
order by x.question_id;