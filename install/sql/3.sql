CREATE TABLE `td_board` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `type` enum('zone','board','system') NOT NULL DEFAULT 'zone' COMMENT '�������',
  `owner_id` varchar(60) NOT NULL DEFAULT '' COMMENT '���������ID',
  `parent_board_id` varchar(36) DEFAULT NULL COMMENT '�ϼ����ID',
  `board_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '�������',
  `memo` text CHARACTER SET utf8 COMMENT '���˵��',
  `moderators` text CHARACTER SET utf8 COMMENT '����',
  `groups` text COMMENT '�����û���,email��ʽΪ�û�,��email��ʽΪȺ��ID',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '���״̬: 0 - �������, 1 - ���ذ��, 2 - �رհ��',
  `privacy` tinyint(1) NOT NULL DEFAULT '0',
  `protect` tinyint(1) NOT NULL DEFAULT '0',
  `is_classify` tinyint(1) NOT NULL DEFAULT '0' COMMENT '����ѡ�����',
  `flow_only` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ֻ����ʹ�ù�����',
  `need_confirm` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'ͼ���Ƿ���Ҫȷ��',
  `last_post` varchar(250) CHARACTER SET utf8 DEFAULT NULL COMMENT '���ظ���Ϣ',
  `tudu_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '��ͼ����',
  `post_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '�ܻظ���',
  `today_tudu_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ͼ����',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '������ֵ',
  `temp_is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ݹ����Ƿ����',
  `last_update_time` int(10) unsigned DEFAULT NULL COMMENT '���������ʱ��',
  PRIMARY KEY (`org_id`,`board_id`),
  KEY `idx_order` (`type`,`order_num`),
  KEY `fk_parent_board` (`org_id`,`parent_board_id`),
  KEY `idx_temp_is_done` (`temp_is_done`),
  CONSTRAINT `fk_parent_board` FOREIGN KEY (`org_id`, `parent_board_id`) REFERENCES `td_board` (`org_id`, `board_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�Ȱ��';

INSERT INTO td_board (org_id, board_id, type, owner_id, board_name, moderators, groups, privacy, order_num) VALUES ('testorg', '^zone', 'zone', 'admin', 'Ĭ�Ϸ���', 'admin ����Ա', '^all', 0, 1);
INSERT INTO td_board (org_id, board_id, type, owner_id, board_name, moderators, groups, privacy, parent_board_id, order_num) VALUES ('testorg', '^board', 'board', 'admin', 'Ĭ�ϰ��', 'admin ����Ա', '^all', 1, '^zone', 1);


CREATE TABLE `td_board_user` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `order_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`org_id`,`board_id`,`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���ݰ���';


CREATE TABLE `td_board_favor` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Ȩ�أ�����Ƶ�ʣ����ֹ����� 99999 - 98999��ϵͳ���0 - 10000',
  `last_update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '������ʱ��',
  PRIMARY KEY (`unique_id`,`board_id`,`org_id`),
  KEY `idx_weight` (`weight`),
  KEY `idx_org_id_board_id` (`org_id`,`board_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û����ð���¼��';


