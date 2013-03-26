CREATE TABLE `td_tudu_step` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ID',
  `step_id` varchar(36) NOT NULL DEFAULT '0' COMMENT '����ID',
  `prev_step_id` varchar(36) DEFAULT NULL COMMENT 'ǰһ����ID',
  `next_step_id` varchar(36) DEFAULT NULL COMMENT '��һ����ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�������� 0.ִ�У�1.����',
  `step_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '����״̬ 0.δ����,1.������, 2.�����,3.�Ѿ��ܾ�����ͬ�⣩,4.����',
  `is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ������',
  `is_current` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ǰִ�в���',
  `is_show` tinyint(1) unsigned DEFAULT NULL COMMENT '�Ƿ��ڲ����б�����ʾ',
  `percent` tinyint(3) unsigned DEFAULT NULL COMMENT '�����',
  `order_num` int(11) unsigned DEFAULT NULL COMMENT '����ID',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`tudu_id`,`step_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_is_current` (`is_current`),
  KEY `idx_type` (`type`),
  KEY `idx_prev_step_id` (`prev_step_id`),
  KEY `idx_next_step_id` (`next_step_id`),
  CONSTRAINT `step_of_which_tudu` FOREIGN KEY (`tudu_id`) REFERENCES `td_tudu` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�Ȳ����¼��';



-- Table "td_tudu_step_user" DDL

