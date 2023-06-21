#set @skill = '10163';
set @startDate = '2018-11-15';
set @endDate = '2018-11-22';
CALL `smexplorerdata`.`CG_Consistency`('vikstartfn_inbound.callgroups', 'iscurrent=1', 'vikstartfn_inbound.smetable',  'vdn in (''10321'',''10322'',''27504'')' , 'isSale', @startDate, @endDate,'smeData');

drop temporary table if exists tempdb.sme;
create temporary table tempdb.sme
select * from tempdb.smeData
where calltime between @startDate and @endDate and vdn in (10321,10322,27504) and skill in (750,754) and ansLogin is not null ;

drop temporary table if exists tempdb.ap;
create temporary table tempdb.ap
SELECT * FROM smexplorerdata.`vikstartfn_inbound.agentperformance`
where iscurrent=1 and agentID is not null;	

drop temporary table if exists tempdb.cg;
create temporary table tempdb.cg
SELECT * FROM smexplorerdata.`vikstartfn_inbound.callGroups`
where iscurrent=1 ;

Create index ix_x1 on tempdb.sme(ansLogin);
Create index ix_x2 on tempdb.ap(agentID); 

Create index ix_x3 on tempdb.sme(callgroup); 
Create index ix_x4 on tempdb.cg(callgroup); 

drop temporary table if exists tempdb.combineData;
create temporary table tempdb.combineData
select a.isSale , a.agentID , a.ansLogin, a.on_off , a.CallID , b.Percentile as ap , 
c.callGroup , c.MinPercentile, c.Maxpercentile , MOD(RAND() * (c.MaxPercentile - c.MinPercentile) + c.MinPercentile, 1) as CP
from tempdb.sme a
left join tempdb.ap b
on a.ansLogin = b.AgentId
left join tempdb.cg c
on a.callGroup = c.CallGroup; 
select * from tempdb.combineData;
-- call_type <> 'm' and

set @bucket = '5';
select ceil(ap*@bucket) , count(*), sum(isSale) , sum(isSale)/count(*) as CR, count(distinct agentID) ,
SUM(CASE WHEN on_off = 1 THEN isSale ELSE 0 END)/count(case on_off when '1' then 1 else null end) as on_CR ,
SUM(CASE WHEN on_off = 0 THEN isSale ELSE 0 END)/count(case on_off when '0' then 1 else null end) as off_CR 
from tempdb.combineData
group by 1;

set @a = '0';
select ceil(cp*@bucket) , count(*), sum(isSale) , sum(isSale)/count(*) as CR,
avg(CASE WHEN ap > 0.5 THEN isSale ELSE null END) - avg(CASE WHEN ap < 0.5 THEN isSale ELSE null END) as VA,
avg(1.0*case when (on_off = 1 and ap > 0.5) THEN isSale ELSE null END) - avg(1.0*CASE WHEN (on_off = 1 and ap < 0.5) THEN isSale ELSE null END) as OnVA,
avg(1.0*case when (on_off = 0 and ap > 0.5) THEN isSale ELSE null END) - avg(1.0*CASE WHEN (on_off = 0 and ap < 0.5) THEN isSale ELSE null END) as OffVA,
SUM(CASE WHEN on_off = 1 THEN isSale ELSE 0 END)/count(case on_off when '1' then 1 else null end) as on_CR ,
SUM(CASE WHEN on_off = 0 THEN isSale ELSE 0 END)/count(case on_off when '0' then 1 else null end) as off_CR
from tempdb.combineData
group by 1;