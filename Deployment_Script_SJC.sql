set sql_Safe_updates=0;

######################Call Groups##########################################
#update `tfonicaatento_stan_ib_mobile_sjc.callgroups` set Predicate = replace(Predicate, 'vdn == \'30013\'', 'vdn in {\'30013\',\'70263\'}');
#update `tfonicaatento_stan_ib_mobile_sjc.callgroups` set Predicate = replace(Predicate, 'vdn == \'30001\'', 'vdn in {\'30001\',\'70227\'}');
#update `tfonicaatento_stan_ib_mobile_sjc.callgroups` set Predicate = replace(Predicate, 'vdn == \'30025\'', 'vdn in {\'30025\',\'70284\'}');

#Select * From `tfonicaatento_stan_ib_mobile_sjc.callgroups`;
#Select * From `atentotfn_sjc_mobile.callgroups` Where IsCurrent = 1;

#describe `tfonicaatento_stan_ib_mobile_sjc.callgroups`;
#describe `atentotfn_sjc_mobile.callgroups`;

Update `atentotfn_sjc_mobile.callgroups` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_sjc_mobile.callgroups`
select * from `tfonicaatento_stan_ib_mobile_sjc.callgroups`;

Select * From `atentotfn_sjc_mobile.callgroups` Where IsCurrent = 1;

#################Agent Performance##########################################
#Select * From `tfonicaatento_stan_ib_mobile_sjc.agentperformance`;

#describe `tfonicaatento_stan_ib_mobile_sjc.agentperformance`;
#describe `atentotfn_sjc_mobile.agentperformance`;

update `tfonicaatento_stan_ib_mobile_sjc.agentperformance` set Split = 'Global Performance'
where iscurrent=1;

Update `atentotfn_sjc_mobile.agentperformance` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_sjc_mobile.agentperformance` 
select * from `tfonicaatento_stan_ib_mobile_sjc.agentperformance` group by agentID; 

update `atentotfn_sjc_mobile.agentperformance` set AgentKey = concat(AgentID, '::Global Performance')
where iscurrent=1;

Select * From `atentotfn_sjc_mobile.agentperformance` Where IsCurrent = 1;

##################################### Predicate Addition###########################################
 
 Insert into smexplorer.`dbo.predicates`
VALUES
/*('Region_AC_OTH2', '', 'CustomAttributes(\'area_code.region\')', 'string', '2', '1', '0'),
('VDN', '', 'vdn', 'string', '2', '1', '0'),
('BTNLENGTH', '', 'BTN.Length', 'int', '2', '1', '0'),
('First_Call_Mobile_OTH1', '', 'CustomAttributes(\'btnhistcustom_mobile.first_call\')', 'string', '2', '1', '0'),
('CRM_LOOKUP', '', 'CustomAttributes(\'normalized.btn\')', 'string', '2', '0', '0'),
('C_TECNOLOGIA_RESUMO_CRM', '', 'CustomAttributes(\'normalized.c_tecnologia_resumo\')', 'string', '2', '1', '0'),
('C_TMP_BASE_5_CRM', '', 'CustomAttributes(\'normalized.c_tmp_base_5\')', 'string', '2', '1', '0')*/
('NPA', '', 'Substring(BTN,0,3)', 'string', '2', '1', '0');

UPDATE smexplorer.`dbo.predicates`
Set ColumnName = lower(ColumnName) where version = 2;
 
 ###################################################################################################
 Select *
 From `atentotfn_sjc_mobile.agentperformance`
 Where IsCurrent = 1;
 
Select *
From `atentotfn_sjc_mobile.callgroups`
Where IsCurrent = 1;

CustomAttributes('normalized.c_tecnologia_resumo') in {'NA','2G'} and CustomAttributes('area_code.region') == 'Minas' and vdn == '70284' and BTN.Length in {'11','4'} and CustomAttributes('btnhistcustom_mobile.first_call') in {'NA','1'}