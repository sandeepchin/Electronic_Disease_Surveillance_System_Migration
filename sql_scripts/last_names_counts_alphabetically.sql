
-- Author: Sandeep Chintabathina
-- November 2025

-- Pull counts of lastnames alphabetically

-- First approach
/*
select sum(num_names) as total from
(
select count(*) as num_names,
		p.LAST_NAME as last_name

		from dbo.IDS_PARTY p
		where p.LAST_NAME like 'a%'
		group by p.LAST_NAME
	)	a
	;
*/

-- Group by starting letter of last name and count num of records
-- eventually order by starting letter
	select substring(p.LAST_NAME,1,1) as starting_letter,
		count(*) as count
	from dbo.IDS_PARTY p
	group by substring(p.LAST_NAME,1,1)
	order by starting_letter;
		

