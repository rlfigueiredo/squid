<?
include '../../../header.php';
include '../../config/config_url.php';
?>
<head><title>Excluir URL's de um usuario do Squid</title></head>
<body>
<table border = "0" align = "center">
	<form action="listar_url.php" method="POST">
	<th colspan=2>Selecione o usuario: </th>
        <tr><td>&nbsp</td><td>&nbsp</td></tr>
	<tr>
		<td align = "left" width = "30%">Usuario: </td>
		<td><select name="usuario">
		<?
			foreach ($lista_completa_usuario as $linha => $linha1 ) {
				trim ($linha1);
				if ( $linha1 <> "" ) {
					echo "<option value=$linha1>$linha1</option>";
				}
			}
		?>
		</select></td>
                <td><input type="submit" name="envia" value="Listar"></td>
</table>
<?
include '../../../rodape.php';
?>
