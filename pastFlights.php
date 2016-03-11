<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Your Past Flights</h1>
<header>
<form action="customerPage.php" method="get">
<input type="submit" value="Return to homepage" style="height:150px; width:200px">
</form>
<?php
	session_start();
	$userID = $_SESSION['userID']; // green



    include 'sunapeedb.php';

    $db = new SunapeeDB();
    $db->connect();

    $query = "CALL PastFlightReservations(" . $userID . ")";
	$result = mysql_query($query);

	if ($result){
	    if (mysql_num_rows($result) == 0) {
	      echo "You have no past flight reservations.";
	    }
	    else {
	      echo "Passenger Number&nbsp;&nbsp;";
	      $secondPart = "Passenger Name\n\n";
	      echo nl2br($secondPart);
			  while ($row = mysql_fetch_assoc($result)) {
	        $enter = "\n";
	        echo nl2br($enter);
	        echo "&nbsp;&nbsp;";
	        echo $row["flight_id"];
	        echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	        echo $row["departure"];
	        echo "&nbsp;&nbsp;";
	        echo $row["arrival"];
	        echo "&nbsp;&nbsp;";
	        echo $row["flight_status"];
	        echo "&nbsp;&nbsp;";
	        echo $row["start_city"];
	        echo "&nbsp;&nbsp;";
	        echo $row["end_city"];
	      }
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
