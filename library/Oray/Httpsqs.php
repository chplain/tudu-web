<?php
/**
 * Oray Framework
 *
 * LICENSE
 *
 *
 * @category   Oray
 * @package    Oray_Httpsqs
 * @copyright  Copyright (c) 2009-2011 Shanghai Best Oray Information S&T CO., Ltd.
 * @link       http://www.oray.com/
 * @version    $Id: Httpsqs.php 9857 2012-04-16 10:19:51Z cutecube $
 */

/**
 * @category   Oray
 * @package    Oray_Httpsqs
 * @copyright  Copyright (c) 2009-2011 Shanghai Best Oray Information S&T CO., Ltd.
 */
class Oray_Httpsqs
{
    /**
     * Socket
     *
     * @var resource
     */
    private $_socket;

    /**
     * 服务器地址
     *
     * @var string
     */
    private $_host;

    /**
     * 服务器端口
     *
     * @var int
     */
    private $_port;

    /**
     * 默认编码
     *
     * @var string
     */
    private $_charset = 'utf-8';

    /**
     * 默认名称
     *
     * @var string
     */
    private $_name = 'default';

    /**
     * 连接超时时间（秒）
     *
     * @var int
     */
    private $_timeout = 3;

    /**
     * 连接失败时是否抛出异常
     *
     * @var boolean
     */
    private $_throwExceptions = false;

    /**
     * 初始化
     *
     * @param $host
     * @param $port
     * @param $charset
     * @param $name
     */
    public function __construct($host, $port, $charset = null, $name = null)
    {
        $this->_host = $host;
        $this->_port = $port;

        if (null !== $charset) {
            $this->_charset = $charset;
        }

        if (null !== $name) {
            $this->_name = $name;
        }
    }

    /**
     * 类摧毁
     */
    public function __destruct()
    {
        if (null !== $this->_socket) {
            fclose($this->_socket);
        }
    }

    /**
     * 增加数据到队列
     *
     * @param string $data
     * @param string $name
     * @param string $charset
     * @return boolean
     */
    public function put($data, $name = null, $charset = null)
    {
        $name = (null === $name) ? $this->_name : $name;
        $charset = (null === $charset) ? $this->_charset : $charset;

        $query = "/?charset=" . $charset . "&name=" . $name . "&opt=put&data=" . urlencode($data);

        $result = $this->_request($query);
        if ($result["data"] == "HTTPSQS_PUT_OK") {
            return true;
        } else if ($result["data"] == "HTTPSQS_PUT_END") {
            return $result["data"];
        }
        return false;
    }

    /**
     * 从队列获取数据
     *
     * @param string $name
     * @param string $charset
     * @return string
     */
    public function get($name = null, $charset = null)
    {
        $name = (null === $name) ? $this->_name : $name;
        $charset = (null === $charset) ? $this->_charset : $charset;

        $query = "/?charset=" . $charset . "&name=" . $name . "&opt=get";
        $result = $this->_request($query);
        if ($result == false || $result["data"] == "HTTPSQS_ERROR" || $result["data"] == false) {
            return false;
        }
        return $result["data"];
    }

    /**
     * 发送请求
     *
     * @param $query
     * @param $retry
     * @return array
     */
    protected function _request($query, $retry = false)
    {
        $this->_connect();

        $out = "GET {$query} HTTP/1.1\r\n";
        $out .= "Host: {$this->_host}\r\n";
        $out .= "Connection: Keep-Alive\r\n";
        $out .= "\r\n";

        fwrite($this->_socket, $out);

        $line = trim(fgets($this->_socket));

        if (empty($line)) {
            $this->closeConnection();
            $this->_connect();
            fwrite($this->_socket, $out);
            $line = trim(fgets($this->_socket));
        }

        $length = -1;
        $pos = 0;

        while (($line = trim(fgets($this->_socket))) != "") {
            if (strstr($line, "Content-Length:")) {
                list(, $length) = explode(" ", $line);
            } elseif (strstr($line, "Pos:")) {
                list(, $pos) = explode(" ", $line);
            }
        }

        if ($length < 0) {
            return false;
        }

        // fix bug when response is large
        $body = '';
        $bufferSize = 2048;
        while (!feof($this->_socket)) {
            $body .= fread($this->_socket, $bufferSize);
        }

        $result = array(
            'pos' => (int) $pos,
            'data' => $body
        );

        return $result;
    }

    /**
     * 创建一个新的httpsqs连接
     *
     * @return void
     */
    private function _connect()
    {
        if (null === $this->_socket) {
            $this->_socket = pfsockopen($this->_host, $this->_port, $errno, $errstr, $this->_timeout);
            if (!$this->_socket) {
                if ($this->_throwExceptions) {
                    /**
                     * @see Oray_Exception
                     */
                    require_once 'Oray/Exception.php';
                    throw new Oray_Exception($errstr);
                }
            }
        }
    }

    /**
     * 强制关闭连接
     *
     * @return void
     */
    public function closeConnection()
    {
        if (null !== $this->_socket) {
            fclose($this->_socket);
            $this->_socket = null;
        }
    }

    /**
     * 设置是否抛出异常
     *
     * @param boolean $flag Defaults to null (return flag state)
     * @return boolean|Oray_Httpsqs
     */
    public function throwExceptions($flag = null)
    {
        if ($flag !== null) {
            $this->_throwExceptions = (bool) $flag;
            return $this;
        }

        return $this->_throwExceptions;
    }
}