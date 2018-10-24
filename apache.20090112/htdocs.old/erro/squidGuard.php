<?php
$data = date ("d/m/y - H:i:s");
$clientaddr=$_GET['clientaddr'];
$clientname=$_GET['clientname'];
$clientident=$_GET['clientident'];
$clientgroup=$_GET['clientgroup'];
$destinationgroup=$_GET['destinationgroup'];
$url=$_GET['url'];
system ("echo '$data - $clientaddr - $clientname - $clientident - $clientgroup - $destinationgroup - $url' >>/var/squid/log/urls.log");
?>
<html>
<head>
<title>Acesso Proibido</title>
</head>
<body>
<table heigth = "90%" widtch = "90%" border = "0" align = "center"> 
        <th align = "center" colspan = "4" >
        </th>
	<tr>
<?php
	echo "<td>IP: $clientaddr<br>Usuario: $clientident<br>URL: $url<br><br><br></td>"
?>
	</tr>
	<tr><td><b>Este usuario nao tem permissao de acessar esta URL<b></td></tr>
</table>
</body>
</html>
