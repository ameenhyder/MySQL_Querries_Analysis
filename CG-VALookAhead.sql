#describe `atentotfn_fixedsales.callgroups`;
Set @startDate = '2019-08-05';
Set @endDate = '2019-08-15';
CALL `smexplorerdata`.`CG_Consistency_IB_v2`('atentotfn_fixedsales.callgroups', 'iscurrent=1', 'atentotfn_fixedsales.smetable',  'INSCOPE_FLAG=1' , 'RGUs', @startDate, @endDate,'smeData');

Drop temporary table if exists tempdb.CP;
Create temporary table tempdb.CP
Select c.callgroup, c.MinPercentile, c.MaxPercentile, (RAND()*(c.MaxPercentile-c.MinPercentile)+c.MinPercentile) AS RandomPercentile, s.BTN, s.V_CALLTIME, TIMESTAMPDIFF(Second, s.TalkStart,TalkEnd) AS HandleTime, s.Is_Sale, c.IsCurrent, S.agentID, S.on_off, s.RGUs, s.VDN
From tempdb.smeData s
Left Join `atentotfn_fixedsales.callgroups` c
On s.callgroup = c.callgroup
Where IsCurrent = 1 and V_CALLTIME >= @startDate and V_CALLTIME < @endDate and INSCOPE_FLAG = 1# and on_off = 0
;

Drop temporary table if exists tempdb.overall;
Create temporary table tempdb.overall
Select CP.*, AP.Percentile
From tempdb.CP CP
Left Join `atentotfn_fixedsales.agentperformance` AP On AP.agentID = CP.agentID
Where AP.IsCurrent = 1 and CP.IsCurrent = 1 and V_CALLTIME >= @startDate  and V_CALLTIME < @endDate;

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

Select Buckets, (sum(RGUs)/count(RGUs)) AS AverageCR, count(distinct AgentID) AS NoOfAgents, count(BTN) AS NoOFCalls, (sum(HandleTime)/3600) AS `TotHandleTime(Hr)`,
    sum(case when Percentile > 0.5 then RGUs else 0 end)/sum(case when Percentile > 0.5 then 1 else 0 end) - sum(case when Percentile <= 0.5 then RGUs else 0 end)/sum(case when Percentile <= 0.5 then 1 else 0 end) VA,
    
    count(case when on_off = 0 then 1 else NULL end) OffCalls,
    sum(case when on_off = 0 then RGUs else 0 end)/count(case when on_off = 0 then 1 else NULL end) OffCR,
	sum(case when Percentile > 0.5 and on_off = 0 then RGUs else 0 end)/sum(case when Percentile > 0.5 and on_off = 0 then 1 else 0 end) - sum(case when Percentile <= 0.5 and on_off = 0 then RGUs else 0 end)/sum(case when Percentile <= 0.5 and on_off = 0 then 1 else 0 end) OffVA,
    
     count(case when on_off = 1 then 1 else Null end) OnCalls,
     sum(case when on_off = 1 then RGUs else 0 end)/count(case when on_off = 1 then 1 else NULL end) OnCR,
     sum(case when Percentile > 0.5 and on_off = 1 then RGUs else 0 end)/sum(case when Percentile > 0.5 and on_off = 1 then 1 else 0 end) - sum(case when Percentile <= 0.5 and on_off = 1 then RGUs else 0 end)/sum(case when Percentile <= 0.5 and on_off = 1 then 1 else 0 end) OnVA
From tempdb.CP1
Group By 1
;

Select * From `atentotfn_fixedsales.callgroups` Where IsCurrent = 1;
#describe `atentotfn_fixedsales.smetable`;