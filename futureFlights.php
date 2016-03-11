<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Your Future Flights</h1>
<header>
<form action="customerPage.php" method="get">
<input type="submit" value="Return to homepage" style="height:150px; width:200px">
</form>
<form action="cancelReservation.php" method="get">
If you'd like to cancel a reservation, enter the reservation ID here: <input type="text" name="resID"><br>
<input type="submit">
</form>
<br><br>
<?php
	session_start();
	$userID = $_SESSION['userID']; // green


    include 'sunapeedb.php';

    $db = new SunapeeDB();
    $db->connect();

    $query = "CALL UpcomingFlightReservations(" . $userID . ")";
	$result = mysql_query($query);

	if ($result){
	    if (mysql_num_rows($result) == 0) {
	      echo "You have no future flight reservations.";
	    }
	    else {
	      echo "Flight ID Departure Arrival Start City      ";
	      $secondPart = "End City\n\n";
	      echo nl2br($secondPart);
			  while ($row = mysql_fetch_assoc($result)) {
	        $enter = "\n";
	        echo nl2br($enter);
	        echo $row["res_id"];
	       	echo "&nbsp;&nbsp;";
	        echo $row["flight_id"];
	        echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	        echo $row["departure"];
	        echo "&nbsp;&nbsp;";
	        echo $row["arrival"];
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
