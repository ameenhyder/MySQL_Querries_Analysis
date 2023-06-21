Select date(calltime), skill, on_off
From `atentotfn_fix.vaca`
Where calltime >= '2018-05-23'  and  on_off = 1 and isrelevant = 1#and calltime < '2018-09-02'
Limit 1000; 


Select date(callTime) `date`, Skill, AgentID, count(*) AS TotalCalls,
sum(case when On_off = 0 then 1 else 0 end) OffCalls,
sum(case when On_off = 1 then 1 else 0 end) OnCalls,
sum(case when On_off = 0 then Is_Sale else 0 end) + sum(case when On_off = 1 then Is_Sale else 0 end) TotalSales,
sum(case when On_off = 0 then Is_Sale else 0 end) OffSales,
sum(case when On_off = 1 then Is_Sale else 0 end) OnSales,
(sum(case when On_off = 0 then Is_Sale else 0 end) + sum(case when On_off = 1 then Is_Sale else 0 end))/(sum(case when On_off = 0 then 1 else 0 end) + sum(case when On_off = 1 then 1 else 0 end)) CR,
sum(case when On_off = 1 then Is_Sale else 0 end) / sum(case when On_off = 1 then 1 else 0 end) OnCR,
sum(case when On_off = 0 then Is_Sale else 0 end) / sum(case when On_off = 0 then 1 else 0 end)OffCR,
dispsklevel AS priority
From `atentotfn_mobile.vaca`
Where calltime >= '2018-10-01' and /*calltime < '2018-10-01' and*/  inscope_flag = 1 and  skill in (18037, 18165, 18679) #'2018-08-15'
Group by date(callTime),Skill, AgentID,dispsklevel
Limit 5000000;

Select *
From `atentotfn_fix.vaca`
Limit 1;

Select date(callTime) `date`, Skill, AgentID
From `atentotfn_fix.vaca`
Where calltime >= '2018-05-23'  and IsRelevant = 1 and on_off = 1
Limit 100;