DELIMITER //

# Procedure "sp_nd_add_file" DDL
DROP PROCEDURE IF EXISTS `sp_nd_add_file`//
CREATE PROCEDURE  `sp_nd_add_file`(in_org_id varchar(60), in_unique_id varchar(36), in_file_id varchar(36), in_folder_id varchar(36), in_path varchar(255), in_file_name varchar(255) charset utf8, in_file_size int(11), in_file_type varchar(100))
    SQL SECURITY INVOKER
BEGIN

DECLARE use_quota int(11) DEFAULT 0;

DECLARE root_max_quota int(11) DEFAULT 0;

DECLARE to_folder_id varchar(36);



SET to_folder_id = in_folder_id;



# ��ʹ�ÿռ�

SELECT IFNULL(SUM(size), 0) INTO use_quota FROM nd_file WHERE org_id = in_org_id AND unique_id = in_unique_id;



# �����ÿռ䣬��Ŀ¼���ÿռ�

SELECT max_quota INTO root_max_quota FROM nd_folder WHERE org_id = in_org_id AND unique_id = in_unique_id AND folder_id = '^root';



IF (root_max_quota <= 0 OR use_quota + in_file_size > root_max_quota) THEN

     SELECT -1;

ELSE

    IF NOT EXISTS (SELECT folder_id FROM nd_folder WHERE org_id = in_org_id AND unique_id = in_unique_id AND folder_id = to_folder_id) THEN

       SET to_folder_id = '^root';

    END IF;



    INSERT INTO nd_file (org_id, unique_id, file_id, folder_id, file_name, size, type, path, create_time) VALUES 

    (in_org_id, in_unique_id, in_file_id, to_folder_id, in_file_name, in_file_size, in_file_type, in_path, UNIX_TIMESTAMP());

    

    UPDATE nd_folder SET folder_size = use_quota + in_file_size WHERE org_id = in_org_id AND unique_id = in_unique_id AND folder_id = '^root';

    

    SELECT 1;

END IF;

END//


# Procedure "sp_nd_delete_file" DDL
DROP PROCEDURE IF EXISTS  `sp_nd_delete_file`//
CREATE PROCEDURE  `sp_nd_delete_file`(in_unique_id varchar(60), in_file_id varchar(60))
    SQL SECURITY INVOKER
BEGIN



DELETE FROM nd_file WHERE unique_id = in_unique_id AND file_id = in_file_id;



UPDATE nd_folder SET folder_size = (SELECT SUM(`size`) FROM nd_file WHERE unique_id = in_unique_id) WHERE unique_id = in_unique_id AND folder_id = '^root';



END//


# Procedure "sp_td_add_group_member" DDL
DROP PROCEDURE IF EXISTS  `sp_td_add_group_member`//
CREATE PROCEDURE  `sp_td_add_group_member`(in in_group_id varchar(36), in in_unique_id varchar(36), in in_contact_id varchar(36))
    SQL SECURITY INVOKER
BEGIN


# ���ӱ�ǩ

INSERT INTO td_contact_group_member(group_id, unique_id, contact_id) VALUES(in_group_id, in_unique_id, in_contact_id);


UPDATE td_contact SET groups = CONCAT(groups, ',', in_group_id) WHERE unique_id = in_unique_id AND contact_id = in_contact_id;


END//


