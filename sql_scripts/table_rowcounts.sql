
-- Author: Sandeep Chintabathina
-- November 2025

-- Collecting stats about the database

-- Determine the row counts for each table in the database
select distinct t.name, s.row_count from  
	sys.tables t join sys.dm_db_partition_stats s
	on t.object_id = s.object_id 
	order by t.name;


-- Determine all column names with substring 'name' in it

SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME like '%name%';