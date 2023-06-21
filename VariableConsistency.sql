Select date(calltime),First_Call_OTH1, 
	sum(case when on_off = 0 then Is_Sale else 0 end)/sum(case when on_off = 0 then 1 else 0 end) as OffCR,
    sum(case when on_off = 1 then Is_Sale else 0 end)/sum(case when on_off = 1 then 1 else 0 end) as OnCR
From `atentotfn_mobilesales.smetable`
Where calltime >= '2019-01-01'
Group By 1,2;

########################################################

Select week(calltime), VDN, count(*),
	sum(case when AgentPercentile > 0.5 then Is_Sale else 0 end)/sum(case when AgentPercentile > 0.5 then 1 else 0 end) - sum(case when AgentPercentile <= 0.5 then Is_Sale else 0 end)/sum(case when AgentPercentile <= 0.5 then 1 else 0 end) VA
From `atentotfn_mobilesales.smetable`
Where calltime >= '2018-12-01' and on_off = 0# and CRM_LOOKUP = 1
Group By 1,2
Having count(*) > 20
Limit 10000;

Select distinct skill, VDN, count(*)
From `atentotfn_mobilesales.smetable`
Where calltime >= '2019-01-01' and on_off = 0 and INSCOPE_FLAG = 1
Group By 1,2;

Select avg(Is_Sale)
From `atentotfn_mobilesales.smetable_combined`
Where calltime >= '2019-05-01' and site = 'sjc' and inscope_flag = 1;