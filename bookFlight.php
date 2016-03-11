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

  $inputFlightID = @$_GET['flightID'];
  echo $inputFlightID; 
  session_start();

  include 'sunapeedb.php';
  echo $_SESSION['userID']; // green
  $userID = $_SESSION['userID'];

  $db = new SunapeeDB();
  $db->connect();
  $null = NULL;

  $query = "CALL MakeReservation(NULL, " . $userID . " , " . $inputFlightID . ", @return)";
  echo $query;
	$result = mysql_query($query);

  if ($result){
    if (mysql_num_rows($result) == 0) {
      echo "Flight booking unsuccessful.";
    }
    else {
      $returnValue = mysql_query('SELECT @return');
      $actual_return_value = mysql_fetch_row($returnValue);

      echo $actual_return_value[0];
    }
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