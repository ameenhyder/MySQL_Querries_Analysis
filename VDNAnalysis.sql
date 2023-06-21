Select VDN, date(calltime), avg( case when AP_ACTUAL_EVAL >= 0.5 then RGUs else NULL end) AS GoodAgentsCR, avg( case when AP_ACTUAL_EVAL < 0.5 then RGUs else NULL end) AS BadAgentsCR, 
	avg( case when AP_ACTUAL_EVAL >= 0.5 then RGUs else NULL end) - avg( case when AP_ACTUAL_EVAL < 0.5 then RGUs else NULL end) AS VA
From `atentotfn_fixedsales.smetable`
Where calltime >= '2018-09-18'
Group By 1,2;

Select distinct VDN
From `atentotfn_fixedsales.smetable`
Where calltime >= '2018-10-18' and INSCOPE_FLAG = 1#and AgentPercentile not in (0,1)