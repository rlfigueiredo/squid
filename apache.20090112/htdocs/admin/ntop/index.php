<?
include '../header.php';

?>

<table align="center">
<form action="comandos.php" method="POST">
<tr align="center"><td><input type="radio" value="ativarregras" name="acao"></td><td align="left">Ativar regras do NTop</td></tr>
<tr align="center"><td align="rigth"><input type="radio" value="restaurarpadrao" name="acao"></td><td align="left">Restaurar regras padrao</td></tr>
<th colspan=2 align="center"><input type="submit" name="envia" value="Executar"></th>
</table>

<?

include '../rodape.php';

?>
