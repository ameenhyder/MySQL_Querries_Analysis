#Depending on MOBILE OR FIXED change the TABLE NAMES
Set @startDate = '2019-07-01';
Set @endDate = '2019-07-07';
#Set @skill = 18679;
Drop temporary table if exists tempdb.AP;
Create temporary table tempdb.AP
Select s.AgentID, s.BTN, s.V_CALLTIME, TIMESTAMPDIFF(Second, s.TalkStart,TalkEnd) AS HandleTime, s.Is_Sale, a.Percentile, a.IsCurrent
From `atentotfn_mobilesales.smetable_combined` s
Left Join `atentotfn_sjc_mobile.agentperformance` a
On s.AgentID = a.AgentID
Where IsCurrent = 1 and  V_CALLTIME >= @startDate and V_CALLTIME <  @endDate and INSCOPE_FLAG = 1 and on_off = 0 and site  = 'SJC';
#((V_CALLTIME >= @startDate and V_CALLTIME < '2018-11-25') or (V_CALLTIME >= '2018-11-27' and V_CALLTIME < @endDate))

Select @NoOfAgents := count(distinct AgentID)
From tempdb.AP;

Drop temporary table if exists tempdb.activeagents;
Create temporary table tempdb.activeagents
Select distinct AgentID, Percentile, IsCurrent
From tempdb.AP
Order By Percentile;

Set @num = 0;
Drop temporary table if exists tempdb.activeagents1;
Create temporary table tempdb.activeagents1
Select *, @num := @num + 1 AS Rank, @num/@NoOfAgents AS Repercentiled From tempdb.activeagents;

Drop temporary table if exists tempdb.AP2;
Create temporary table tempdb.AP2
Select s.AgentID, s.BTN, s.V_CALLTIME, TIMESTAMPDIFF(Second, s.TalkStart,TalkEnd) AS HandleTime, s.Is_Sale, s.skill, a.Percentile, a.Repercentiled
From `atentotfn_mobilesales.smetable_combined` s
Left Join tempdb.activeagents1 a
On s.AgentID = a.AgentID
Where V_CALLTIME >= @startDate and V_CALLTIME < @endDate and IsCurrent = 1 and INSCOPE_FLAG = 1 and on_off = 0;

Drop temporary table if exists tempdb.AP3;
Create temporary table tempdb.AP3
Select *,
	(CASE When Repercentiled between 0 and 0.2 then 1
		When Repercentiled between 0.2 and 0.4 then 2
        When Repercentiled between 0.4 and 0.6 then 3
        When Repercentiled between 0.6 and 0.8 then 4
        When Repercentiled between 0.8 and 1.0 then 5 END
    ) Buckets
From tempdb.AP2;

Select  Buckets, (sum(Is_sale)/count(Is_sale)) AS AverageCR, count(distinct AgentID) AS NoOfAgents, count(BTN) AS NoOFCalls, (sum(HandleTime)/3600) AS `TotHandleTime(Hr)`
From tempdb.AP3
Group By Buckets;

Select * From `atentotfn_mobilesales.callgroups` Where isCurrent = 1;

#Select * From `atentotfn_mobilesales.smetable` Order by calltime desc;