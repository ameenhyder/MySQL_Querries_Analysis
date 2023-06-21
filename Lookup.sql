Drop temporary table if exists tempdb.genericlookupstatus;
Create temporary table tempdb.genericlookupstatus
Select 
		substring_index(substring_index(GenericLookupStatus, '|', 1), ',', 1) LookUp_In,
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 1), ',', 2),',',-1) LookUp_On,
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 1), ',', 3),',',-1) Result,
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 1), ',', 4),',',-1) `Time`,
        
		substring_index(substring_index(substring_index(GenericLookupStatus, '|', 2), '|', -1), ',',1) LookUp_In2,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 2), '|', -1), ',',2), ',',-1) LookUp_On2,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 2), '|', -1), ',',3), ',',-1) Result2,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 2), '|', -1), ',',4), ',',-1) `Time2`,
        
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 3), '|', -1), ',',1) LookUp_In3,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 3), '|', -1), ',',2), ',',-1) LookUp_On3,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 3), '|', -1), ',',3), ',',-1) Result3,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 3), '|', -1), ',',4), ',',-1) `Time3`,
        
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 4), '|', -1), ',',1) LookUp_In4,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 4), '|', -1), ',',2), ',',-1) LookUp_On4,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 4), '|', -1), ',',3), ',',-1) Result4,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 4), '|', -1), ',',4), ',',-1) `Time4`,
        
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 5), '|', -1), ',',1) LookUp_In5,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 5), '|', -1), ',',2), ',',-1) LookUp_On5,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 5), '|', -1), ',',3), ',',-1) Result5,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 5), '|', -1), ',',4), ',',-1) `Time5`,
        
        substring_index(substring_index(substring_index(GenericLookupStatus, '|', 6), '|', -1), ',',1) LookUp_In6,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 6), '|', -1), ',',2), ',',-1) LookUp_On6,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 6), '|', -1), ',',3), ',',-1) Result6,
        substring_index(substring_index(substring_index(substring_index(GenericLookupStatus, '|', 6), '|', -1), ',',4), ',',-1) `Time6`        

From `engine.eclext`
Where calltime >= '2018-10-25 06:49:14.518' and calltime < '2018-10-25 06:59:14.518' and (EngineID = 'AtentoTFN_M_R_Avaya' or EngineID = 'AtentoTFN_Fix_Avaya');# and GenericLookupStatus is not null;

Select * From tempdb.genericlookupstatus;
Select ProgramID From `engine.ecl` Where calltime >= '2018-10-25 06:49:14.518' and calltime < '2018-10-25 06:59:14.518' and (programID = 'Atentotfn_mobile' or programID = 'Atentotfn_fix');
Select LookUp_In, sum(case when Result = 'False' then 1 else 0 end)/count(*) * 100,
		LookUp_In2, sum(case when Result2 = 'False' then 1 else 0 end)/count(*) * 100,
        LookUp_In3, sum(case when Result3 = 'False' then 1 else 0 end)/count(*) * 100,
        LookUp_In4, sum(case when Result4 = 'False' then 1 else 0 end)/count(*) * 100,
        LookUp_In5, sum(case when Result5 = 'False' then 1 else 0 end)/count(*) * 100,
        LookUp_In6, sum(case when Result6 = 'False' then 1 else 0 end)/count(*) * 100
From tempdb.genericlookupstatus;