# Procedure "sp_td_add_tudu_label" DDL
DROP PROCEDURE IF EXISTS  `sp_td_add_tudu_label`//
CREATE PROCEDURE  `sp_td_add_tudu_label`(in in_tudu_id varchar(36), in in_unique_id varchar(36), in in_label_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

# ����ͼ�ȱ�ǩ



DECLARE unread int;



# ��ȡδ�������������ɸ��ݴ���ֵ�ж��û�������¼����

SELECT IF(is_read=0,1,0) INTO unread FROM td_tudu_user WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



#  ������¼����ʱ�Ž��и���

IF NOT unread IS NULL THEN



	# ���ӱ�ǩ

	INSERT INTO td_tudu_label(unique_id, label_id, tudu_id) VALUES(in_unique_id, in_label_id, in_tudu_id);



	# ��������

	UPDATE td_label SET total_num = total_num + 1, unread_num = unread_num + unread, sync_time = UNIX_TIMESTAMP() 

		WHERE unique_id = in_unique_id AND label_id = in_label_id;



	# ���±�ʶ

	UPDATE td_tudu_user SET labels = CONCAT(labels, ',', in_label_id) WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



END IF;



END//


# Procedure "sp_td_calculate_label" DDL
DROP PROCEDURE IF EXISTS  `sp_td_calculate_label`//
CREATE PROCEDURE  `sp_td_calculate_label`(in in_unique_id varchar(36), in in_label_id varchar(32))
    SQL SECURITY INVOKER
BEGIN



DECLARE total int(11) unsigned;

DECLARE unread int(11) unsigned;



SET total = (SELECT COUNT(tu.unique_id) FROM td_tudu_label tl LEFT JOIN td_tudu_user tu ON tl.unique_id = tu.unique_id AND tl.tudu_id = tu.tudu_id WHERE tl.unique_id = in_unique_id AND tl.label_id = in_label_id),

    unread = (SELECT COUNT(tu.unique_id) FROM td_tudu_label tl LEFT JOIN td_tudu_user tu ON tl.unique_id = tu.unique_id AND tl.tudu_id = tu.tudu_id WHERE tl.unique_id = in_unique_id AND tl.label_id = in_label_id AND is_read = 0);



UPDATE td_label SET total_num = total, unread_num = unread WHERE unique_id = in_unique_id AND label_id = in_label_id;



END//



# Procedure "sp_td_calculate_parents_progress" DDL
DROP PROCEDURE IF EXISTS `sp_td_calculate_parents_progress`//
CREATE PROCEDURE `sp_td_calculate_parents_progress`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ���¸���ͼ�������

#

#



DECLARE curr_tudu_id varchar(36);

DECLARE temp_percent int(11);

DECLARE temp_elapsed_time int(11);

DECLARE accepter_eof tinyint(1) DEFAULT 0;

DECLARE accepter_percent int(11);

DECLARE accepter_elapsed_time int(11);

DECLARE temp_unique_id varchar(36);

DECLARE temp_tudu_id varchar(36);



DECLARE accepter_cur CURSOR FOR SELECT unique_id FROM td_tudu_user WHERE tudu_id = curr_tudu_id AND `role` = 'to';

DECLARE CONTINUE HANDLER FOR NOT FOUND SET accepter_eof = 1;



SET curr_tudu_id = in_tudu_id;



REPEAT



## ͳ�Ƹ�ִ���˽���

SET accepter_eof = 0;



OPEN accepter_cur;



REPEAT

      

      FETCH accepter_cur INTO temp_unique_id;

      

      IF EXISTS (SELECT tudu_id FROM td_tudu_group WHERE unique_id = temp_unique_id AND parent_tudu_id = curr_tudu_id) THEN

         

         SELECT AVG(IFNULL(percent, 0)) INTO accepter_percent

         FROM td_tudu AS t LEFT JOIN td_tudu_group AS tg ON t.tudu_id = tg.tudu_id 

         WHERE tg.parent_tudu_id = curr_tudu_id AND t.`status` <= 2 AND tg.unique_id = temp_unique_id;

         

         UPDATE td_tudu_user SET percent = accepter_percent,

         tudu_status = IF(accepter_percent >= 100, 2, IF(accepter_percent > 0, 1, 0))

         WHERE tudu_id = curr_tudu_id AND unique_id = temp_unique_id;

         

      END IF;

      

UNTIL accepter_eof END REPEAT;



CLOSE accepter_cur;



## ͳ��ִ���˸�������

IF EXISTS (SELECT tudu_id FROM td_tudu_user WHERE tudu_id = curr_tudu_id AND `role` = 'to') THEN

   SELECT AVG(IFNULL(percent, 0)) INTO temp_percent FROM td_tudu_user WHERE tudu_id = curr_tudu_id AND `role` = 'to' AND tudu_status <= 2;

ELSE

    SELECT AVG(IFNULL(percent, 0)) INTO temp_percent FROM td_tudu AS t LEFT JOIN td_tudu_group AS g ON t.tudu_id = g.tudu_id

    WHERE g.parent_tudu_id = curr_tudu_id AND t.`status` <= 2;

END IF;



## ͳ���Ӽ���

SELECT SUM(elapsed_time) INTO temp_elapsed_time FROM td_tudu AS t 

LEFT JOIN td_tudu_group AS tg ON t.tudu_id = tg.tudu_id 

WHERE tg.parent_tudu_id = curr_tudu_id;



SET temp_elapsed_time = temp_elapsed_time + (

    SELECT IFNULL(SUM(elapsed_time), 0) FROM td_post WHERE tudu_id = curr_tudu_id AND is_log = 1

);



## ���¸���ͼ��

UPDATE td_tudu SET 

percent = temp_percent,

elapsed_time = temp_elapsed_time,

`status`= IF(temp_percent >= 100, 2, IF(temp_percent > 0, 1, 0)),

complete_time = IF(temp_percent >= 100, UNIX_TIMESTAMP(), NULL)

WHERE tudu_id = curr_tudu_id;



## ����δ��״̬

call sp_td_mark_all_unread(curr_tudu_id);



## �Ƿ�����ϼ�ͼ��

SELECT parent_tudu_id INTO temp_tudu_id FROM td_tudu_group WHERE tudu_id = curr_tudu_id AND parent_tudu_id <> curr_tudu_id;

IF temp_tudu_id = curr_tudu_id OR temp_tudu_id IS NULL OR temp_tudu_id = '' THEN

   ## ����ѭ��

   SET curr_tudu_id = NULL;

ELSE

    ## ��ʶ��һ��

    SET curr_tudu_id = temp_tudu_id;

END IF;



UNTIL curr_tudu_id IS NULL END REPEAT;



END//



# Procedure "sp_td_calculate_tudu_elapsed_time" DDL
DROP PROCEDURE IF EXISTS `sp_td_calculate_tudu_elapsed_time`//
CREATE PROCEDURE `sp_td_calculate_tudu_elapsed_time`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE in_elapsed_time int(11);



START TRANSACTION;



SET in_elapsed_time = (SELECT IFNULL(SUM(elapsed_time), 0) FROM td_post WHERE tudu_id = in_tudu_id AND is_first = 0 AND is_log = 1 AND is_send = 1 FOR UPDATE);

SET in_elapsed_time = in_elapsed_time + (

    SELECT IFNULL(SUM(elapsed_time), 0) FROM td_tudu AS t LEFT JOIN td_tudu_group AS g ON t.tudu_id = g.tudu_id

    WHERE parent_tudu_id = in_tudu_id FOR UPDATE

);



UPDATE td_tudu SET elapsed_time = in_elapsed_time

WHERE tudu_id = in_tudu_id;



COMMIT;



END//



# Procedure "sp_td_calculate_tudu_reply" DDL
DROP PROCEDURE IF EXISTS `sp_td_calculate_tudu_reply`//
CREATE PROCEDURE `sp_td_calculate_tudu_reply`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE reply int(11);

DECLARE log int(11);



SET reply = (SELECT COUNT(*) FROM td_post WHERE tudu_id = in_tudu_id AND is_first = 0),

       log = (SELECT COUNT(*) FROM td_post WHERE tudu_id = in_tudu_id AND is_log = 1 AND is_first = 0);



UPDATE td_tudu SET reply_num = reply, log_num = log WHERE tudu_id = in_tudu_id;



END//



# Procedure "sp_td_clear_board" DDL
DROP PROCEDURE IF EXISTS `sp_td_clear_board`//
CREATE PROCEDURE `sp_td_clear_board`(oid VARCHAR(60), bid VARCHAR(60))
BEGIN

DECLARE unid varchar(36);

DECLARE eof tinyint(1) DEFAULT 0;

DECLARE user_cur CURSOR FOR SELECT DISTINCT u.unique_id FROM td_tudu_user u LEFT JOIN td_tudu t ON t.tudu_id = u.tudu_id WHERE t.board_id = bid;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET eof = 1;



# ����ͳ��ͼ�ȹ�����Ա�ı�ǩ

OPEN user_cur;



REPEAT 



       FETCH user_cur INTO unid;

       UPDATE td_label SET total_num = (

              SELECT COUNT(0) FROM td_tudu_label l 

              LEFT JOIN td_tudu t ON l.tudu_id = t.tudu_id 

              WHERE l.unique_id = unid AND l.label_id = td_label.label_id AND t.board_id <> bid

       ),

       unread_num = (

              SELECT COUNT(0) FROM td_tudu_label l 

              LEFT JOIN td_tudu t ON l.tudu_id = t.tudu_id 

              LEFT JOIN td_tudu_user tu ON l.tudu_id = tu.tudu_id

              WHERE l.unique_id = unid AND l.label_id = td_label.label_id AND t.board_id <> bid AND tu.is_read = 0

       ),

       sync_time = UNIX_TIMESTAMP()

       WHERE unique_id = unid;

       

UNTIL eof END REPEAT;



CLOSE user_cur;



# ɾ������

DELETE FROM td_attachment WHERE file_id IN (SELECT file_id FROM td_attach_post ap LEFT JOIN td_post p ON ap.post_id = p.post_id WHERE p.org_id = oid AND p.board_id = bid);

DELETE FROM td_attach_post WHERE post_id IN (SELECT post_id FROM td_post WHERE org_id = oid AND board_id = bid);



# ɾ���ظ�

DELETE FROM td_post WHERE org_id = oid AND board_id = bid;



# ɾ��ͶƱ

DELETE FROM td_vote_option WHERE tudu_id IN (SELECT tudu_id FROM td_tudu WHERE org_id = oid AND board_id = bid);

DELETE FROM td_voter WHERE tudu_id IN (SELECT tudu_id FROM td_tudu WHERE org_id = oid AND board_id = bid);

DELETE FROM td_vote WHERE tudu_id IN (SELECT tudu_id FROM td_tudu WHERE org_id = oid AND board_id = bid);



# ɾ���������ͼ��

DELETE FROM td_tudu_label WHERE tudu_id IN (SELECT tudu_id FROM td_tudu WHERE org_id = oid AND board_id = bid);

DELETE FROM td_tudu_user WHERE tudu_id IN (SELECT tudu_id FROM td_tudu WHERE org_id = oid AND board_id = bid);

DELETE FROM td_tudu WHERE org_id = oid AND board_id = bid;



# ͳ�ư����Ϣ

UPDATE td_board SET tudu_num = 0, post_num = 0, today_tudu_num = 0, last_post = NULL WHERE org_id = oid AND board_id = bid;



END//



# Procedure "sp_td_delete_contact_group" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_contact_group`//
CREATE PROCEDURE `sp_td_delete_contact_group`(in in_group_id varchar(36), in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ɾ��Ⱥ���Ա

UPDATE td_contact AS c 

LEFT JOIN td_contact_group_member AS gm ON c.contact_id = gm.contact_id AND c.unique_id = gm.unique_id

SET c.groups = TRIM(TRAILING ',' FROM REPLACE(CONCAT(groups, ','), CONCAT(',', in_group_id, ','), ',')) 

WHERE c.unique_id = in_unique_id AND gm.group_id = in_group_id;



DELETE FROM td_contact_group_member WHERE group_id = in_group_id AND unique_id = in_unique_id;

# ɾ��Ⱥ��

DELETE FROM td_contact_group WHERE group_id = in_group_id AND unique_id = in_unique_id;



END//



# Procedure "sp_td_delete_cycle" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_cycle`//
CREATE PROCEDURE `sp_td_delete_cycle`(in in_cycle_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ȡ��ͼ�ȹ���

#UPDATE td_tudu SET cycle_id = null WHERE cycle_id = in_cycle_id;



# ɾ������

#DELETE FROM td_tudu_cycle WHERE cycle_id = in_cycle_id;

UPDATE td_tudu_cycle SET is_valid = 0 WHERE cycle_id = in_cycle_id;



END//



# Procedure "sp_td_delete_group_member" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_group_member`//
CREATE PROCEDURE `sp_td_delete_group_member`(in in_group_id varchar(36), in in_unique_id varchar(36), in in_contact_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ���ӱ�ǩ

DELETE FROM td_contact_group_member WHERE group_id = in_group_id AND unique_id = in_unique_id AND contact_id = in_contact_id;



# ���±�ʶ

UPDATE td_contact SET groups = TRIM(TRAILING ',' FROM REPLACE(CONCAT(groups, ','), CONCAT(',', in_group_id, ','), ',')) 

WHERE unique_id = in_unique_id AND contact_id = in_contact_id;



END//



# Procedure "sp_td_delete_post" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_post`//
CREATE PROCEDURE `sp_td_delete_post`(in in_tudu_id varchar(36), in in_post_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ɾ���ظ�

#

# is_first�ļ�¼��ͨ���˷�ʽɾ��



DECLARE `in_log_num` tinyint(1);

DECLARE `in_is_send` tinyint(1);



# ��ȡ������ݣ�������Ҫ֪���Ƿ������־��ظ�������selectһ�Σ�������Բ���Ҫ

SELECT IF(`is_log` = 1, 1, 0), IF(`is_send` = 1, 1, 0) INTO `in_log_num`, `in_is_send` FROM td_post

WHERE tudu_id = in_tudu_id AND post_id = in_post_id AND is_first = 0;



# ���ݴ���ʱ�Ž��и���

IF NOT in_log_num IS NULL THEN



# ɾ������

DELETE FROM td_attach_post WHERE tudu_id = in_tudu_id AND post_id = in_post_id;



# ɾ���ظ�

DELETE FROM td_post WHERE tudu_id = in_tudu_id AND post_id = in_post_id;



# ɾ���ɹ�ʱ�Ÿ���ͳ��

IF ROW_COUNT() > 0 AND `in_is_send` = 1 THEN



   # ���°��ظ���ͳ��

   UPDATE td_board, td_tudu

   SET td_board.post_num = td_board.post_num - 1,

   reply_num = reply_num - 1,

   log_num = log_num - in_log_num

   WHERE td_board.org_id = td_tudu.org_id AND td_board.board_id = td_tudu.board_id

   AND td_tudu.tudu_id = in_tudu_id;

   

   # ���������Ѻ�ʱͳ��

   IF `in_log_num` = 1 THEN

      call sp_td_calculate_tudu_elapsed_time(`in_tudu_id`);

   END IF;

END IF;



END IF;



END//



# Procedure "sp_td_delete_tudu" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_tudu`//
CREATE PROCEDURE `sp_td_delete_tudu`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



#

# ɾ������

#

# 1 ɾ�������û�

#   1.1 �������±�ǩͳ��

#   1.2 ����ɾ����ǩ

#   1.3 ɾ�������û�

# 2 ɾ���ظ�

# 3 ɾ������

# 4 ɾ������

# 5 ���°��ͳ��

#



# ������ɾ��td_tudu_label, td_tudu_user, td_tudu_cycle������ݣ���Լ������

# �ɹ����� 1��ʧ�ܷ��� 0



DECLARE in_is_draft tinyint;

DECLARE in_post_num int;

DECLARE in_org_id varchar(36);

DECLARE in_board_id varchar(36);

DECLARE in_unique_id varchar(36);

DECLARE in_cycle_id varchar(36);

DECLARE in_cycle_num int;





# �����쳣ʱrollback

#DECLARE EXIT HANDLER FOR SQLEXCEPTION,SQLWARNING BEGIN

#ROLLBACK;

#SELECT 0;

#END;



SELECT is_draft, reply_num, org_id, board_id, cycle_id, cycle_num

INTO in_is_draft, in_post_num, in_org_id, in_board_id, in_cycle_id, in_cycle_num

FROM td_tudu WHERE tudu_id = in_tudu_id;



# ��������

START TRANSACTION;

##########################

### ɾ����������û�







BEGIN















DECLARE in_unread_num tinyint;

DECLARE no_more_user tinyint default 0;







# �����α�







DECLARE cur_users CURSOR FOR



SELECT unique_id, IF(is_read=0,1,0) FROM td_tudu_user WHERE tudu_id = in_tudu_id;



# �����¼��ȡ����ʱ����



DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_user = 1;



# ���α�

OPEN cur_users;



# ѭ�����е���

REPEAT FETCH cur_users INTO in_unique_id, in_unread_num;



IF NOT in_unique_id IS NULL THEN



   # �������±�ǩͳ��

   UPDATE td_label, td_tudu_label

   SET td_label.total_num = td_label.total_num - 1, td_label.unread_num = td_label.unread_num - in_unread_num,

   td_label.sync_time = UNIX_TIMESTAMP()

   WHERE td_label.unique_id = td_tudu_label.unique_id

   AND td_label.label_id = td_tudu_label.label_id

   AND td_tudu_label.unique_id = in_unique_id

   AND td_tudu_label.tudu_id = in_tudu_id;





   # ����ɾ�������ǩ

   DELETE FROM td_tudu_label WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



   # ɾ�������û�

   DELETE FROM td_tudu_user WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



END IF;



# ѭ������

UNTIL no_more_user END REPEAT;



# �ر��α�

CLOSE cur_users;



END;







### ɾ����������û�����



##########################

# ɾ������

DELETE FROM td_attach_post WHERE tudu_id = in_tudu_id;



# ɾ���ظ�

DELETE FROM td_post WHERE tudu_id = in_tudu_id;



# ɾ��ͶƱ

DELETE FROM td_voter WHERE tudu_id = in_tudu_id;

DELETE FROM td_vote_option WHERE tudu_id = in_tudu_id;

DELETE FROM td_vote WHERE tudu_id = in_tudu_id;



#ɾ������

DELETE FROM td_tudu_meeting WHERE tudu_id = in_tudu_id;



#ǰ������

UPDATE td_tudu SET prev_tudu_id = null WHERE prev_tudu_id = in_tudu_id;



# ����

DELETE FROM td_tudu_step_user WHERE tudu_id = in_tudu_id;

DELETE FROM td_tudu_step WHERE tudu_id = in_tudu_id;

DELETE FROM td_tudu_flow WHERE tudu_id = in_tudu_id;

# ɾ��ͼ��

DELETE FROM td_tudu WHERE tudu_id = in_tudu_id;



# ɾ������

IF NOT in_cycle_id IS NULL AND NOT EXISTS (SELECT cycle_id FROM td_tudu WHERE cycle_id = in_cycle_id AND tudu_id <> in_tudu_id) THEN



   DELETE FROM td_tudu_cycle WHERE cycle_id = in_cycle_id AND `count` = in_cycle_num;



END IF;





# �ǲݸ�ļ�¼������Ҫ���°��ͳ��

IF in_is_draft = 0 THEN



   UPDATE td_board SET tudu_num = IF(tudu_num - 1 < 0, 0, tudu_num - 1)

   WHERE org_id = in_org_id AND board_id = in_board_id;

END IF;





# ���°��ظ���

IF in_post_num > 0 THEN

   UPDATE td_board SET post_num = IF(post_num - in_post_num < 0, 0, post_num - in_post_num)

   WHERE org_id = in_org_id AND board_id = in_board_id;

END IF;



COMMIT;



SELECT 1;



END//



# Procedure "sp_td_delete_tudu_label" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_tudu_label`//
CREATE PROCEDURE `sp_td_delete_tudu_label`(in in_tudu_id varchar(36), in in_unique_id varchar(36), in in_label_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

# ɾ��ͼ�ȱ�ǩ



DECLARE unread int;



# ��ȡδ�������������ɸ��ݴ���ֵ�ж��û�������¼����

SET unread = (SELECT IF(is_read=0,1,0) FROM td_tudu_user WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id);



#  ������¼����ʱ�Ž��и���

IF NOT unread IS NULL THEN



	# ɾ����ǩ

	DELETE FROM td_tudu_label WHERE unique_id = in_unique_id AND label_id = in_label_id AND tudu_id= in_tudu_id;



	# ɾ���ɹ�ʱ����ͳ����

	IF ROW_COUNT() > 0 THEN



		# �����Լ�

		UPDATE td_label SET total_num = total_num - 1, unread_num = unread_num - unread, sync_time = UNIX_TIMESTAMP() WHERE unique_id = in_unique_id AND label_id = in_label_id;

	END IF;



	# ����ͼ�ȱ�ʶ

	UPDATE td_tudu_user SET labels = TRIM(TRAILING ',' FROM REPLACE(CONCAT(labels, ','), CONCAT(',', in_label_id, ','), ','))

    WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



END IF;



END//



# Procedure "sp_td_delete_tudu_user" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_tudu_user`//
CREATE PROCEDURE `sp_td_delete_tudu_user`(in in_tudu_id varchar(36), in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ɾ����������û�

#

# 1.�������±�ǩͳ��

# 2.����ɾ����ǩ

# 3.ɾ�������û�

#



DECLARE unread int;



# ��ȡδ�������������ɸ��ݴ���ֵ�ж��û�������¼����

SET unread = (SELECT IF(is_read=0,1,0) FROM td_tudu_user WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id);



#  ������¼����ʱ�Ž��и���

IF NOT unread IS NULL THEN



   # �������±�ǩͳ��

   UPDATE td_label, td_tudu_label

   SET td_label.total_num = td_label.total_num - 1, td_label.unread_num = td_label.unread_num - unread

   WHERE td_label.unique_id = td_tudu_label.unique_id

   AND td_label.label_id = td_tudu_label.label_id

   AND td_tudu_label.unique_id = in_unique_id

   AND td_tudu_label.tudu_id = in_tudu_id;



   # ����ɾ�������ǩ

   DELETE FROM td_tudu_label WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;

   

   # ɾ�������û�

   DELETE FROM td_tudu_user WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



END IF;



END//



# Procedure "sp_td_delete_user_tudu" DDL
DROP PROCEDURE IF EXISTS `sp_td_delete_user_tudu`//
CREATE PROCEDURE `sp_td_delete_user_tudu`(in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ɾ���û���ͼ������

#

# 1.����ɾ����ǩ

# 2.ɾ��ͼ���û�

# 3.ɾ���û���ǩ

#





# ����ɾ��ͼ�ȱ�ǩ

DELETE FROM td_tudu_label WHERE unique_id = in_unique_id;



# ɾ��ͼ���û�

DELETE FROM td_tudu_user WHERE unique_id = in_unique_id;



# ɾ���û���ǩ

DELETE FROM td_label WHERE unique_id = in_unique_id;



END//



# Procedure "sp_td_mark_all_unread" DDL
DROP PROCEDURE IF EXISTS `sp_td_mark_all_unread`//
CREATE PROCEDURE `sp_td_mark_all_unread`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE in_unique_id varchar(36);

DECLARE no_more_user tinyint default 0;



# �����α�

DECLARE cur_users CURSOR FOR

SELECT unique_id FROM td_tudu_user WHERE tudu_id = in_tudu_id AND is_read = 1 FOR UPDATE;



# �����¼��ȡ����ʱ����

DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_user = 1;



# ���α�

OPEN cur_users;



# ѭ�����е���

REPEAT FETCH cur_users INTO in_unique_id;



# ����Ϊδ��״̬

UPDATE td_tudu_user SET is_read = 0 WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



# �и�������ʱ�����������ظ������Ѷ�

IF ROW_COUNT() > 0 THEN



   # �������±�ǩͳ�ƣ�����δ���� + 1

   UPDATE td_label, td_tudu_label

   SET td_label.unread_num = td_label.unread_num + 1, 

  td_label.sync_time = UNIX_TIMESTAMP() 

   WHERE td_label.unique_id = td_tudu_label.unique_id

   AND td_label.label_id = td_tudu_label.label_id

   AND td_tudu_label.unique_id = in_unique_id

   AND td_tudu_label.tudu_id = in_tudu_id;



END IF;



# ѭ������

UNTIL no_more_user END REPEAT;



# �ر��α�

CLOSE cur_users;



END//



# Procedure "sp_td_mark_read" DDL
DROP PROCEDURE IF EXISTS `sp_td_mark_read`//
CREATE PROCEDURE `sp_td_mark_read`(in in_tudu_id varchar(36), in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ����Ϊδ��״̬

UPDATE td_tudu_user SET is_read = 1 WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



# �и�������ʱ�����������ظ������Ѷ�

IF ROW_COUNT() > 0 THEN



	# ������ǩδ���� - 1

	UPDATE td_label, td_tudu_label SET td_label.unread_num = td_label.unread_num - 1,

		td_label.sync_time = UNIX_TIMESTAMP() 

		WHERE td_label.unique_id = td_tudu_label.unique_id

		AND td_label.label_id = td_tudu_label.label_id

		AND td_tudu_label.unique_id = in_unique_id

		AND td_tudu_label.tudu_id = in_tudu_id;



END IF;



END//



# Procedure "sp_td_mark_unread" DDL
DROP PROCEDURE IF EXISTS `sp_td_mark_unread`//
CREATE PROCEDURE `sp_td_mark_unread`(in in_tudu_id varchar(36), in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ����Ϊδ��״̬

UPDATE td_tudu_user SET is_read = 0 WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



# �и�������ʱ�����������ظ������Ѷ�

IF ROW_COUNT() > 0 THEN



	# ������ǩδ���� + 1

	UPDATE td_label, td_tudu_label SET td_label.unread_num = td_label.unread_num + 1,

		td_label.sync_time = UNIX_TIMESTAMP() 

		WHERE td_label.unique_id = td_tudu_label.unique_id

		AND td_label.label_id = td_tudu_label.label_id

		AND td_tudu_label.unique_id = in_unique_id

		AND td_tudu_label.tudu_id = in_tudu_id;



END IF;



END//



# Procedure "sp_td_move_tudu" DDL
DROP PROCEDURE IF EXISTS `sp_td_move_tudu`//
CREATE PROCEDURE `sp_td_move_tudu`(in_tudu_id varchar(36), in_board_id varchar(36), in_class_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE tudu_reply_num int(11);

DECLARE from_board_id varchar(36);

DECLARE in_org_id varchar(60);



# ��ѯͼ����Ϣ

SELECT board_id, reply_num, org_id INTO from_board_id, tudu_reply_num, in_org_id FROM td_tudu WHERE tudu_id = in_tudu_id;



# ����ͼ����Ϣ

UPDATE td_tudu SET board_id = in_board_id, class_id = in_class_id WHERE tudu_id = in_tudu_id;



# ���°��ͼ�������ظ���

UPDATE td_board SET

tudu_num = tudu_num + 1,

post_num = post_num + tudu_reply_num

WHERE board_id = in_board_id AND org_id = in_org_id;



# ����ԭ���ͼ�������ظ���

UPDATE td_board SET

tudu_num = tudu_num - 1,

post_num = post_num - tudu_reply_num

WHERE board_id = from_board_id AND org_id = in_org_id;



END//



# Procedure "sp_td_send_post" DDL
DROP PROCEDURE IF EXISTS `sp_td_send_post`//
CREATE PROCEDURE `sp_td_send_post`(in in_tudu_id varchar(36), in in_post_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE in_org_id varchar(60);

DECLARE in_board_id varchar(36);

DECLARE `in_is_send` tinyint;

DECLARE in_log_num int;

DECLARE in_poster varchar(15) character set utf8;

DECLARE in_post_time int;

DECLARE in_board_privacy tinyint(1);

DECLARE in_tudu_privacy tinyint(1);



# ��ȡ�ظ������Ϣ

SELECT p.org_id, p.board_id, p.is_send, IF(p.is_log = 1, 1, 0), p.poster, p.create_time, b.privacy, t.privacy 

INTO in_org_id, in_board_id, in_is_send, in_log_num, in_poster, in_post_time, in_board_privacy, in_tudu_privacy

FROM td_post AS p

LEFT JOIN td_tudu AS t ON p.tudu_id = t.tudu_id AND p.org_id = t.org_id

LEFT JOIN td_board AS b ON p.board_id = b.board_id AND p.org_id = b.org_id

WHERE p.tudu_id = in_tudu_id AND p.post_id = in_post_id AND p.is_first = 0;



# δ���͹�

IF `in_is_send` <> 1 THEN



    # ����Ϊ�ѷ���

    UPDATE td_post SET `is_send` = 1 WHERE tudu_id = in_tudu_id AND post_id = in_post_id;



    /*

    # ����ͼ��ͳ�Ƽ����ظ���Ϣ

    UPDATE td_tudu

    SET reply_num = reply_num + 1, log_num = log_num + in_log_num, last_post_time = in_post_time, last_poster = in_poster

    WHERE tudu_id = in_tudu_id;

    

    # ���°��ͳ�Ƽ����ظ���Ϣ

    UPDATE td_board, td_tudu

    SET td_board.post_num = td_board.post_num + 1,

        td_board.last_post = CONCAT(td_tudu.tudu_id, char(9), td_tudu.subject, char(9), td_tudu.last_post_time, char(9), td_tudu.last_poster)

    WHERE td_board.org_id = td_tudu.org_id

    AND td_board.board_id = td_tudu.board_id

    AND td_tudu.tudu_id = in_tudu_id;

    */

    

    

    # ���°��ͳ�ƣ�ͼ��ͳ�Ƽ����ظ���Ϣ

    UPDATE td_board, td_tudu

    SET td_board.post_num = td_board.post_num + 1,

        td_board.last_post = IF (in_board_privacy <> 0 OR in_tudu_privacy <> 0, td_board.last_post , CONCAT(in_tudu_id, char(9), td_tudu.subject, char(9), in_post_time, char(9), in_poster)),

        td_tudu.reply_num = td_tudu.reply_num + 1,

        td_tudu.log_num = td_tudu.log_num + in_log_num,

        td_tudu.last_post_time = in_post_time,

        td_tudu.last_poster = in_poster

    WHERE td_board.org_id = td_tudu.org_id

    AND td_board.board_id = td_tudu.board_id

    AND td_tudu.tudu_id = in_tudu_id;

    

END IF;



END//



# Procedure "sp_td_send_tudu" DDL
DROP PROCEDURE IF EXISTS  `sp_td_send_tudu`//
CREATE PROCEDURE  `sp_td_send_tudu`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ����ͼ��

#

# 1.����Ϊ�ǲݸ�״̬

# 2.���°��ͳ��

#

# ����ͼ�ȸ�����ͼ�����������̣�ֻ�з��͹���ͼ�ȣ��Ż�Ӱ�쵽����ͳ����

# �����ظ���Ϣ

DECLARE in_tudu_privacy tinyint(1);

DECLARE in_board_privacy tinyint(1);

DECLARE in_org_id varchar(36);

DECLARE in_board_id varchar(36);

DECLARE in_last_post varchar(200) charset utf8; # max >= 36 + 1 + 50 + 1 + 11 + 1 + 50



UPDATE td_tudu SET is_draft = 0 WHERE tudu_id = in_tudu_id;

IF ROW_COUNT() > 0 THEN



    SELECT t.privacy, b.privacy, t.org_id, t.board_id, CONCAT(t.tudu_id, char(9), t.subject, char(9), t.last_post_time, char(9), t.last_poster)

    INTO in_tudu_privacy, in_board_privacy, in_org_id, in_board_id, in_last_post

    FROM td_tudu AS t

    LEFT JOIN td_board as b ON b.org_id = t.org_id AND b.board_id = t.board_id

    WHERE t.tudu_id = in_tudu_id;



    IF (in_tudu_privacy = 1 OR in_board_privacy = 1) THEN

        UPDATE td_board SET tudu_num = tudu_num + 1 WHERE org_id = in_org_id AND board_id = in_board_id;

    ELSE

        UPDATE td_board SET tudu_num = tudu_num + 1, last_post = in_last_post WHERE org_id = in_org_id AND board_id = in_board_id;

    END IF;


END IF;



END//



# Procedure "sp_td_update_tudu_labels" DDL
DROP PROCEDURE IF EXISTS  `sp_td_update_tudu_labels`//
CREATE PROCEDURE  `sp_td_update_tudu_labels`(in in_tudu_id varchar(36), in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN

#

# ����ͼ�ȵı�ǩ��ʶ

#



UPDATE td_tudu_user SET labels = (SELECT GROUP_CONCAT(label_id) FROM td_tudu_label WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id)

WHERE unique_id = in_unique_id AND tudu_id =  in_tudu_id;



END//



# Procedure "sp_td_update_tudu_progress" DDL
DROP PROCEDURE IF EXISTS  `sp_td_update_tudu_progress`//
CREATE PROCEDURE  `sp_td_update_tudu_progress`(in in_tudu_id varchar(36), in_unique_id varchar(36), in_percent tinyint(3))
    SQL SECURITY INVOKER
BEGIN

#

# ����ͼ�Ƚ���

#

# 1.���µ�ǰִ���˽���

# 2.�������������

#



DECLARE total_percent tinyint(3);



IF (in_unique_id IS NOT NULL AND in_percent IS NOT NULL) THEN



   # ���µ�ǰִ���˽��ȼ�״̬

    UPDATE td_tudu_user SET 

    percent = IFNULL(in_percent, IFNULL(percent, 0)), 

    tudu_status = IF(in_percent >= 100, 2, IF(in_percent > 0, 1, 0)), 

    complete_time = IF(in_percent >= 100, UNIX_TIMESTAMP(), NULL)

    WHERE tudu_id = in_tudu_id AND unique_id = in_unique_id;



END IF;



# ͳ�Ƶ�ǰ�����ܽ���

SELECT AVG(percent) INTO total_percent FROM td_tudu_user WHERE tudu_id = in_tudu_id AND role = 'to' AND (tudu_status IS NULL OR tudu_status < 3);



# ������������ȼ�״̬

UPDATE td_tudu SET 

percent = total_percent, 

`status` = IF(total_percent >= 100, 2, IF(total_percent > 0, 1, 0)),

complete_time = IF(total_percent >= 100, UNIX_TIMESTAMP(), NULL)

WHERE tudu_id = in_tudu_id;



# ���ص�ǰ�����ܽ���

SELECT total_percent AS percent;



END//




-- Procedure "sp_td_mark_all_unread" DDL
DROP PROCEDURE IF EXISTS `sp_td_mark_all_unread`//
CREATE PROCEDURE `sp_td_mark_all_unread`(in in_tudu_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



DECLARE in_unique_id varchar(36);

DECLARE no_more_user tinyint default 0;



# �����α�

DECLARE cur_users CURSOR FOR

SELECT unique_id FROM td_tudu_user WHERE tudu_id = in_tudu_id AND is_read = 1 FOR UPDATE;



# �����¼��ȡ����ʱ����

DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_user = 1;


# ���α�

OPEN cur_users;


# ѭ�����е���

REPEAT FETCH cur_users INTO in_unique_id;


# ����Ϊδ��״̬

UPDATE td_tudu_user SET is_read = 0 WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;


# �и�������ʱ�����������ظ������Ѷ�

IF ROW_COUNT() > 0 THEN



   # �������±�ǩͳ�ƣ�����δ���� + 1

   UPDATE td_label, td_tudu_label

   SET td_label.unread_num = td_label.unread_num + 1, 

  td_label.sync_time = UNIX_TIMESTAMP() 

   WHERE td_label.unique_id = td_tudu_label.unique_id

   AND td_label.label_id = td_tudu_label.label_id

   AND td_tudu_label.unique_id = in_unique_id

   AND td_tudu_label.tudu_id = in_tudu_id;



END IF;

# ѭ������

UNTIL no_more_user END REPEAT;

# �ر��α�

CLOSE cur_users;


END//


-- Procedure "sp_td_mark_read" DDL
DROP PROCEDURE IF EXISTS `sp_td_mark_read`//
CREATE PROCEDURE `sp_td_mark_read`(in in_tudu_id varchar(36), in in_unique_id varchar(36))
    SQL SECURITY INVOKER
BEGIN



# ����Ϊδ��״̬

UPDATE td_tudu_user SET is_read = 1 WHERE unique_id = in_unique_id AND tudu_id = in_tudu_id;



# �и�������ʱ�����������ظ������Ѷ�

IF ROW_COUNT() > 0 THEN



	# ������ǩδ���� - 1

	UPDATE td_label, td_tudu_label SET td_label.unread_num = td_label.unread_num - 1,

		td_label.sync_time = UNIX_TIMESTAMP() 

		WHERE td_label.unique_id = td_tudu_label.unique_id

		AND td_label.label_id = td_tudu_label.label_id

		AND td_tudu_label.unique_id = in_unique_id

		AND td_tudu_label.tudu_id = in_tudu_id;



END IF;



END//



DELIMITER ;

