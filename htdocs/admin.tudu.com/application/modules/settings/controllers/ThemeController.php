<?php
/**
 * 系统设置图度主题设置控制器
 *
 * LICENSE
 *
 *
 * @package    Admin
 * @copyright  Copyright (c) 2009-2009 Shanghai Best Oray Information S&T CO., Ltd.
 * @link       http://www.oray.com/
 * @license    NULL
 * @version    $Id: ThemeController.php 2713 2013-01-23 10:17:49Z cutecube $
 */

/**
 * @copyright Copyright (c) 2009-2009 Shanghai Best Oray Information S&T CO., Ltd.
 * @package   Admin
 */
class Settings_ThemeController extends TuduX_Controller_Admin
{

    public function init()
    {
        parent::init();

        $this->lang = Tudu_Lang::getInstance()->load(array('common', 'settings'));
        $this->view->LANG   = $this->lang;
    }

	/**
     * 登录验证
     */
    public function preDispatch()
    {
        if (!$this->_user->isAdminLogined()) {
            $this->destroySession();
            $this->referer($this->_request->getBasePath() . '/login/');
        }

        if (in_array($this->_orgId, $this->_demoOrg)) {
            $action = strtolower($this->_request->getActionName());
            if (in_array($action, array('save'))) {
                return $this->json(false, '体验帐号不能更改后台设置');
            }
        }
    }

    /**
     * 显示页面信息
     */
    public function indexAction()
    {
        /* @var @daoOrg Dao_Md_Org_Org */
        $daoOrg = $this->getDao('Dao_Md_Org_Org');

        $org = $daoOrg->getOrg(array('orgid' => $this->_orgId));

        $this->view->org = $org->toArray();
    }

    /**
     * 保存皮肤设置
     */
    public function saveAction()
    {
        /* @var @daoOrg Dao_Md_Org_Org */
        $daoOrg = $this->getDao('Dao_Md_Org_Org');

        $skin = $this->_request->getPost('skin');
        $params = array(
            'skin' => $skin,
        );

        $ret = $daoOrg->updateOrg($this->_orgId, $params);

        if (!$ret) {
            return $this->json(false, $this->lang['skin_update_failure']);
        }

        if ($this->_user->getOption('skin') === null) {
            $this->_session->admin['skin'] = $skin;
        }

        $this->_cleanCache();
        $this->_user->updateSetting();
        $this->_createLog('org', 'update', 'skin', $this->_orgId, null);

        $this->json(true, $this->lang['skin_update_success']);
    }

    /**
     *
     */
    private function _cleanCache()
    {
        $key = 'TUDU-ORG-' . $this->_orgId;
        $this->_bootstrap->memcache->delete($key);
    }
}