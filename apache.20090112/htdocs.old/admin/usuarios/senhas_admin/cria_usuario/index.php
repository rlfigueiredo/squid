<?
include '../../../header.php';
?>
<head>
<title>Criacao de Usuario</title>
</head>
<body>
<table heigth = "90%" widtch = "90%" border = "0" align = "center"> 
	<form action="cria_usuario.php" method="POST">
	<tr>
		<td align = "right">Nome do Usuario:
		</td>
		<td> 
			<input type="text" name="nome">
		</td>
	</tr>
		<td align = "right">Usuario:
		</td>
		<td> 
			<input type="text" name="usuario">
		</td>
	</tr>
	<tr>
		<td align = "right">Senha: 
		</td>
                <td>
			<input type="password" name="nova_senha">
		</td>
	</tr>
	<th colspan = "4">
		<input type="submit" name="envia" value="Criar Usuario">
	</th>
	</form>
</table>
<?
include '../../../rodape.php';
?>
