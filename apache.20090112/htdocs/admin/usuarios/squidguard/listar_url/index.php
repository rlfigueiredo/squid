<?
include '../../../header.php';
include '../../config/config_url.php';
?>
<head>
</head>
<body>
<table border = "0" align = "center">
	<form action="listar_url.php" method="POST">
	<tr>
		<td align = "left" width = "30%">Usuario: </td>
		<!--td><input type="text" name="usuario"></td-->
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
