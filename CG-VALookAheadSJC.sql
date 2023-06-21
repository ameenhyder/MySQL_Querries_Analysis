Set @startDate = '2019-07-20';
Set @endDate = '2019-07-22';
CALL `smexplorerdata`.`CG_Consistency_IB`('atentotfn_sjc_mobile.callgroups', 'iscurrent=1', 'atentotfn_mobilesales.smetable_combined',  'INSCOPE_FLAG=1' , 'Is_sale', @startDate, @endDate,'smeData');

Drop temporary table if exists tempdb.CP;
Create temporary table tempdb.CP
Select c.callgroup, c.MinPercentile, c.MaxPercentile, (RAND()*(c.MaxPercentile-c.MinPercentile)+c.MinPercentile) AS RandomPercentile, s.BTN, s.V_CALLTIME, TIMESTAMPDIFF(Second, s.TalkStart,TalkEnd) AS HandleTime, s.Is_Sale, c.IsCurrent, S.agentID, S.on_off
From tempdb.smeData s
Left Join `atentotfn_sjc_mobile.callgroups` c
On s.callgroup = c.callgroup
Where IsCurrent = 1 and V_CALLTIME >= @startDate and V_CALLTIME < @endDate and INSCOPE_FLAG = 1 and Site = 'SJC'# and on_off = 0
#((V_CALLTIME >= @startDate and V_CALLTIME < '2018-11-25') or (V_CALLTIME >= '2018-11-27' and V_CALLTIME < @endDate))
;

Drop temporary table if exists tempdb.overall;
Create temporary table tempdb.overall
Select CP.*, AP.Percentile
From tempdb.CP CP
Left Join `atentotfn_sjc_mobile.agentperformance` AP On AP.agentID = CP.agentID
Where AP.IsCurrent = 1 and CP.IsCurrent = 1 and V_CALLTIME >= @startDate  and V_CALLTIME < @endDate;
#Count is 46260

Drop temporary table if exists tempdb.CP1;
Create temporary table tempdb.CP1
Select *,
	(CASE When RandomPercentile between 0 and 0.2 then 1
		When RandomPercentile between 0.2 and 0.4 then 2
        When RandomPercentile between 0.4 and 0.6 then 3
        When RandomPercentile between 0.6 and 0.8 then 4
        When RandomPercentile between 0.8 and 1.0 then 5 END
    ) Buckets
From tempdb.overall;

Select Buckets, (sum(Is_sale)/count(Is_sale)) AS AverageCR, count(distinct AgentID) AS NoOfAgents, count(BTN) AS NoOFCalls, (sum(HandleTime)/3600) AS `TotHandleTime(Hr)`,
    sum(case when Percentile > 0.5 then Is_sale else 0 end)/sum(case when Percentile > 0.5 then 1 else 0 end) -	sum(case when Percentile <= 0.5 then Is_sale else 0 end)/sum(case when Percentile <= 0.5 then 1 else 0 end) VA,

	count(case when on_off = 0 then 1 else NULL end) OffCalls,
    sum(case when on_off = 0 then Is_sale else 0 end)/count(case when on_off = 0 then 1 else NULL end) OffCR,
	sum(case when Percentile > 0.5 and on_off = 0 then Is_sale else 0 end)/sum(case when Percentile > 0.5 and on_off = 0 then 1 else 0 end) - sum(case when Percentile <= 0.5 and on_off = 0 then Is_sale else 0 end)/sum(case when Percentile <= 0.5 and on_off = 0 then 1 else 0 end) OffVA,
    
     count(case when on_off = 1 then 1 else Null end) OnCalls,
     sum(case when on_off = 1 then Is_sale else 0 end)/count(case when on_off = 1 then 1 else NULL end) OnCR,
     sum(case when Percentile > 0.5 and on_off = 1 then Is_sale else 0 end)/sum(case when Percentile > 0.5 and on_off = 1 then 1 else 0 end) - sum(case when Percentile <= 0.5 and on_off = 1 then Is_sale else 0 end)/sum(case when Percentile <= 0.5 and on_off = 1 then 1 else 0 end) OnVA
     
From tempdb.CP1
Group By 1
;

Select * From `atentotfn_sjc_mobile.callgroups` Where isCurrent = 1;


#CG CR Trend
/*Select callgroup, date(v_callTime), avg(Is_Sale) * 100
From tempdb.smeData
where v_calltime >= @startDate
Group By 1,2
Having count(*) > 100;


Select date(calltime), CP_Decile, count(*), avg(Is_Sale)
From `atentotfn_mobilesales.smetable`
Where calltime >= '2019-01-30' and INSCOPE_FLAG = 1 
Group By 1,2
;
describe `atentotfn_mobilesales.smetable`;

Select * From  `atentotfn_mobilesales.smetable`
Order By calltime desc;*/

set sql_Safe_updates=0;
update `atentotfn_sjc_mobile.callgroups` set IsCurrent = 0
where iscurrent=1 and callgroup like '%unknown%';