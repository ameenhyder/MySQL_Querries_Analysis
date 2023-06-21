set sql_Safe_updates=0;

######################Call Groups##########################################
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, 'vdn == \'20064\'', 'vdn in {\'20064\'}');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, 'vdn == \'20049\'', 'vdn in {\'20049\'}');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, 'vdn == \'20145\'', 'vdn in {\'20145\'}');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, 'vdn == \'20144\'', 'vdn in {\'20144\'}');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, 'vdn == \'20125\'', 'vdn in {\'20125\'}');

update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, '\'20064\'', '\'20064\', \'70263\'');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, '\'20049\'', '\'20049\', \'70227\'');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, '\'20145\'', '\'20145\', \'30001\'');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, '\'20144\'', '\'20144\', \'30013\'');
update `tfonicaatento_stan_ib_mobile.callgroups` set Predicate = replace(Predicate, '\'20125\'', '\'20125\', \'30025\'');

#Select * From `atentotfn_mobilesales.callgroups` Where IsCurrent = 1;
Select * From  `tfonicaatento_stan_ib_mobile.callgroups`;# Delete From `tfonicaatento_stan_ib_mobile.agentperformance` Where IsCurrent = 1;
#describe `tfonicaatento_stan_ib_mobile.callgroups`;
#describe `atentotfn_mobilesales.callgroups`;
#Update `tfonicaatento_stan_ib_mobile.callgroups` set GeneratedOn = now() Where IsCurrent = 1;

Update `atentotfn_mobilesales.callgroups` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_mobilesales.callgroups`
select * from `tfonicaatento_stan_ib_mobile.callgroups`;

Select * From `atentotfn_mobilesales.callgroups` Where IsCurrent = 1;

#################Agent Performance##########################################
#Select * From `tfonicaatento_stan_ib_mobile.agentperformance`;

#describe `tfonicaatento_stan_ib_mobile_sjc.agentperformance`;
#describe `atentotfn_sjc_mobile.agentperformance`;
#Update `tfonicaatento_stan_ib_mobile.agentperformance` set GeneratedOn = now() Where IsCurrent = 1;

update `tfonicaatento_stan_ib_mobile.agentperformance` set Split = 'Global Performance'
where iscurrent=1;

Update `atentotfn_mobilesales.agentperformance` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_mobilesales.agentperformance` 
select * from `tfonicaatento_stan_ib_mobile.agentperformance` group by agentID; 

update `atentotfn_mobilesales.agentperformance` set AgentKey = concat(AgentID, '::Global Performance')
where iscurrent=1;

Select * From `atentotfn_mobilesales.agentperformance` Where IsCurrent = 1;

#######################COPY TO SJC###############################################################
Update `atentotfn_sjc_mobile.callgroups` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_sjc_mobile.callgroups`
select * from `atentotfn_mobilesales.callgroups` where IsCurrent = 1;

Update `atentotfn_sjc_mobile.callgroups` set Callgroup= concat('SJC_', Callgroup) 
where iscurrent = 1; 

Select * From `atentotfn_sjc_mobile.callgroups` Where IsCurrent = 1;

Update `atentotfn_sjc_mobile.agentperformance` set iscurrent = 0 
where iscurrent = 1; 

Insert into `atentotfn_sjc_mobile.agentperformance`
select * from `atentotfn_mobilesales.agentperformance` where IsCurrent = 1;

Select * From `atentotfn_sjc_mobile.agentperformance` Where IsCurrent = 1;
##################################### Predicate Addition###########################################
 /*
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
 From `atentotfn_mobilesales.agentperformance`
 Where IsCurrent = 1;
 
Select *
From `atentotfn_sjc_mobile.callgroups`
Where IsCurrent = 1;

CustomAttributes('normalized.c_tecnologia_resumo') in {'NA','2G'} and CustomAttributes('area_code.region') == 'Minas' and vdn == '70284' and BTN.Length in {'11','4'} and CustomAttributes('btnhistcustom_mobile.first_call') in {'NA','1'}