CREATE TABLE `td_board_sort` (
  `unique_id` varchar(36) NOT NULL COMMENT '�û�ΨһID',
  `sort` text NOT NULL COMMENT '�������',
  PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���������';


CREATE TABLE `td_class` (
  `org_id` varchar(60) NOT NULL DEFAULT '',
  `class_id` varchar(36) NOT NULL DEFAULT '',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `class_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `order_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`org_id`,`class_id`),
  KEY `idx_board` (`board_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='����';


CREATE TABLE `td_label` (
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `label_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��ǩID',
  `label_alias` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��ǩ����',
  `is_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳ��ǩ',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ���ʾ��0.���أ�1.��ʾ��2.�Զ�',
  `color` char(7) DEFAULT NULL COMMENT '������ɫ',
  `bgcolor` char(7) DEFAULT NULL COMMENT '������ɫ',
  `display` tinyint(1) DEFAULT '1' COMMENT 'ʾ�Է�Χ 1.����Web����ʾ 2. ����API�����',
  `total_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '��ͼ����',
  `unread_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'δ��ͼ����',
  `sync_time` int(10) unsigned DEFAULT NULL COMMENT 'ͬ��ʱ��',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '����',
  PRIMARY KEY (`unique_id`,`label_id`),
  UNIQUE KEY `idx_lable_alias` (`unique_id`,`label_alias`),
  KEY `idx_order_num` (`order_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���ǩ';


CREATE TABLE `td_contact` (
  `contact_id` varchar(36) NOT NULL DEFAULT '',
  `unique_id` varchar(36) NOT NULL DEFAULT '',
  `from_user` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ������û�',
  `true_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `pinyin` varchar(255) DEFAULT NULL COMMENT 'ƴ������',
  `email` varchar(255) DEFAULT NULL COMMENT 'email��ַ',
  `mobile` varchar(20) DEFAULT NULL COMMENT '�ֻ�����',
  `properties` text CHARACTER SET utf8 COMMENT '�û��������Լ���,json��ʽ',
  `memo` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '��ע',
  `avatars` blob COMMENT 'ͷ��',
  `avatars_type` varchar(20) DEFAULT NULL COMMENT 'ͷ��MIME����',
  `affinity` int(11) NOT NULL DEFAULT '0' COMMENT '���ܶ�',
  `last_contact_time` int(10) DEFAULT NULL COMMENT '�����ϵʱ��',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ���ʾ',
  `groups` text NOT NULL,
  `temp_is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ݹ����Ƿ����',
  PRIMARY KEY (`contact_id`,`unique_id`),
  KEY `idx_email` (`email`),
  KEY `idx_true_name` (`true_name`),
  KEY `idx_last_contact_time` (`last_contact_time`),
  KEY `idx_is_show` (`is_show`),
  KEY `idx_true_name_email` (`true_name`,`email`),
  KEY `idx_unique_id_show` (`unique_id`,`is_show`),
  KEY `idx_temp_is_done` (`temp_is_done`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_contact_group` (
  `group_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����û�ΨһID',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳȺ��',
  `name` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'Ⱥ������',
  `bgcolor` varchar(10) DEFAULT NULL COMMENT '������ɫ',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '����ID',
  PRIMARY KEY (`unique_id`,`group_id`),
  KEY `idx_is_system` (`is_system`),
  KEY `idx_order_num` (`order_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='��ϵ��Ⱥ��';


CREATE TABLE `td_contact_group_member` (
  `contact_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��ϵ��ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `group_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  PRIMARY KEY (`contact_id`,`group_id`,`unique_id`),
  KEY `fk_member_of_which_group` (`unique_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_tudu_cycle` (
  `cycle_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ID',
  `mode` enum('day','week','month','year') NOT NULL DEFAULT 'day' COMMENT '����ģʽ',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '��������',
  `day` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '��',
  `week` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '��',
  `month` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '��',
  `weeks` varchar(14) NOT NULL DEFAULT '' COMMENT '�����',
  `at` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '�ڼ����� 0 Ϊ���һ������what���',
  `what` enum('day','workday','weekend','sun','mon','tue','wed','thu','fri','sat') DEFAULT NULL COMMENT 'ʲô���ӣ���at��ϣ�������ڶ�����������',
  `period` int(11) NOT NULL DEFAULT '0' COMMENT '�������ڣ���λ��',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '��ִ�д���ͳ��',
  `display_date` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�����Ƿ���ʾ��ʼ����',
  `is_keep_attach` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�̳и���',
  `end_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '�������ͣ�0-�޽������ڣ�1-�ظ�������2-��������',
  `end_count` int(11) NOT NULL DEFAULT '0' COMMENT '�����Ĵ���',
  `end_date` int(11) DEFAULT NULL COMMENT '��������',
  `is_valid` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ���Ч(ɾ����������ʱ����Ϊ��Ч)',
  PRIMARY KEY (`cycle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='��������';


CREATE TABLE `td_tudu` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `class_id` varchar(36) DEFAULT NULL COMMENT '�������ID',
  `cycle_id` varchar(36) DEFAULT NULL COMMENT '����ID',
  `prev_tudu_id` varchar(36) DEFAULT NULL COMMENT 'ǰ������ID',
  `app_id` varchar(128) NOT NULL DEFAULT '^system' COMMENT '���ͳ���ID',
  `flow_id` varchar(36) DEFAULT NULL COMMENT '������ID',
  `step_id` varchar(36) DEFAULT NULL COMMENT '��ǰִ�в���ID',
  `type` enum('task','discuss','notice','meeting') NOT NULL DEFAULT 'task' COMMENT 'ͼ������',
  `subject` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `from` varchar(250) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��ͼ��',
  `to` text CHARACTER SET utf8 COMMENT '��ͼ��',
  `cc` text CHARACTER SET utf8 COMMENT '����',
  `bcc` text CHARACTER SET utf8 COMMENT '����',
  `priority` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ȼ�',
  `privacy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '��˽',
  `is_draft` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ݸ�',
  `is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'ͼ����� - �������ٻظ����޸�',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ɾ�� - δʹ��',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��ö�',
  `need_confirm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���Ҫȷ��',
  `accep_mode` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'ִ�з�ʽ��0.������1.����',
  `last_post_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '���ظ�ʱ��',
  `last_poster` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '���ظ��ߣ�������',
  `last_forward` varchar(255) DEFAULT NULL COMMENT '���ת����Ϣ',
  `view_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '�������',
  `reply_num` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '�ظ���',
  `log_num` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '��־��',
  `cycle_num` int(11) unsigned DEFAULT NULL COMMENT '��������ѭ�����',
  `step_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '��������',
  `start_time` int(10) unsigned DEFAULT NULL COMMENT '��ʼʱ��',
  `end_time` int(10) unsigned DEFAULT NULL COMMENT '����ʱ��',
  `complete_time` int(10) unsigned DEFAULT NULL COMMENT '�������ʱ��',
  `total_time` int(10) unsigned DEFAULT NULL COMMENT 'Ԥ���ܺ�ʱ',
  `elapsed_time` int(10) unsigned DEFAULT NULL COMMENT '�Ѻ�ʱ',
  `accept_time` int(10) unsigned DEFAULT NULL COMMENT '����ʱ��',
  `percent` tinyint(3) unsigned DEFAULT NULL COMMENT '��ɰٷֱ�',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '״̬�� 0-δ��ʼ��1-�����У�2-����ɣ�3-�Ѿܾ��� 4-��ȡ��',
  `special` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1-ѭ������ 2-ͶƱ 4-ͼ����',
  `notify_all` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��������в�����',
  `score` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '����',
  `password` varchar(16) DEFAULT NULL COMMENT '��������',
  `is_auth` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���Ҫ��֤��',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `tudu_index_num` int(10) unsigned DEFAULT NULL COMMENT 'ͼ������ID',
  `tudu_index_num2` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ȫ���������������ID',
  PRIMARY KEY (`tudu_id`),
  UNIQUE KEY `tudu_index_num2` (`tudu_index_num2`),
  UNIQUE KEY `idx_tudu_index_num` (`tudu_index_num`),
  KEY `idx_org_board` (`org_id`,`board_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_last_post_time` (`last_post_time`),
  KEY `idx_from` (`from`),
  KEY `idx_subject` (`subject`),
  KEY `idx_end_time` (`end_time`),
  KEY `idx_to` (`to`(250)),
  KEY `idx_type_status_done` (`type`,`status`,`is_done`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_cycle_id` (`cycle_id`),
  KEY `idx_complete_time` (`complete_time`),
  KEY `idx_flow_id` (`flow_id`),
  CONSTRAINT `fk_tudu_of_which_board` FOREIGN KEY (`org_id`, `board_id`) REFERENCES `td_board` (`org_id`, `board_id`),
  CONSTRAINT `fk_use_which_cycle` FOREIGN KEY (`cycle_id`) REFERENCES `td_tudu_cycle` (`cycle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�������';


CREATE TABLE `td_tudu_group` (
  `tudu_id` varchar(36) NOT NULL DEFAULT '',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����û�ΨһID',
  `parent_tudu_id` varchar(36) DEFAULT NULL COMMENT '��tuduID',
  `root_tudu_id` varchar(36) DEFAULT NULL COMMENT '��ͼ��ID',
  `type` enum('root','node','leaf') NOT NULL DEFAULT 'leaf' COMMENT '�ڵ�����',
  PRIMARY KEY (`tudu_id`),
  KEY `idx_parent_tudu_id` (`parent_tudu_id`),
  CONSTRAINT `group_of _which_tudu` FOREIGN KEY (`tudu_id`) REFERENCES `td_tudu` (`tudu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�����ϵ��';


CREATE TABLE `td_tudu_meeting` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `notify_time` int(11) DEFAULT NULL COMMENT '����ʱ�䣨��ǰN�������ѣ�',
  `notify_type` int(11) NOT NULL DEFAULT '0',
  `location` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '����ص�',
  `is_allday` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ȫ��',
  `is_notified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���ִ������',
  PRIMARY KEY (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='������Ϣ��';


CREATE TABLE `td_vote` (
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `vote_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͶƱID',
  `title` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'ͶƱ����',
  `max_choices` tinyint(3) NOT NULL DEFAULT '0',
  `vote_count` int(11) NOT NULL DEFAULT '0' COMMENT 'ͶƱ�ۻ�����',
  `privacy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '˽�ܣ���������',
  `visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '����Ƿ�ɼ�',
  `is_reset` tinyint(1) NOT NULL DEFAULT '0' COMMENT '����ʱ�Ƿ�����(��0)',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '����ID',
  `expire_time` int(11) DEFAULT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��������ã������˿ɼ�ͶƱ�����ˣ�',
  PRIMARY KEY (`tudu_id`,`vote_id`),
  KEY `idx_tudu_id` (`tudu_id`),
  CONSTRAINT `fk_vote_of_which_tudu` FOREIGN KEY (`tudu_id`) REFERENCES `td_tudu` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_vote_option` (
  `tudu_id` varchar(36) NOT NULL DEFAULT '',
  `vote_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ͶƱID',
  `option_id` varchar(36) NOT NULL DEFAULT '',
  `text` varchar(200) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `order_num` tinyint(3) NOT NULL DEFAULT '0',
  `vote_count` int(11) NOT NULL DEFAULT '0' COMMENT '��Ʊ��',
  `voters` text CHARACTER SET utf8,
  PRIMARY KEY (`option_id`),
  KEY `fk_option_of_which_vote` (`tudu_id`,`vote_id`),
  CONSTRAINT `fk_option_of_which_vote` FOREIGN KEY (`tudu_id`) REFERENCES `td_vote` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_voter` (
  `unique_id` varchar(36) NOT NULL DEFAULT '',
  `tudu_id` varchar(36) NOT NULL DEFAULT '',
  `vote_id` varchar(255) NOT NULL DEFAULT '' COMMENT 'ͶƱID',
  `options` text,
  `create_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tudu_id`,`vote_id`,`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_post` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `email` varchar(128) DEFAULT NULL COMMENT '�����ַ',
  `post_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ظ�ID',
  `poster` varchar(15) CHARACTER SET utf8 DEFAULT NULL COMMENT '�ظ�������',
  `poster_info` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '�ظ�����Ϣ���粿�ż�ְλ��Ϣ��',
  `is_first` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ͼ�����ݣ����Ȼظ��ľ������ݣ�',
  `is_log` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ������־',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��Ѿ�����',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��ⲿ��Ա����',
  `header` varchar(255) CHARACTER SET utf8 DEFAULT '0' COMMENT '�ظ�ͷ��Ϣ',
  `content` mediumtext CHARACTER SET utf8 NOT NULL COMMENT '�ظ�����',
  `last_modify` varchar(80) CHARACTER SET utf8 DEFAULT NULL COMMENT '����޸���Ϣ',
  `attach_num` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '��������',
  `elapsed_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '��ʱ',
  `percent` tinyint(3) unsigned DEFAULT NULL COMMENT '�����',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `temp_is_done` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ݹ����Ƿ����',
  PRIMARY KEY (`tudu_id`,`post_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_unique_id` (`unique_id`),
  KEY `idx_org_board_id` (`org_id`,`board_id`),
  KEY `idx_is_first` (`is_first`,`is_log`),
  KEY `idx_temp_is_done` (`temp_is_done`),
  CONSTRAINT `fk_post_of_which_tudu` FOREIGN KEY (`tudu_id`) REFERENCES `td_tudu` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�ظ���';


CREATE TABLE `td_tudu_user` (
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `step_id` varchar(36) NOT NULL DEFAULT '^trunk' COMMENT '����ID��^trunkָ������',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��ⲿ��Ա',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ��Ѷ�',
  `is_forward` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ת��',
  `labels` text NOT NULL COMMENT '��ǩ��ʶ',
  `mark2` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'ͼ�ȶ��û���ʶ',
  `mark` tinyint(3) NOT NULL DEFAULT '0',
  `role` enum('from','to','cc') DEFAULT NULL COMMENT '��Ա��ɫ',
  `accepter_info` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '��������Ϣ [email] [truename]',
  `percent` tinyint(3) unsigned DEFAULT NULL COMMENT '���˸��½���',
  `tudu_status` tinyint(3) unsigned DEFAULT NULL COMMENT 'ͼ��״̬�� 0-δ��ʼ��1-�����У�2-����ɣ�3-�Ѿܾ�',
  `accept_time` int(10) unsigned DEFAULT NULL COMMENT '����ʱ��',
  `complete_time` int(10) unsigned DEFAULT NULL COMMENT '�������ʱ��',
  `forward_info` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ת������Ϣ truename\\ntime',
  `auth_code` varchar(10) DEFAULT NULL COMMENT '�ⲿ�û���֤��',
  PRIMARY KEY (`unique_id`,`tudu_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_tudu_id` (`tudu_id`),
  KEY `idx_role` (`role`),
  CONSTRAINT `fk_tudu_has_which_user` FOREIGN KEY (`tudu_id`) REFERENCES `td_tudu` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ���û���';


CREATE TABLE `td_template` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ID',
  `template_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ģ��ID',
  `creator` varchar(255) NOT NULL DEFAULT '' COMMENT '������uniqueid',
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ģ������',
  `content` text CHARACTER SET utf8 COMMENT 'ģ������',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '����',
  PRIMARY KEY (`board_id`,`template_id`),
  KEY `idx_creator` (`creator`),
  KEY `idx_org_id` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `td_tudu_label` (
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `label_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��ǩID',
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  PRIMARY KEY (`unique_id`,`label_id`,`tudu_id`),
  KEY `idx_unique_tudu_id` (`unique_id`,`tudu_id`),
  CONSTRAINT `fk_tudu_has_which_label` FOREIGN KEY (`unique_id`, `tudu_id`) REFERENCES `td_tudu_user` (`unique_id`, `tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�ȱ�ǩ��';


CREATE TABLE `td_attachment` (
  `file_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ļ�ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `file_name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '�ļ�����',
  `size` int(11) NOT NULL DEFAULT '0' COMMENT '�ļ���С���ֽڣ�',
  `type` varchar(100) NOT NULL DEFAULT '' COMMENT 'MIME����',
  `path` varchar(100) NOT NULL DEFAULT '' COMMENT '����·��',
  `is_netdisk` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���Դ������',
  `unique_id` varchar(36) DEFAULT NULL COMMENT '�û�ΨһID',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`file_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='������Ϣ��';


CREATE TABLE `td_attach_post` (
  `tudu_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'ͼ��ID',
  `post_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ظ�ID',
  `file_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ļ�ID',
  `is_attach` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`tudu_id`,`post_id`,`file_id`),
  KEY `idx_file_id` (`file_id`),
  KEY `idx_tudu_id` (`tudu_id`),
  CONSTRAINT `fk_attach_of_which_post` FOREIGN KEY (`tudu_id`, `post_id`) REFERENCES `td_post` (`tudu_id`, `post_id`),
  CONSTRAINT `fk_post_has_which_attach` FOREIGN KEY (`file_id`) REFERENCES `td_attachment` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_attach_flow` (
  `flow_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ID',
  `file_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ļ�ID',
  `is_attach` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ񸽼�',
  PRIMARY KEY (`flow_id`,`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���������ݸ���������';


CREATE TABLE `td_flow` (
  `flow_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `board_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�������ID',
  `class_id` varchar(36) DEFAULT NULL COMMENT '��������ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ΨһID',
  `subject` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����������',
  `description` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `avaliable` text NOT NULL COMMENT '������Ⱥ����ʽ userid@orgid\\ngroupid',
  `is_valid` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '�Ƿ����',
  `cc` text CHARACTER SET utf8 NOT NULL COMMENT '�����ˣ���ʽͬ td_tudu.cc',
  `elapsed_time` int(11) DEFAULT NULL COMMENT '����ʱ��(Ԥ�ƺ�ʱ)',
  `content` text CHARACTER SET utf8 COMMENT '����ģ��',
  `steps` text CHARACTER SET utf8 NOT NULL COMMENT '���̣�XML��ʽ�ı�',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`flow_id`),
  KEY `idx_org_id_board_id` (`org_id`,`board_id`),
  KEY `idx_is_valid` (`is_valid`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�����������';


CREATE TABLE `td_flow_favor` (
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `flow_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ID',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Ȩ��',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`,`flow_id`),
  KEY `idx_weight_update_time` (`weight`,`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���ù�����';


CREATE TABLE `td_rule` (
  `rule_id` varchar(36) NOT NULL DEFAULT '',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `description` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '��������������',
  `operation` enum('ignore','starred','label','delete') NOT NULL DEFAULT 'ignore' COMMENT 'ִ�в���',
  `mail_remind` text COMMENT '�ʼ���������',
  `value` varchar(100) DEFAULT '' COMMENT 'ִ�в�����ֵ',
  `is_valid` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ����',
  PRIMARY KEY (`rule_id`),
  KEY `idx_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�ȹ���';


CREATE TABLE `td_rule_filter` (
  `filter_id` varchar(36) NOT NULL DEFAULT '',
  `rule_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ID',
  `what` enum('from','to','cc','subject') NOT NULL DEFAULT 'from' COMMENT 'ƥ�����',
  `type` enum('contain','exclusive','match') NOT NULL DEFAULT 'contain' COMMENT 'ƥ�䷽ʽ, ����������������ȫƥ��',
  `value` text CHARACTER SET utf8 COMMENT '��������',
  `is_valid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ����',
  PRIMARY KEY (`filter_id`),
  KEY `idx_rule_id` (`rule_id`),
  CONSTRAINT `fk_filter_of_which_rule` FOREIGN KEY (`rule_id`) REFERENCES `td_rule` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ͼ�ȹ����������';


CREATE TABLE `nd_file` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ΨһID',
  `file_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�ļ�ID',
  `folder_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ŀ¼ID',
  `file_name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '�ļ���',
  `size` int(11) NOT NULL DEFAULT '0' COMMENT '�ļ���С',
  `type` varchar(100) NOT NULL DEFAULT '' COMMENT 'MIME����',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '·��',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�ļ�״̬ 1.���� 2.ɾ��',
  `attach_file_id` varchar(36) DEFAULT NULL COMMENT '����ID',
  `is_from_attach` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ񱣴��Ը���',
  `from_unique_id` varchar(36) DEFAULT NULL COMMENT '�������û�(�����)',
  `from_file_id` varchar(36) DEFAULT NULL COMMENT 'Դ�ļ�ID',
  `is_share` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���',
  PRIMARY KEY (`org_id`,`unique_id`,`file_id`),
  KEY `idx_folder_id` (`folder_id`),
  KEY `idx_file_name` (`file_name`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_is_from_attach` (`is_from_attach`),
  KEY `idx_file_id` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�����ļ�';


CREATE TABLE `nd_folder` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ΨһID',
  `folder_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ŀ¼ID',
  `parent_folder_id` varchar(36) DEFAULT NULL COMMENT '��Ŀ¼ID',
  `folder_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳĿ¼',
  `is_share` tinyint(3) NOT NULL DEFAULT '0' COMMENT '�Ƿ���',
  `folder_size` int(11) NOT NULL DEFAULT '0' COMMENT '�ļ��ܴ�С',
  `max_quota` int(11) NOT NULL DEFAULT '0' COMMENT '���ÿռ䣨��Ը�Ŀ¼���ã�',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`,`folder_id`),
  KEY `idx_folder_name` (`folder_name`),
  KEY `idx_is_system` (`is_system`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='����Ŀ¼';


CREATE TABLE `nd_share` (
  `object_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����ļ�ID',
  `owner_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����û�ΨһID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `target_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�����û�ID���û�email��ַ��Ⱥ��ʹ��Ⱥ��ID',
  `object_type` enum('folder','file') NOT NULL DEFAULT 'file' COMMENT '�����������',
  `owner_info` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��������Ϣ email\\ntruename',
  PRIMARY KEY (`object_id`,`owner_id`,`target_id`),
  KEY `idx_object_id_object_type` (`object_type`,`object_id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_org_id_target_id` (`target_id`,`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�����ļ���ϵ��';


CREATE TABLE `sph_index_label` (
  `index_id` varchar(255) NOT NULL DEFAULT '',
  `max_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`index_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_log` (
  `log_time` int(10) NOT NULL DEFAULT '0' COMMENT '��־ʱ��',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `target_type` enum('tudu','board','post','cycle','vote') NOT NULL DEFAULT 'tudu' COMMENT '������������',
  `target_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��������ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ΨһID,^system:ϵͳ����',
  `operator` varchar(150) CHARACTER SET utf8 DEFAULT '' COMMENT '��������Ϣ [email ����]',
  `privacy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.���� 1.������',
  `action` varchar(50) DEFAULT '' COMMENT '��������',
  `detail` text CHARACTER SET utf8 COMMENT '������ϸ',
  KEY `idx_object_id` (`org_id`,`target_type`,`target_id`),
  KEY `idx_unique_id` (`unique_id`),
  KEY `idx_privacy` (`privacy`),
  KEY `idx_action` (`action`(1)),
  KEY `idx_log_time` (`log_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `td_note` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `note_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��ǩID',
  `tudu_id` varchar(36) DEFAULT '' COMMENT '������ͼ��ID',
  `content` text CHARACTER SET utf8 NOT NULL COMMENT '����',
  `color` int(11) NOT NULL DEFAULT '0' COMMENT '��ɫ�����ʹ洢',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '״̬ 1.���� 2.ɾ��',
  `is_notify` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�����',
  `notify_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '��������',
  `notify_value` tinyint(11) NOT NULL DEFAULT '0' COMMENT '�������Ͷ�Ӧ��ȡֵ',
  `notify_time` varchar(10) DEFAULT NULL COMMENT '����ʱ��',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `update_time` int(11) DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`unique_id`,`note_id`),
  KEY `idx_org_id` (`org_id`),
  KEY `idx_update_time` (`update_time`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_tudu_id` (`tudu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='��ǩ';




