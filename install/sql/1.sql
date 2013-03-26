CREATE TABLE `md_organization` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `cos_id` int(11) NOT NULL DEFAULT '0' COMMENT '����ȼ�ID',
  `org_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��֯����',
  `ts_id` int(11) NOT NULL DEFAULT '0' COMMENT 'TsID',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '״̬: 0 - ������1 - ��ֹ��2 - ����',
  `is_active` tinyint(3) NOT NULL DEFAULT 1 COMMENT '�Ƿ����',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `expire_date` datetime DEFAULT NULL COMMENT '����ʱ��',
  `logo` blob COMMENT 'LOGO',
  `slogan` varchar(100) DEFAULT NULL COMMENT '��ҵ�ں�',
  `intro` text CHARACTER SET utf8 COMMENT '��ҵ����',
  `footer` text CHARACTER SET utf8,
  `password_level` tinyint(3) NOT NULL DEFAULT '0' COMMENT '���밲ȫ����',
  `lock_time` int(11) NOT NULL DEFAULT '0' COMMENT '��������',
  `timezone` varchar(20) DEFAULT NULL COMMENT 'Ĭ��ʱ��',
  `date_format` varchar(50) DEFAULT NULL COMMENT '���ڸ�ʽ',
  `skin` varchar(10) DEFAULT NULL COMMENT 'Ĭ��Ƥ��',
  `login_skin` varchar(255) DEFAULT NULL COMMENT '��¼ҳ����',
  `default_password` varchar(16) DEFAULT NULL,
  `time_limit` varchar(48) DEFAULT NULL COMMENT '��¼ʱ�����ƣ���ʽ24bit��16������������FFFFFF,FFEFF',
  `is_https` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ�ȫ��ʹ��https',
  `is_ip_rule` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ���IP����',
  `memo` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '��ע����̨�鿴ʹ��',
  PRIMARY KEY (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='��֯��Ϣ��';


CREATE TABLE `md_org_info` (
  `org_id` varchar(60) NOT NULL,
  `entire_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��֯ȫ������ʵ����֤��أ�',
  `industry` varchar(10) DEFAULT NULL,
  `contact` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `fax` varchar(20) DEFAULT NULL COMMENT '�������',
  `province` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ʡ��',
  `city` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `address` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `realname_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'ʵ��״̬ 0.δͨ�� 1.���ύ 2. ��ͨ��',
  PRIMARY KEY (`org_id`),
  KEY `idx_entire_name` (`entire_name`),
  CONSTRAINT `info_of_which_org` FOREIGN KEY (`org_id`) REFERENCES `md_organization` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='��֯��Ϣ��';


CREATE TABLE `md_access` (
  `access_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Ȩ��ID',
  `access_name` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'Ȩ������',
  `value_type` char(1) NOT NULL DEFAULT '' COMMENT 'ֵ������',
  `form_type` char(1) NOT NULL DEFAULT '' COMMENT '��������',
  `default_value` varchar(250) DEFAULT NULL COMMENT 'Ĭ��ֵ',
  PRIMARY KEY (`access_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Ȩ�޶����';
INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (101, '�����ƶ��칫', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (102, '�����Զ���Ƥ��', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (201, '�����������', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (202, '����༭���', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (203, '����ɾ�����', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (204, '����رհ��', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (301, '������ͼ��', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (302, '������ظ�', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (303, '����༭ͼ��', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (304, '����༭�ظ�', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (305, '����ɾ��ͼ��', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (306, '����ɾ���ظ�', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (307, '����ת��ͼ��', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (308, '������ӵ�ͼ����', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (401, '��������/�鿴����', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (402, '����������', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (403, '��󸽼��ߴ�(��λK 1M=1024K)', 'I', 'I', '1024');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (404, 'ÿ����󸽼�����', 'I', 'I', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (501, '����������', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (502, '�����𹫸�', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (503, '������ͶƱ', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (504, '���������', 'B', 'R', '1');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (511, '������������', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (512, '�����޸Ĺ�����', 'B', 'R', '0');

INSERT INTO md_access
   (`access_id`, `access_name`, `value_type`, `form_type`, `default_value`)
VALUES
   (513, '����ɾ��������', 'B', 'R', '0');


CREATE TABLE `md_org_host` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `host` varchar(128) NOT NULL DEFAULT '' COMMENT '������',
  PRIMARY KEY (`org_id`,`host`),
  UNIQUE KEY `idx_host` (`host`),
  KEY `fk_host_of_which_org` (`org_id`),
  CONSTRAINT `fk_host_of_which_org` FOREIGN KEY (`org_id`) REFERENCES `md_organization` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='��֯��������';


CREATE TABLE `md_org_iprule` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '���ͣ�0.����1.��ֹ��',
  `rule` text COMMENT 'IP����',
  `is_valid` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ����',
  `exception` text COMMENT '�����û�/Ⱥ�� address + "\\\\n" + groupid',
  PRIMARY KEY (`org_id`,`type`),
  KEY `idx_is_valid` (`is_valid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ϵͳIP�����б�';


CREATE TABLE `md_department` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `dept_id` varchar(36) NOT NULL DEFAULT '' COMMENT '����ID',
  `dept_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��������',
  `parent_dept_id` varchar(60) DEFAULT NULL COMMENT '�ϼ�����ID',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '�б�������ֵ',
  `moderators` text CHARACTER SET utf8 NOT NULL COMMENT '����������',
  PRIMARY KEY (`org_id`,`dept_id`),
  KEY `idx_dept_list_rank` (`org_id`,`parent_dept_id`,`order_num`),
  CONSTRAINT `fk_dept_of_which_org` FOREIGN KEY (`org_id`) REFERENCES `md_organization` (`org_id`),
  CONSTRAINT `fk_parent_dept` FOREIGN KEY (`org_id`, `parent_dept_id`) REFERENCES `md_department` (`org_id`, `dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='���ű�';


CREATE TABLE `md_group` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `group_id` varchar(60) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  `group_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'Ⱥ������',
  `is_system` tinyint(3) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳȺ��',
  `is_locked` tinyint(3) NOT NULL DEFAULT '0',
  `admin_level` int(11) NOT NULL DEFAULT '0' COMMENT '������',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '��������',
  PRIMARY KEY (`org_id`,`group_id`),
  KEY `idx_order_num` (`order_num`),
  CONSTRAINT `fk_group_of_which_org` FOREIGN KEY (`org_id`) REFERENCES `md_organization` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û�Ⱥ���';


CREATE TABLE `md_role` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `role_id` varchar(60) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  `role_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'Ⱥ������',
  `is_system` tinyint(3) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ϵͳȺ��',
  `is_locked` tinyint(3) NOT NULL DEFAULT '0',
  `admin_level` int(11) NOT NULL DEFAULT '0' COMMENT '������',
  PRIMARY KEY (`org_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='�û�Ⱥ���';


CREATE TABLE `md_role_access` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `role_id` varchar(60) NOT NULL DEFAULT '' COMMENT 'Ȩ����ID',
  `access_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Ȩ��ID',
  `value` varchar(250) DEFAULT NULL COMMENT 'Ȩ��ֵ',
  PRIMARY KEY (`org_id`,`role_id`,`access_id`),
  KEY `fk_group_has_which_access` (`access_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Ⱥ��Ȩ�ޱ�';


CREATE TABLE `md_user` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ψһ��ʶID',
  `dept_id` varchar(36) DEFAULT NULL COMMENT '����ID',
  `cast_id` varchar(36) NOT NULL DEFAULT '^default' COMMENT '��֯�ܹ�ID',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '״̬',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `expire_date` datetime DEFAULT NULL COMMENT '����ʱ��',
  `is_show` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'ͨѶ¼����ʾ',
  `order_num` int(11) NOT NULL DEFAULT '0' COMMENT '�б�������ֵ',
  `unlock_time` int(11) DEFAULT NULL COMMENT '����ʱ��',
  `login_retry` tinyint(3) DEFAULT '0',
  `max_nd_quota` int(11) NOT NULL DEFAULT '0' COMMENT '�������ռ�',
  `init_password` tinyint(1) NOT NULL DEFAULT '0' COMMENT '��ʼ�������ʶ',
  `last_update_time` int(10) unsigned DEFAULT NULL COMMENT '������ʱ��',
  `last_update_time2` int(10) unsigned DEFAULT NULL COMMENT '�û�������ʱ��',
  PRIMARY KEY (`org_id`,`user_id`),
  UNIQUE KEY `ak_unique_id` (`unique_id`),
  KEY `idx_order_num` (`org_id`,`dept_id`,`order_num`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_user_of_which_dept` FOREIGN KEY (`org_id`, `dept_id`) REFERENCES `md_department` (`org_id`, `dept_id`),
  CONSTRAINT `fk_user_of_which_org` FOREIGN KEY (`org_id`) REFERENCES `md_organization` (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���';


CREATE TABLE `md_user_access` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `access_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Ȩ��ID',
  `value` varchar(250) DEFAULT NULL COMMENT 'Ȩ��ֵ',
  PRIMARY KEY (`org_id`,`user_id`,`access_id`),
  KEY `fk_user_has_which_access` (`access_id`),
  CONSTRAINT `fk_access_of_which_user` FOREIGN KEY (`org_id`, `user_id`) REFERENCES `md_user` (`org_id`, `user_id`),
  CONSTRAINT `fk_user_has_which_access` FOREIGN KEY (`access_id`) REFERENCES `md_access` (`access_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û��Զ���Ȩ�ޱ�';


CREATE TABLE `md_user_info` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `true_name` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '��ʵ����',
  `pinyin` varchar(50) DEFAULT NULL COMMENT 'ƴ����д',
  `password` varchar(80) DEFAULT NULL COMMENT '�û�����',
  `position` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ְλ',
  `industry` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '��ҵ�����ڰ棩',
  `nick` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '�ǳ�',
  `avatars` blob COMMENT 'ͷ��',
  `avatars_type` varchar(30) DEFAULT NULL COMMENT 'ͷ���ʽ',
  `gender` tinyint(3) DEFAULT NULL COMMENT '�Ա�',
  `id_number` varchar(50) DEFAULT NULL COMMENT '֤������',
  `birthday` datetime DEFAULT NULL COMMENT '��������',
  `mobile` varchar(30) DEFAULT NULL COMMENT '�ֻ�����',
  `tel` varchar(50) DEFAULT NULL COMMENT '�̶��绰',
  `email` varchar(128) DEFAULT NULL COMMENT '�û�����',
  `office_location` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '�����ص�',
  `sign` varchar(30) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ǩ��',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '������Ϣ����ʱ��',
  `province` varchar(20) CHARACTER SET utf8 DEFAULT '' COMMENT 'ʡ��',
  `city` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '����',
  PRIMARY KEY (`org_id`,`user_id`),
  CONSTRAINT `fk_user_info` FOREIGN KEY (`org_id`, `user_id`) REFERENCES `md_user` (`org_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���Ϣ��';


CREATE TABLE `md_user_data` (
  `org_id` varchar(60) NOT NULL DEFAULT '',
  `user_id` varchar(60) NOT NULL DEFAULT '',
  `im` blob,
  `skin` varchar(10) DEFAULT NULL,
  `timezone` varchar(20) DEFAULT NULL COMMENT 'ʱ��',
  `language` varchar(20) DEFAULT NULL COMMENT '����',
  `pagesize` int(11) NOT NULL DEFAULT '25' COMMENT 'ÿҳ��ʾͼ����',
  `date_format` varchar(24) CHARACTER SET utf8 DEFAULT NULL COMMENT '���ڸ�ʽ',
  `profile_mode` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'tudu�ظ��û���Ϣ��ʾģʽ',
  `expired_filter` int(11) NOT NULL DEFAULT '0' COMMENT '����x��tudu������ʾ',
  `post_sort` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�ظ��鿴˳��0. ˳��,1. ����',
  `settings` text COMMENT '��������',
  `enable_search` tinyint(1) NOT NULL DEFAULT '3' COMMENT '������� 1.enable uid, 2.enable nick, 1|2 both',
  `enable_buddy` tinyint(1) NOT NULL DEFAULT '1' COMMENT '�Ƿ�������Ӻ���',
  `usual_local` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '���õ�ַ',
  PRIMARY KEY (`org_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û�����';


CREATE TABLE `md_user_email` (
  `org_id` varchar(60) NOT NULL,
  `user_id` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  PRIMARY KEY (`org_id`,`user_id`),
  UNIQUE KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û�������';


CREATE TABLE `md_user_group` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `group_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  PRIMARY KEY (`org_id`,`user_id`,`group_id`),
  KEY `fk_user_has_which_group` (`org_id`,`group_id`),
  CONSTRAINT `fk_group_of_which_user` FOREIGN KEY (`org_id`, `user_id`) REFERENCES `md_user` (`org_id`, `user_id`),
  CONSTRAINT `fk_user_has_which_group` FOREIGN KEY (`org_id`, `group_id`) REFERENCES `md_group` (`org_id`, `group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���ӦȺ���';


CREATE TABLE `md_user_role` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `role_id` varchar(36) NOT NULL DEFAULT '' COMMENT 'Ⱥ��ID',
  PRIMARY KEY (`org_id`,`user_id`,`role_id`),
  KEY `fk_user_has_which_group` (`org_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='�û���ӦȺ���';


CREATE TABLE `md_user_session` (
  `session_id` varchar(32) NOT NULL COMMENT '�ỰID',
  `org_id` varchar(60) NOT NULL COMMENT '��֯ID',
  `user_id` varchar(16) NOT NULL COMMENT '�û�ID',
  `login_ip` varchar(20) DEFAULT NULL COMMENT '��¼ʱ��IP��ַ',
  `login_time` int(11) unsigned NOT NULL COMMENT '��¼ʱ��',
  `expire_time` int(11) unsigned DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û��־õ�¼��֤��Ϣ��¼';


CREATE TABLE `md_user_tips` (
  `unique_id` varchar(36) NOT NULL DEFAULT '',
  `tips_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��ʾ��Ϣ��ʶ',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '״̬ 0.δ�� 1.�Ѷ�',
  PRIMARY KEY (`unique_id`,`tips_id`),
  KEY `idx_md_user_tips_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='�û���ʾ��Ϣ';


CREATE TABLE `md_site_admin` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�û�ID',
  `admin_type` char(3) NOT NULL DEFAULT '' COMMENT '��������',
  `admin_level` tinyint(3) NOT NULL DEFAULT '0' COMMENT '������',
  PRIMARY KEY (`org_id`,`user_id`),
  CONSTRAINT `fk_who_is_admin` FOREIGN KEY (`org_id`, `user_id`) REFERENCES `md_user` (`org_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='վ�����Ա��';


CREATE TABLE `md_cast_disable_dept` (
  `org_id` varchar(60) NOT NULL DEFAULT '',
  `owner_id` varchar(36) NOT NULL DEFAULT '' COMMENT '������ID',
  `dept_id` varchar(36) NOT NULL DEFAULT '' COMMENT '���ɼ�����ID',
  PRIMARY KEY (`org_id`,`owner_id`,`dept_id`),
  KEY `idx_owner_id` (`org_id`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `md_cast_disable_user` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `owner_id` varchar(255) NOT NULL DEFAULT '' COMMENT '������ID',
  `user_id` varchar(255) NOT NULL DEFAULT '' COMMENT '���ɼ��û���',
  PRIMARY KEY (`org_id`,`owner_id`,`user_id`),
  KEY `idx_owner_id` (`org_id`,`owner_id`),
  KEY `idx_org_id_user_id` (`org_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `md_email` (
  `org_id` varchar(60) NOT NULL DEFAULT '',
  `user_id` varchar(36) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '�ʼ���ַ',
  `password` varchar(50) NOT NULL DEFAULT '' COMMENT '��������',
  `protocol` enum('imap','pop3') NOT NULL DEFAULT 'imap' COMMENT 'Э������',
  `imap_host` varchar(200) NOT NULL DEFAULT '' COMMENT '������',
  `port` int(6) DEFAULT NULL COMMENT '���Ӷ˿�',
  `is_ssl` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�ʹ��SSL����',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�������� 0.�������� 1.����� 2.������ҵ����',
  `is_notify` tinyint(1) NOT NULL DEFAULT '0' COMMENT '�Ƿ�������',
  `last_check_info` varchar(200) DEFAULT NULL COMMENT '������¼��Ϣ δ����\\n����MID\\n��������',
  `last_check_time` int(10) DEFAULT NULL COMMENT '�����ʱ��',
  `order_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`org_id`,`user_id`,`address`),
  KEY `idx_org_id_user_id` (`org_id`,`user_id`),
  KEY `idx_order_num` (`order_num`),
  CONSTRAINT `fk_email_of_which_user` FOREIGN KEY (`org_id`, `user_id`) REFERENCES `md_user` (`org_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `md_login_log` (
  `login_log_id` varchar(36) NOT NULL DEFAULT '' COMMENT '��־ID',
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `unique_id` varchar(36) NOT NULL DEFAULT '' COMMENT '�û�ΨһID',
  `address` varchar(120) NOT NULL DEFAULT '' COMMENT '�ʺ�(email��ַ��ʽ)',
  `truename` varchar(60) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '����',
  `ip` varchar(15) DEFAULT NULL COMMENT 'ip��ַ',
  `local` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '����λ��',
  `isp` varchar(50) DEFAULT NULL COMMENT '��Ӫ��',
  `clientkey` varchar(50) DEFAULT '' COMMENT '�ͻ��˵�¼��ʶ',
  `client_info` varchar(255) NOT NULL DEFAULT '' COMMENT '�ͻ�����Ϣ��BROWSER\\\\\\\\\\\\\\\\nSYSTEM',
  `create_time` int(10) NOT NULL DEFAULT '0' COMMENT '��¼ʱ��',
  PRIMARY KEY (`login_log_id`),
  KEY `idx_org_id_unique_id` (`org_id`,`unique_id`),
  KEY `idx_address` (`address`),
  KEY `idx_truename` (`truename`),
  KEY `idx_ip` (`ip`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_org_id_unique_id_create_time` (`org_id`,`unique_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='ǰ̨�û���¼��־';


CREATE TABLE `md_op_log` (
  `org_id` varchar(60) NOT NULL DEFAULT '' COMMENT '��֯ID',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '����ʱ��',
  `user_id` varchar(60) NOT NULL DEFAULT '' COMMENT '�����û�',
  `ip` varchar(50) DEFAULT NULL COMMENT '����IP',
  `local` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '���ڵ�',
  `module` enum('user','group','dept','cast','board','login','role','secure','org') DEFAULT NULL,
  `action` enum('create','update','delete','login','logout') DEFAULT NULL,
  `sub_action` varchar(255) DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `status` tinyint(3) NOT NULL DEFAULT '0',
  `detail` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '�������ݣ�PHP serialize ��ʽ',
  KEY `idx_org_id` (`org_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_module` (`module`),
  KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `md_ip_data` (
  `start_ip` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '��ʼIP',
  `end_ip` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '��ֹIP',
  `province` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ʡ��',
  `city` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `isp` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ISP����',
  KEY `idx_start_ip` (`start_ip`),
  KEY `idx_end_ip` (`end_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='IP���ݵ�ַ��';

