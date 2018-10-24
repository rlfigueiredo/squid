<?
include '../../../header.php';
include '../../config/config.php';
?>
<head>
</head>
<body>
<table border = "0" align = "center">
	<form action="senhas_master.php" method="POST">
	<tr>
		<td align = "left" width = "30%">Usuario: </td>
		<!--td><input type="text" name="usuario"></td-->
		<td><select name="usuario">
		<?
			$lista_users = `cat $arquivo_usuarios | cut -d: -f1 | sort`;
			$lista_users_todos = split ( "\n" , $lista_users);
			foreach ($lista_users_todos as $linha => $linha1 ) {
				if ( $linha1 <> "" && $linha1 <> "blacklist" && $linha1 <> "todos") {
					echo "<option value=$linha1>$linha1</option>";
				}
			}
		?>
	</tr>
	<tr>
		<td align = "left">Nova Senha: </td> 
		<td><input type="password" name="nova_senha"></td>
	</tr>
	<tr>
		<td align = "left">Confirma Nova Senha: </td>
		<td><input type="password" name="confirma_nova_senha"></td>
	</tr>
	<th colspan = "4">
                <input type="submit" name="envia" value="Alterar">
        </th>
</table>
<?
include '../../../rodape.php';
?>
