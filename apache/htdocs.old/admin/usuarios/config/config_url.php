<?php

$s_usuario = $_POST['usuario'];
$s_url = $_POST['url'];
$dir = "/var/squid/listas/$s_usuario";
$lista_user = `ls /var/squid/listas/`;
$lista_completa_usuario = split ( "\n", $lista_user);
$lista = "/var/squid/listas/$s_usuario/domains";
$lista_comp = `cat $lista`;
$lista_completa = split ( "\n", $lista_comp);
$flag = "nao";

?>
