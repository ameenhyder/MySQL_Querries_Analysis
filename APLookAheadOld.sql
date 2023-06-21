Drop temporary table if exists tempdb.AP;
Create temporary table tempdb.AP
Select s.AgentID, s.BTN, s.V_CALLTIME, s.Is_Sale, a.Percentile, a.IsCurrent
From `atentotfn_fixedsales.smetable` s
Left Join `atentotfn_fixedsales.agentperformance` a
On s.AgentID = a.AgentID
Where IsCurrent = 1 and V_CALLTIME >= '2018-08-31';

Select * from tempdb.AP where agentID = 29879;

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

Select Buckets, (sum(Is_Sale)/count(Is_Sale)) AS AverageCR
From tempdb.AP1
Group By Buckets;

-- -----------------------------------------------------------------------------

Select @NoOfAgents := count(distinct AgentID)
From tempdb.AP-- `atentotfn_fixedsales.agentperformance`
-- Where isCurrent = 1
;

-- Now I need a list of all agents that were present. There original AP and calculate the repercentiled AP's.

Drop temporary table if exists tempdb.activeagents;
Create temporary table tempdb.activeagents
Select distinct AgentID, Percentile, IsCurrent
From tempdb.AP1
Order By Percentile;

Set @num = 0;
Drop temporary table if exists tempdb.activeagents1;
Create temporary table tempdb.activeagents1
Select *, @num := @num + 1 AS Rank, @num/@NoOfAgents AS Repercentiled From tempdb.activeagents;

Select * from tempdb.activeagents1; -- where agentID = 29879;
-- -------

Drop temporary table if exists tempdb.AP2;
Create temporary table tempdb.AP2
Select s.AgentID, s.BTN, s.V_CALLTIME, s.Is_Sale, a.Percentile, a.Repercentiled
From `atentotfn_fixedsales.smetable` s
Left Join tempdb.activeagents1 a
On s.AgentID = a.AgentID
Where V_CALLTIME >= '2018-08-31' and IsCurrent = 1;

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

Select Buckets, (sum(Is_Sale)/count(Is_Sale)) AS AverageCR
From tempdb.AP3
Group By Buckets;
