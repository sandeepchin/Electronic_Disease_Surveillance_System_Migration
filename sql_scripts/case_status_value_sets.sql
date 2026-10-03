
--- Checking various value sets being used for status

-- A field with values -  Confirmed, Probable, Suspect
-- This is Disease status which maps to Custom2Code on Origami side and labeled as Case Status

-- A field with value - Data Collection Pending, Reviewed and Approved, Aborted

select * from IDS_ENUM_ENTRY t where t.NAME like 'Data Collection Pending';

select * from IDS_ENUM_ENTRY t where t.NAME like 'Reviewed and Approved';

select * from IDS_ENUM_ENTRY t where t.NAME like 'Aborted';

select * from IDS_ENUM_ENTRY t where ENUM_NAME like 'Case.Status';

select * from IDS_CASE where status not in (0,3,6) and convert(varchar,MODIFICATION_DATE,23) > '2026-01-01';

-- The field STATUS in Maven's Case table has three values  0 for 'Data Collection Pending'; 3 for 'Reviewed and Approved' ; 6 for 'Aborted'. So they need to be mapped correctly on Origami's side