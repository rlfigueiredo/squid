<?
include '../header.php';
$lista = explode ( "\n" , `ls | grep -v index` );
foreach ( $lista as $idhost => $host ) {
        if ( $host != "" ) {
                echo "<th><h2>$host</h2></th>";
                $listanic = explode ( "\n" , `ls $host | grep html | awk -F ".html" '{print $1}'` );
                foreach ( $listanic as $idnic => $nic ) {
                        if ( $nic != "" ) {
                                $eth = `cat $host/$nic.html | grep "Description" | awk -F "Description:" '{print $2}' | awk '{print $2}' | awk -F">" '{print $2}'`;
                                $ip = `cat $host/$nic.html | grep "Ip" | awk -F "Ip:" '{print $2}' | awk '{print $2}' | awk -F">" '{print $2}'`;
                                echo "<tr align='center'><td><a href=$host/$nic.html title='$eth - $ip'><img src=$host/$nic-day.png border=0></a></td></tr>";
                        }
                }
                echo "<tr><td><hr></td></tr>";
        }
}
include '../rodape.php';
?>
