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
