-- This query is on smexplorer
Select *
From `clients`;

-- atentotfn_fixedsales.smetable --> This is the SMETableName
-- atentotfn_fixedsales --> This is the OutputSchemaName

-- This query is on smexplorerdata
Select AgentId
From `table1`;

-- This query is on smexplorerdata
Select AgentId
From `performance`
Where GeneratedOn >= '2018-08-01' and iscurrent = 1 
Order by GeneratedOn;

#Check AP_ACTUAL_EVAL from SMETABLE
Select On_off, EvalAlgoUsed, avg(AP_ACTUAL_EVAL)
From `table3`
Where V_CALLTIME_DT >= '2018-09-23'
Group By On_off, EvalAlgoUsed;
