CREATE TABLE `dbo.predicates_balerion` (
  `columnname` varchar(100) NOT NULL,
  `value` varchar(200) CHARACTER SET utf8 NULL,
  `predicate` varchar(4000) DEFAULT NULL,
  `datatype` varchar(50) NOT NULL,
  `order` tinyint(4) NOT NULL DEFAULT '1',
  `likematch` tinyint(4) NOT NULL DEFAULT '0',
  `is_na_predicate_one` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY (`columnname`,`value`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

Select *
From `dbo.predicates_balerion`;

Select *
From `dbo.predicates`
#Where version = 2
;

INSERT into smexplorer.`dbo.predicates_balerion` 
VALUES
#('Region_AC_OTH2', NULL, 'CustomAttributes(\'area_code.region\')', 'string','1', '0', '0'),
#('VDN', NULL, 'vdn', 'string', '1', '0', '0'),
#('BTNLENGTH', NULL, 'BTN.Length', 'int', '1', '0', '0'),
#('First_Call_Mobile_OTH1', '0', 'CustomAttributes(\'btnhistcustom_mobile.first_call\') != \'NA\'', 'string', '1', '0', '1'),
#('First_Call_Mobile_OTH1', '1', 'CustomAttributes(\'btnhistcustom_mobile.first_call\') == \'NA\'', 'string', '1', '0', '1'),
#('First_Call_Mobile_OTH1', NULL, 'CustomAttributes(\'btnhistcustom_mobile.first_call\')', 'string', '1', '0', '1')
#('CRM_LOOKUP', '0', 'CustomAttributes(\'normalized.btn\') == \'NA\'', 'string', '1', '0', '0'),
#('CRM_LOOKUP', '1', 'CustomAttributes(\'normalized.btn\') != \'NA\'', 'string', '1', '0', '0'),
#('C_TECNOLOGIA_RESUMO_CRM', NULL, 'CustomAttributes(\'normalized.c_tecnologia_resumo\')', 'string', '1', '0', '0'),
#('C_TMP_BASE_5_CRM', NULL, 'CustomAttributes(\'normalized.c_tmp_base_5\')', 'string', '1', '0', '0')
#('c_recharge_value_5_crm', NULL, 'CustomAttributes(\'normalized.c_recharge_value_5_crm\')', 'string', '1', '0', '0')
;
set sql_Safe_updates=0;
UPDATE smexplorer.`dbo.predicates_balerion`
Set columnname = lower(columnname);

Delete From smexplorer.`dbo.predicates_balerion` where columnname = 'first_call_mobile_oth1' ;

select * from smexplorer.`dbo.predicates_balerion`;

Select * From smexplorer.`dbo.predicates`;