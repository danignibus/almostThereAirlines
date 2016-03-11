<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Customer List</h1>
<img src="AlmostThere.png" alt="Target" style="width:304px;height:228px">
<header>
<form action="employeePage.php" method="get">
<input type="submit" value="Return to homepage" style="height:150px; width:200px">
</form>
<?php
  $flightID = @$_GET['flightNumber'];
    include 'sunapeedb.php';

    $db = new SunapeeDB();
    $db->connect();
    $query = "CALL PassengerList(" . $flightID . ")";
    $result = mysql_query($query);

  if ($result){
    if (mysql_num_rows($result) == 0) {
      echo "No passengers have made reservations for this flight yet.";
    }
    else {
      echo "Passenger Number&nbsp;&nbsp;";
      $secondPart = "Passenger Name\n\n";
      echo nl2br($secondPart);
      while ($row = mysql_fetch_assoc($result)) {
        $enter = "\n";
        echo nl2br($enter);
        echo "&nbsp;&nbsp;";
        echo $row["passenger_id"];
        echo "&nbsp;&nbsp;&nbsp;";
        echo $row["cust_fname"];
        echo "&nbsp;&nbsp;";
        echo $row["cust_lname"];
      }
    }
  }
  else {
    echo "no result".mysql_error();
  }

    
  $db->disconnect();

?>
</CENTER>
</body>
</html>



