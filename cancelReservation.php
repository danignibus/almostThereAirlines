<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Delete a Reservation</h1>
<header>
<form action="customerPage.php" method="get">
<input type="submit" value="Return to homepage" style="height:150px; width:200px">
</form>
<?php
  $inputResID = @$_GET['resID'];
  session_start();

  include 'sunapeedb.php';
  $userID = $_SESSION['userID'];

  $db = new SunapeeDB();
  $db->connect();
  $null = NULL;

  $query = "CALL DeleteReservation(" . $inputResID . ")";
  echo $query;
  $result = mysql_query($query);

  if ($result){
    echo "Reservation successfully deleted.";
  }
  else {
    echo "no result".mysql_error();
  }
    
  $db->disconnect();
  exit();
?>

</CENTER>
</body>
</html>