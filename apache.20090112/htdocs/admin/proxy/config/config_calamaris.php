<?
$caminho_logs = "/var/www/htdocs/admin/proxy/logs/";
$url_logs = "/admin/proxy/logs";
$lista_ano = split ( "\n", `ls  $caminho_logs | grep -v html`);
$dia = $_POST['dia'];
$mes = $_POST['mes'];
$ano = $_POST['ano'];
$enviadiario = $_POST['enviadiario'];
$enviasemanal = $_POST['enviasemanal'];
$envia = $_POST['envia'];
?>
