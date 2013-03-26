
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_md_cast_hide_dept`//
CREATE PROCEDURE `sp_md_cast_hide_dept`(in_org_id varchar(60), in_owner_id varchar(60), in_dept_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



# ������

INSERT IGNORE INTO md_cast_disable_dept (org_id, owner_id, dept_id) VALUES (in_org_id, in_owner_id, in_dept_id);


# �Է��鿴

INSERT IGNORE INTO md_cast_disable_user (org_id, owner_id, user_id) 

       SELECT in_org_id, in_owner_id, user_id FROM md_user WHERE org_id = in_org_id AND dept_id = in_dept_id;


END//


DROP PROCEDURE IF EXISTS `sp_md_cast_hide_user`//
CREATE PROCEDURE `sp_md_cast_hide_user`(in_org_id varchar(60), in_owner_id varchar(60), in_user_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



# ������

INSERT IGNORE INTO md_cast_disable_user (org_id, owner_id, user_id) VALUES (in_org_id, in_owner_id, in_user_id);


# �Է��鿴

INSERT IGNORE INTO md_cast_disable_user (org_id, owner_id, user_id) VALUES (in_org_id, in_user_id, in_owner_id);


END//


DROP PROCEDURE IF EXISTS `sp_md_cast_show_user`//
CREATE PROCEDURE `sp_md_cast_show_user`(in_org_id varchar(60), in_owner_id varchar(60), in_user_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



# ������

DELETE FROM md_cast_disable_user WHERE org_id = in_org_id AND owner_id = in_owner_id AND user_id = in_user_id;



# �Է��鿴

DELETE FROM md_cast_disable_user WHERE org_id = in_org_id AND owner_id = in_user_id AND user_id = in_owner_id;



END//


DROP PROCEDURE IF EXISTS `sp_md_cast_update_dept`//
CREATE PROCEDURE `sp_md_cast_update_dept`(in_org_id varchar(60), in_user_id varchar(60), in_dept_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# �޸��û�����ʱ��������û��Ĳ��ſɼ���



DECLARE user_eof tinyint(1) DEFAULT 0;

DECLARE temp_user_id varchar(60);



DECLARE user_cur CURSOR FOR SELECT user_id FROM md_user WHERE org_id = in_org_id AND user_id NOT IN (SELECT owner_id FROM md_cast_disable_user WHERE org_id = in_org_id AND user_id = in_user_id);

DECLARE CONTINUE HANDLER FOR NOT FOUND SET user_eof = 1;



SET user_eof = 0;



OPEN user_cur;



REPEAT

      FETCH user_cur INTO temp_user_id;



      DELETE FROM md_cast_disable_dept WHERE org_id = in_org_id AND owner_id = temp_user_id AND dept_id = in_dept_id;



UNTIL user_eof = 1 END REPEAT;



CLOSE user_cur;



END//


DROP PROCEDURE IF EXISTS `sp_md_delete_user`//
CREATE PROCEDURE `sp_md_delete_user`(in_org_id varchar(60), in_user_id varchar(60))
    SQL SECURITY INVOKER
BEGIN

# ɾ��email��

DELETE FROM md_email WHERE org_id = in_org_id AND user_id = in_user_id;

# ɾ��Ȩ�޹���

DELETE FROM md_user_role WHERE org_id = in_org_id AND user_id = in_user_id;

DELETE FROM md_user_access WHERE org_id = in_org_id AND user_id = in_user_id;

# ɾ��Ⱥ�����

DELETE FROM md_user_group WHERE org_id = in_org_id AND user_id = in_user_id;

# ��Ʒ

DELETE FROM md_user_product WHERE org_id = in_org_id AND user_id = in_user_id;

# ������Ÿ�����

UPDATE md_department SET moderators = TRIM(TRAILING ',' FROM REPLACE(CONCAT(moderators, ','), CONCAT(',', in_user_id, ','), ','))

WHERE org_id = in_org_id AND moderators LIKE CONCAT('%,',in_user_id,'%');

# ɾ����֯�ܹ�����

DELETE FROM md_cast_disable_dept WHERE org_id = in_org_id AND owner_id = in_user_id;

DELETE FROM md_cast_disable_user WHERE (org_id = in_org_id AND owner_id = in_user_id) OR (org_id = in_org_id AND user_id = in_user_id);

# վ�����Ա

DELETE FROM md_site_admin WHERE org_id = in_org_id AND user_id = in_user_id;

DELETE FROM md_user_device WHERE org_id = in_org_id AND unique_id = (SELECT unique_id FROM md_user WHERE org_id = in_org_id AND user_id = in_user_id);

# ɾ���û�����

DELETE FROM md_user_data WHERE org_id = in_org_id AND user_id = in_user_id;

DELETE FROM md_user_info WHERE org_id = in_org_id AND user_id = in_user_id;

DELETE FROM md_user WHERE org_id = in_org_id AND user_id = in_user_id;

END//


DROP PROCEDURE IF EXISTS `sp_md_user_add_group`//
CREATE PROCEDURE `sp_md_user_add_group`(in_org_id varchar(60), in_user_id varchar(60), in_group_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



# ����û���Ⱥ��

INSERT INTO md_user_group(org_id, user_id, group_id) VALUES(in_org_id, in_user_id, in_group_id);


# �����û���Ϣ

UPDATE md_user SET groups = CONCAT(IFNULL(groups, ''), ',', in_group_id) WHERE org_id = in_org_id AND user_id = in_user_id;


END//


DROP PROCEDURE IF EXISTS `sp_md_user_delete_group`//
CREATE PROCEDURE `sp_md_user_delete_group`(in_org_id varchar(60), in_user_id varchar(60), in_group_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



# ����û���Ⱥ��

DELETE FROM md_user_group WHERE org_id = in_org_id AND user_id = in_user_id AND group_id = in_group_id;



# �����û���Ϣ

UPDATE md_user SET groups = TRIM(TRAILING ',' FROM REPLACE(CONCAT(groups, ','), CONCAT(',', in_group_id, ','), ',')) 

WHERE org_id = in_org_id AND user_id = in_user_id;



END//


DELIMITER ;