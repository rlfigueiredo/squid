<?php
$arquivo = file('/var/squid/listas/.usuarios_php');
$arquivo_caminho = "/var/squid/listas/.usuarios_php";
$arquivo_caminho1 = "/var/squid/listas/.usuarios1_php";
$arquivo_usuarios = "/var/squid/listas/.usuarios";
$arquivo_log = "/var/squid/listas/.usuarios_php_senhas.log";
$htpasswd = "/usr/bin/htpasswd";
$dir_listas = "/var/squid/listas/";
$data = date ("d/m/y - H:i:s");
$log = "$_SERVER[REMOTE_ADDR] - $_SERVER[REMOTE_HOST] - $_SERVER[PHP_AUTH_USER] - $_SERVER[SCRIPT_NAME] - $data ";