CREATE TABLE `td_tudu_step_user` (
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `step_id` varchar(35) NOT NULL DEFAULT '' COMMENT '����ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `user_info` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '�û���Ϣ email name',
  `process_index` int(11) NOT NULL DEFAULT '0' COMMENT '����˳������',
  `percent` tinyint(3) DEFAULT NULL COMMENT '����',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '����״̬����td_tudu.statusһ��',
  `temp_is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ݹ����Ƿ����',
  PRIMARY KEY (`tudu_id`,`step_id`,`unique_id`),
  KEY `idx_tudu_id` (`tudu_id`),
  KEY `idx_process_index` (`process_index`),
  KEY `idx_status` (`status`),
  KEY `idx_temp_is_done` (`temp_is_done`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='����ִ���˹���';


-- app
CREATE TABLE `app_app` (
  `app_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Ӧ��ID��JAVA����ʽ',
  `app_name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'Ӧ������',
  `version` varchar(10) NOT NULL DEFAULT '' COMMENT '�汾��',
  `type` enum('inner','outer') NOT NULL DEFAULT 'inner' COMMENT 'Ӧ������',
  `open_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '������ʽ 0.ȫ������ 1.���Թ������û�����',
  `url` varchar(255) DEFAULT NULL COMMENT '����URL��������ⲿӦ��',
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Ӧ�����ݱ�';


-- Table "app_info" DDL

CREATE TABLE `app_info` (
  `app_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'Ӧ��ID',
  `author` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT 'Ӧ��ͼ���ַ',
  `description` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '����',
  `content` text CHARACTER SET utf8 NOT NULL COMMENT 'Ӧ����ϸ',
  `languages` tinyint(1) DEFAULT NULL COMMENT '֧������ 1.���� 2.���� 4.Ӣ',
  `score` tinyint(3) NOT NULL DEFAULT '0' COMMENT '����',
  `comment_num` int(11) NOT NULL DEFAULT '0' COMMENT '������',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `last_update_time` int(10) NOT NULL DEFAULT '0' COMMENT '������ʱ��',
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Ӧ����չ��Ϣ����¼��ҵ���޹ص����ݣ�Ӧ��˵����';

-- Table "app_info_attach" DDL

CREATE TABLE `app_info_attach` (
  `app_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'Ӧ��ID',
  `type` enum('photo','video','audio') NOT NULL DEFAULT 'photo' COMMENT '��������',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '����URL',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '����ID',
  KEY `idx_type` (`type`),
  KEY `idx_order_num` (`order_num`),
  KEY `idx_app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Ӧ�ý��ܸ������ݱ�Ӧ����ϸҳ���Ƕ��ͼƬ��������Ƶ��';



CREATE TABLE `app_org` (
  `app_id` varchar(120) NOT NULL DEFAULT '' COMMENT 'Ӧ��ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Ӧ��״̬ 0.δ��ʼ�� 1.���� 2.ͣ��',
  `settings` text CHARACTER SET utf8 COMMENT 'Ӧ�õ���������',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `expire_date` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `active_time` int(11) unsigned DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`app_id`,`org_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_active_time` (`active_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Ӧ�ð�װ��¼��';



-- Table "app_user" DDL

CREATE TABLE `app_user` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `app_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'Ӧ��ID',
  `item_id` varchar(120) NOT NULL DEFAULT '' COMMENT 'Ӧ����Ա�ʺ� / Ⱥ��ID',
  `role` varchar(20) NOT NULL DEFAULT '' COMMENT 'Ӧ�ý�ɫ��ֵ�ɸ�Ӧ�ö��壩',
  PRIMARY KEY (`org_id`,`item_id`,`app_id`,`role`),
  KEY `idx_app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Ӧ�õ���֯�������ݱ�';



-- Table "attend_user" DDL

CREATE TABLE `attend_user` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `dept_id` varchar(36) DEFAULT NULL COMMENT '����ID',
  `true_name` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '�û���ʵ����',
  `dept_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '��������',
  `update_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`),
  KEY `idx_attend_user_org_id` (`org_id`),
  KEY `idx_attend_user_dept_id` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�����û���Ϣ��';



-- Table "attend_total" DDL

CREATE TABLE `attend_total` (
  `category_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ڷ���ID',
  `org_id` varchar(60) DEFAULT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `date` int(10) NOT NULL DEFAULT '0' COMMENT 'ͳ�Ƶ�����',
  `total` float NOT NULL DEFAULT '0' COMMENT 'ͳ�ƽ��',
  `update_time` int(10) unsigned DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`category_id`,`unique_id`,`date`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���ڷ���';



-- Table "attend_apply" DDL

CREATE TABLE `attend_apply` (
  `apply_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '������֯ID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `category_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��������',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ָ���û�ΨһID',
  `sender_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����û�ΨһID',
  `user_info` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '�������û���Ϣ email truename',
  `checkin_type` tinyint(1) unsigned DEFAULT NULL COMMENT '��ǩ���ͣ�0ǩ����1ǩ�ˣ�',
  `is_allday` tinyint(1) unsigned DEFAULT NULL COMMENT 'ʱ�����ͣ��졢Сʱ��',
  `start_time` int(11) unsigned DEFAULT NULL COMMENT '��ʼʱ��',
  `end_time` int(11) unsigned DEFAULT NULL COMMENT '��ֹʱ��',
  `period` float(10,1) DEFAULT NULL COMMENT 'ʱ��(Сʱ)',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '����״̬ 0. �·��� 1. ������ 2. ��ͨ�� 3. �Ѿܾ� 4. ��ȡ��',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`apply_id`),
  UNIQUE KEY `idx_tudu_id` (`tudu_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_unique_id` (`unique_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���������¼��';



-- Table "attend_apply_reviewer" DDL

CREATE TABLE `attend_apply_reviewer` (
  `apply_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����¼ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ID',
  `review_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '����״̬ 0.δ���� 1.��ͨ�� 2. �Ѿܾ�',
  PRIMARY KEY (`apply_id`,`unique_id`),
  KEY `idx_review_status` (`review_status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�������������˹�����';



-- Table "attend_category" DDL

CREATE TABLE `attend_category` (
  `category_id` varchar(36) NOT NULL COMMENT '���ڷ���ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `category_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '���ڷ�������',
  `flow_steps` text CHARACTER SET utf8 COMMENT '��������',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '���ڷ���״̬��0��ͣ�ã�1��������',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '�Ƿ���ʾ',
  `is_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳ���ڷ���',
  `create_time` int(11) unsigned DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`category_id`,`org_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idex_category_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���ڷ���';



-- Table "attend_checkin" DDL

CREATE TABLE `attend_checkin` (
  `checkin_id` varchar(36) NOT NULL COMMENT 'ǩ��ID',
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT 'ǩ���û�ΨһID',
  `date` int(10) unsigned NOT NULL COMMENT '����',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�Ǽ����ͣ�0���ϰ�ǩ����1���°�ǩ�ˣ�',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '����״����0��������1���ٵ���2�����ˣ�3��������',
  `ip` int(11) unsigned NOT NULL COMMENT 'ǩ��IP��ַ',
  `address` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '����λ��',
  `create_time` int(10) unsigned NOT NULL COMMENT 'ǩ��ʱ��',
  PRIMARY KEY (`checkin_id`),
  KEY `idx_unique_id_date` (`unique_id`,`date`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���ڵǼ�(ǩ��ǩ��)';



-- Table "attend_date" DDL

CREATE TABLE `attend_date` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `date` int(10) NOT NULL COMMENT 'ͳ�Ƶ�����',
  `is_late` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�ٵ�',
  `is_leave` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '����',
  `is_work` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '����',
  `is_abnormal_ip` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�IP�쳣',
  `checkin_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'ǩ��/��״̬',
  `work_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `update_time` int(10) unsigned DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`,`date`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='����ͳ�ƣ��죩';



-- Table "attend_date_apply" DDL

CREATE TABLE `attend_date_apply` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT 'ΨһID',
  `date` int(10) unsigned NOT NULL COMMENT '����',
  `category_id` varchar(36) NOT NULL COMMENT '��������ID',
  `memo` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '˵��',
  KEY `idx_org_id` (`org_id`),
  KEY `idx_unique_id` (`unique_id`),
  KEY `idx_date_id` (`date`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- Table "attend_month" DDL

CREATE TABLE `attend_month` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `date` int(10) unsigned NOT NULL COMMENT '����',
  `late` int(2) DEFAULT '0' COMMENT '�ٵ�����λ���Σ�',
  `leave` int(2) DEFAULT '0' COMMENT '���ˣ���λ���Σ�',
  `unwork` int(2) DEFAULT '0' COMMENT '��������λ���Σ�',
  `is_abnormal_ip` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '��ǰ�·��Ƿ����IP�쳣',
  `update_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='������ͳ�Ʊ�ֻͳ�ƣ��ٵ������ˡ������Ĵ�����';



-- Table "attend_schedule" DDL

CREATE TABLE `attend_schedule` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `schedule_id` varchar(36) NOT NULL COMMENT '�Ű෽��ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�Ű෽��������ΨһID',
  `name` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '�Ű෽������',
  `bgcolor` char(7) DEFAULT NULL COMMENT '��ɫ',
  `is_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳ�Ű෽��',
  `create_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  `is_valid` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '�Ƿ����',
  PRIMARY KEY (`schedule_id`,`org_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_is_system` (`is_system`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_bgcolor` (`bgcolor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�Ű෽�����ݱ�';

-- Table "attend_schedule_adjust" DDL

CREATE TABLE `attend_schedule_adjust` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `adjust_id` varchar(36) NOT NULL COMMENT '������¼ID',
  `subject` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '����',
  `start_time` int(10) unsigned NOT NULL COMMENT '������ʼʱ��',
  `end_time` int(10) unsigned NOT NULL COMMENT '��������ʱ��',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�������� 0.�ǹ����� 1.������',
  `create_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`adjust_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�Ű๤���յ���';



-- Table "attend_schedule_adjust_user" DDL

CREATE TABLE `attend_schedule_adjust_user` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `adjust_id` varchar(36) NOT NULL COMMENT '������¼ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `create_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`adjust_id`,`unique_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�����յ������û�������¼';



-- Table "attend_schedule_plan" DDL

CREATE TABLE `attend_schedule_plan` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `plan_id` varchar(36) NOT NULL COMMENT '�Ű�ƻ�ID',
  `type` tinyint(1) NOT NULL COMMENT '�Ű�ƻ�����',
  `memo` varchar(300) CHARACTER SET utf8 DEFAULT NULL COMMENT '�ƻ���ע',
  `cycle_num` tinyint(3) NOT NULL DEFAULT '1',
  `create_time` int(10) unsigned NOT NULL COMMENT '��¼����ʱ��',
  PRIMARY KEY (`plan_id`,`org_id`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�Ű�ƻ����ݱ�';



-- Table "attend_schedule_plan_detail" DDL

CREATE TABLE `attend_schedule_plan_detail` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `plan_id` varchar(36) NOT NULL COMMENT '�Ű�ƻ�ID',
  `schedule_id` varchar(36) NOT NULL COMMENT '�Ű෽��ID',
  `value` int(10) unsigned NOT NULL COMMENT '��¼�Ű����Ͷ�Ӧ��ֵ���Ű�ƻ��ĵڼ���',
  KEY `idx_org_id` (`org_id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�Ű�ƻ���ϸ���ݱ�';


-- Table "attend_schedule_plan_month" DDL

CREATE TABLE `attend_schedule_plan_month` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `date` int(6) unsigned NOT NULL COMMENT '�Ű�ƻ�����',
  `plan` text NOT NULL COMMENT '���Ű�ƻ���json��ʽ',
  `memo` varchar(300) CHARACTER SET utf8 DEFAULT NULL COMMENT '�ƻ���ע',
  `update_time` int(10) unsigned NOT NULL COMMENT '��¼����ʱ��',
  PRIMARY KEY (`unique_id`,`date`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���Ű�ƻ����ݱ�';



-- Table "attend_schedule_plan_user" DDL

CREATE TABLE `attend_schedule_plan_user` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `plan_id` varchar(36) NOT NULL COMMENT 'ʹ���Ű�ƻ�ID',
  `start_time` int(10) unsigned NOT NULL COMMENT '�ƻ�ִ�п�ʼʱ��',
  `end_time` int(10) unsigned DEFAULT NULL COMMENT '�ƻ�ִ�н���ʱ��',
  KEY `idx_org_id` (`org_id`),
  KEY `idx_unique_id` (`unique_id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û��Ű�ƻ�������';



-- Table "attend_schedule_plan_week" DDL

CREATE TABLE `attend_schedule_plan_week` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `plan` text NOT NULL COMMENT '���Ű�ƻ���json��ʽ',
  `cycle_num` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '��ѭ������',
  `memo` varchar(300) CHARACTER SET utf8 DEFAULT NULL COMMENT '��ע',
  `effect_date` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '��Чʱ��',
  PRIMARY KEY (`unique_id`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���Ű�ƻ����ݱ�һ��ֻΪ�������Űࣩ';



-- Table "attend_schedule_rule" DDL

CREATE TABLE `attend_schedule_rule` (
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `schedule_id` varchar(36) NOT NULL COMMENT '�Ű෽��ID',
  `rule_id` varchar(36) NOT NULL COMMENT '����ID',
  `week` tinyint(1) unsigned DEFAULT NULL COMMENT '�ܼ�(0-6)',
  `checkin_time` int(5) unsigned DEFAULT NULL COMMENT 'ǩ��ʱ��(��λ:s)',
  `checkout_time` int(5) unsigned DEFAULT NULL COMMENT '�°�ǩ��ʱ��',
  `late_standard` int(4) unsigned DEFAULT NULL COMMENT '�ٵ���׼',
  `late_checkin` int(4) unsigned DEFAULT NULL COMMENT '������׼',
  `leave_standard` int(4) unsigned DEFAULT NULL COMMENT '���˱�׼',
  `leave_checkout` int(4) unsigned DEFAULT NULL COMMENT 'ǩ�˿�����׼',
  `create_time` int(10) unsigned NOT NULL COMMENT '����ʱ��',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '״̬',
  PRIMARY KEY (`rule_id`,`schedule_id`,`org_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_schedule_id` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�Ű෽�������';
