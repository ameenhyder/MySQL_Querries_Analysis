-- This query is on smexplorer
Select *
From `dbo.clients`;

-- atentotfn_fixedsales.smetable --> This is the SMETableName
-- atentotfn_fixedsales --> This is the OutputSchemaName

-- This query is on smexplorerdata
Select AgentId
From `atentotfn_fixedsales.smetable`;

-- This query is on smexplorerdata
Select AgentId
From `atentotfn_fixedsales.agentperformance`
Where GeneratedOn >= '2018-08-01' and iscurrent = 1 
Order by GeneratedOn;

#Check AP_ACTUAL_EVAL from SMETABLE
Select On_off, EvalAlgoUsed, avg(AP_ACTUAL_EVAL)
From `atentotfn_mobilesales.smetable`
Where V_CALLTIME_DT >= '2018-09-23'
Group By On_off, EvalAlgoUsed;
