
-- Query to retrieve provider or organization list

select * from dbo.IDS_ORGANIZATION;

select * from dbo.IDS_ORG_RELATIONSHIP;

select * from dbo.IDS_AUDIT_EVENT;

-- Source - https://stackoverflow.com/a/61798420
-- Posted by sbrbot, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-07-14, License - CC BY-SA 4.0

DECLARE @search VARCHAR(100), @table SYSNAME, @column SYSNAME

DECLARE curTabCol CURSOR FOR
    SELECT c.TABLE_SCHEMA + '.' + c.TABLE_NAME, c.COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS c
    JOIN INFORMATION_SCHEMA.TABLES t 
      ON t.TABLE_NAME=c.TABLE_NAME AND t.TABLE_TYPE='BASE TABLE' -- avoid views
    WHERE c.DATA_TYPE IN ('varchar','nvarchar') -- searching only in these column types
    --AND c.COLUMN_NAME IN ('NAME','DESCRIPTION') -- searching only in these column names

SET @search='LOINC'

OPEN curTabCol
FETCH NEXT FROM curTabCol INTO @table, @column

WHILE (@@FETCH_STATUS = 0)
BEGIN
    EXECUTE('IF EXISTS 
             (SELECT * FROM ' + @table + ' WHERE ' + @column + ' = ''' + @search + ''') 
             PRINT ''' + @table + '.' + @column + '''')
    FETCH NEXT FROM curTabCol INTO @table, @column
END

CLOSE curTabCol
DEALLOCATE curTabCol

-- Above query indicated IDS_ANSWER table might contain facility info

select a.value as facility_name
	--,a.question_id
	,st1.value as facility_street_addr_1
	,max(st2.value) as facility_street_addr_2
	,c.value as facility_city
	,s.value as facility_state
	,z.value as facility_zip
 from dbo.IDS_ANSWER a left outer join dbo.IDS_ANSWER z 
 on a.QUESTIONSET_ID = z.QUESTIONSET_ID
 left outer join dbo.IDS_ANSWER s 
 on a.QUESTIONSET_ID = s.QUESTIONSET_ID
 left outer join dbo.IDS_ANSWER c
 on a.QUESTIONSET_ID = c.QUESTIONSET_ID
 left outer join dbo.IDS_ANSWER st1
 on a.QUESTIONSET_ID = st1.QUESTIONSET_ID
 left join dbo.IDS_ANSWER st2
 on a.QUESTIONSET_ID = st2.QUESTIONSET_ID
where a.question_id like 'FIRST_FACILITY_FULL_NAME'
and z.question_id like 'FIRST_FACILITY_ZIP_CODE'
and s.QUESTION_ID like 'FIRST_FACILITY_STATE'
and c.QUESTION_ID like 'FIRST_FACILITY_CITY'
and st1.QUESTION_ID like 'FIRST_FACILITY_STREET_ADDRESS_1'
and st2.QUESTION_ID like 'FIRST_FACILITY_STREET_ADDRESS_2'
--and a.value like '%Kaiser%'
group by a.value,st1.value,c.value,s.value,z.value
order by a.value
--,a.question_id


-- Just the facility names
select a.value as facility_name
	--,a.question_id
 from dbo.IDS_ANSWER a 
 where a.question_id like '%FACILITY_FULL_NAME'
 group by a.value
 order by a.value


 -- This did not work
select * from dbo.IDS_ANSWER a
where a.question_id like '%FACILITY_NAME%';


select * from IDS_ANSWER a
where a.QUESTION_ID like '%INVESTIGATOR';

select name from IDS_ROSTER_MAPPING order by name;

select a.QUESTION_ID,q.QUESTIONSET_ID from IDS_ANSWER a join IDS_QUESTIONSET q
on a.QUESTIONSET_ID = q.UNID 
where a.QUESTION_ID like 'SYMPTOM%'
group by a.QUESTION_ID, q.QUESTIONSET_ID;
--order by a.QUESTION_ID;