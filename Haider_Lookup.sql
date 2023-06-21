set @changetime = '2018-11-28';
set @variable1 = 'city:';
set @variable2 = 'region:';
select engineid
, skill
, error
, ErrorReason
, calltime
, callgroup
, CP_Actual
, substr(lookupdata, locate(@variable1, lookupdata) + length(@variable1), locate(',', lookupdata, locate(@variable1, lookupdata)) - length(@variable1) - locate(@variable1, lookupdata)) lookup_var_value1
, substr(lookupdata, locate(@variable2, lookupdata) + length(@variable2), locate(',', lookupdata, locate(@variable2, lookupdata)) - length(@variable2) - locate(@variable2, lookupdata)) lookup_var_value2
#, substr(DemographicsData, locate(@variable1, DemographicsData) + length(@variable1), locate(',', DemographicsData, locate(@variable1, DemographicsData)) - length(@variable1) - locate(@variable1, DemographicsData)) demo_var_value1
, lookupdata
, `DemographicsData`
from `engine.evaluatorlog`
where (engineid like '%Avaya%')# and skill in ('10002', '10003', '10004', '10134', '10144', '10145')
and calltime >= @changetime and callgroup like '%Unknown%' and callid = 00002049151543428031
#and cast(substr(lookupdata, locate(@variable2, lookupdata) + length(@variable2), locate(',', lookupdata, locate(@variable2, lookupdata)) - length(@variable2) - locate(@variable2, lookupdata)) as signed) < 52
#and substr(lookupdata, locate(@variable2, lookupdata) + length(@variable2), locate(',', lookupdata, locate(@variable2, lookupdata)) - length(@variable2) - locate(@variable2, lookupdata)) <> ''
#and substr(lookupdata, locate(@variable1, lookupdata) + length(@variable1), locate(',', lookupdata, locate(@variable1, lookupdata)) - length(@variable1) - locate(@variable1, lookupdata)) <> ''
