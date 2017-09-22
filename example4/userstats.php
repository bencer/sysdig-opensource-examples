<?php
 ini_set('display_errors','Off'); 
 $db = mysqli_connect('mysql','root','root','userss')
 or die('Database error');
?>

<html>
 <head>
 </head>
 <body>
 <h1>Userstats</h1>
 
<?php
$query = "SELECT * FROM users";
mysqli_query($db, $query) or die('Database error');

$result = mysqli_query($db, $query);
$row = mysqli_fetch_array($result);

while ($row = mysqli_fetch_array($result)) {
 echo $row['first_name'] . ' ' . $row['last_name'] . ': ' . $row['email'] . ' ' . $row['city'] .'<br />';
}
?>

</body>
</html>
