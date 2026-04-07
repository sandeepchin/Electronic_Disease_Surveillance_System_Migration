
-- Author: Sandeep Chintabathina
-- January 2026

-- Query to check addresses associated with parties in Maven

select count(*) 
	from dbo.IDS_CONTACTPOINT c join dbo.IDS_PARTY p
	on c.PARTY_ID = p.UNID;
	


select count(*) 
	from  dbo.IDS_PARTY p left join dbo.IDS_CONTACTPOINT c
	on c.PARTY_ID = p.UNID
	where p.LAST_NAME like 'A%';



select p.unid as unique_id,
		p.LAST_NAME as last_name,
		p.first_name as first_name,
		format(p.birth_date,'yyyy-MM-dd') as dob,
		trim(concat(trim(c.street1),' ',trim(c.street2))) as street_address,
		c.CITY as city,
		c.county as county,
		c.state as state,
		c.POSTAL_CODE as zip
	from dbo.IDS_CONTACTPOINT c join dbo.IDS_PARTY p
	on c.PARTY_ID = p.UNID
	where p.LAST_NAME like 'A%'
	order by p.last_name;


-- Same query as above but with fields that have have enumerated data type
-- Example - gender which could be male, female, transgender etc

select p.unid as party_id,
		p.LAST_NAME as last_name,
		p.first_name as first_name,
		format(p.birth_date,'yyyy-MM-dd') as dob,
		trim(concat(trim(c.street1),' ',trim(c.street2))) as street_address,
		c.CITY as city,
		c.county as county,
		c.state as state,
		c.POSTAL_CODE as zip,
		c.country as country,
		-- Get data from ids_enum_entry 
		e.name as party_category,
		e1.name as party_type,
		e2.name as party_status,
		e3.name as living_status,
		e4.name as gender,
		p.deidentified as deidentified,  --boolean not enumerated
		e5.name as reference_category,
		e6.name as contact_point_type,
		c.primary_address as primary_address,  --boolean
		e7.name as address_status,
		e8.name as residence_type,
		e9.name as validation_status,
		e10.name as geocode_status
		--c.source_system as source_system  -- does not exist

	from 
		dbo.IDS_CONTACTPOINT c join dbo.IDS_PARTY p on c.PARTY_ID = p.UNID
		left join dbo.ids_enum_entry e on p.category = e.value and e.enum_name='Party.Category'
		left join dbo.ids_enum_entry e1 on p.type=e1.value and e1.enum_name='Party.Type'
		left join dbo.ids_enum_entry e2 on p.status=e2.value and e2.enum_name='Party.Status'
		left join dbo.ids_enum_entry e3 on p.living_status=e3.value and e3.enum_name='Person.LivingStatus'
		left join dbo.ids_enum_entry e4 on p.gender=e4.value and e4.enum_name='Person.Gender'
		left join dbo.ids_enum_entry e5 on p.reference_category=e5.value and e5.enum_name='Party.ReferenceCategory'
		left join dbo.ids_enum_entry e6 on c.type=e6.value and e6.enum_name='ContactPoint.Type'
		left join dbo.ids_enum_entry e7 on c.address_status=e7.value and e7.enum_name='Address.Status'
		left join dbo.ids_enum_entry e8 on c.residence_type=e8.value and e8.enum_name='Residence.Type'
		left join dbo.ids_enum_entry e9 on c.validation_status=e9.value and e9.enum_name='Callout.Status'
		left join dbo.ids_enum_entry e10 on c.geocode_status=e10.value and e10.enum_name='Callout.Status'

	where p.LAST_NAME like 'A%'
	--and( p.LAST_NAME is null or p.last_name='') 
	--and (p.first_name is null or p.first_name ='')
	--and (p.birth_date is null or p.birth_date='')
	--and (c.postal_code is null or c.postal_code in ('','nullFlavor_UNK','nullFlavor_NI'))
	--and ((c.street1 is null or c.street1 = '') and (c.street2 is null or c.street2 =''))
	order by p.last_name;