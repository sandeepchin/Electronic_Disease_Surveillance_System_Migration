-- Not in MVP since disease type is Blood Lead - Adult
select * from ids_case where CASE_ID like '100896850';

-- Cases not found in EDSS
select * from ids_case where CASE_ID in ('112808045','112808098','112810740','112845178','112845309','112872655','112886542');

-- Not in MVP? Hepatitis C, perinatal infection - seeing cases related to this 
select * from ids_product p where p.unid like '503203641';

--Not in MVP? Haemophilus influenzae systemic - Seeing cases related to this - but this case 112845178 not found
select * from ids_product p where p.unid like '60669';

-- Blood Lead - Adult not seeing these cases
select * from ids_product p where p.unid like '444997983';

-- Reminder that not all cases from childhood lead child model were migrated
-- There is an additional layer of filtering based on product id or disease type 
-- Blood Lead adult are not being migrated right now.
select * from ids_case c where c.model_name like 'Childhood_Lead%' 
	and convert(varchar,c.modification_date,23) >= '2026-01-01'
	and c.product_id like '444997983';

select * from ids_case c where 
	convert(varchar,c.modification_date,23) >= '2026-01-01'
	and c.product_id like '503203641';

select * from ids_case c where 
	convert(varchar,c.modification_date,23) >= '2026-01-01'
	and c.product_id like '60669';

select p.name from ids_case c
	join ids_product p 
	on c.product_id = p.unid
	where c.case_id like '100896850';

-- 10 cases
select * from ids_case c where c.model_name like 'DiseaseSurveillanceModel_Coinfection';
-- 3 cases
select * from ids_case c where c.model_name like '%screening%';
-- 0 cases
select * from ids_case c where c.model_name like '%Adult_Lead%';

-- 1566 cases - last case 2021 Dec
select * from ids_case c where c.model_name like 'DiseaseSurveillanceModel_AggNETSS';

-- 27 cases - latest case 2018
select * from ids_case c where c.model_name like 'IsolationAndControlModel';

-- 361 rows latest one from July 2026
select * from ids_case c where c.model_name like 'PortalApplicationModel';

-- 4541 cases
select * from ids_case c where c.model_name like 'ClusterModel';

-- 0 cases
select * from ids_case c where c.model_name like 'EmployerModel';

select * from ids_case c where c.model_name like '%STD%' and convert(varchar,c.MODIFICATION_DATE,23) >= '2025-07-01';

select * from IDS_MODEL