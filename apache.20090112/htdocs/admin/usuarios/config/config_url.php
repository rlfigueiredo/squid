<?

$dia = date ("d");
$mes = date ("m");
$ano = date ("Y");
$data = date ("YmdHis");
$s_usuario = $_POST['usuario'];
$s_url = $_POST['url'];
$dir = "/var/squid/listas/$s_usuario";
$dir_backup = "/var/squid/log/listas/$ano/$mes";
$lista_user = `ls /var/squid/listas/`;
$lista_completa_usuario = split ( "\n", $lista_user);
$lista = "/var/squid/listas/$s_usuario/domains";
$lista_comp = `cat $lista`;
$lista_completa = split ( "\n", $lista_comp);
$flag = "nao";

?>
