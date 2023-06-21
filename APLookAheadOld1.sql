Select *
From `atentotfn_fixedsales.agentperformance`
Where isCurrent = 1;

-- Without Repercentiling
Drop temporary table if exists tempdb.AP;
Create temporary table tempdb.AP
Select s.AgentID, s.BTN, s.V_CALLTIME, TIMESTAMPDIFF(Second, s.TalkStart,TalkEnd) AS HandleTime, s.Is_Sale, a.Percentile
From `atentotfn_fixedsales.smetable` s
Left Join `atentotfn_fixedsales.agentperformance` a
On s.AgentID = a.AgentID
Where IsCurrent = 1 and V_CALLTIME >= '2018-08-27' and V_CALLTIME < '2018-09-03' and INSCOPE_FLAG = 1 and on_off = 1;

Drop temporary table if exists tempdb.AP1;
Create temporary table tempdb.AP1
Select *,
	(CASE When Percentile between 0 and 0.2 then 1
		When Percentile between 0.2 and 0.4 then 2
        When Percentile between 0.4 and 0.6 then 3
        When Percentile between 0.6 and 0.8 then 4
        When Percentile between 0.8 and 1.0 then 5 END
    ) Buckets
From tempdb.AP;

Select Buckets, (sum(Is_Sale)/count(Is_Sale)) AS AverageCR, count(BTN) AS NoOFCalls, (sum(HandleTime)/3600) AS `TotHandleTime(Hr)`
From tempdb.AP1
Group By Buckets;

-- With Repercentiling
