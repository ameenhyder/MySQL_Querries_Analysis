Select calldate,skill,count(*) as calls, count(distinct anslogin) as agentCount , avg(Is_Sale)* 100 as CR , avg(case when anslogin = 'NA' then 0 else 1 end) as DispositionRate
From `atentotfn_mobilesales.smetable`
Where calldate >= '2019-02-15' and INSCOPE_FLAG = 1# and calldate < '2018-09-01'
Group by calldate, skill;

Select date(calltime), 
	sum(case when on_off = 0 then 1 else 0 end) AS OffCalls,
    avg(case when on_off = 0 then RGUs else NULL end)*100 AS OffCR,
    sum(case when on_off = 1 then 1 else 0 end) AS OnCalls,
    avg(case when on_off = 0 then RGUs else NULL end)*100 AS OnCR
From `atentotfn_fixedsales.smetable`
Where calldate >= '2018-09-01' and calldate < '2018-11-02'
Group by calldate;