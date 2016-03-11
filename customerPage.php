<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Customer Page</h1>
<img src="AlmostThere.png" alt="Target" style="width:304px;height:228px">
<header>
<form action="pastFlights.php" method="get">
<input type="submit" value="View past reservations" style="height:150px; width:200px">
</form>
<form action="futureFlights.php" method="get">
<input type="submit" value="View or cancel future reservations" style="height:150px; width:200px">
</form>
<form action="flightsView.php" method="get">
<input type="submit" value="View and book available flights" style="height:150px; width:200px">
</form>
<form action="logout.php" method="get">
<input type="submit" value="Log out" style="height:150px; width:200px">
</form>
</CENTER>

<?php
	session_start();

    include 'sunapeedb.php';
	echo $_SESSION['userID']; // green

    $db = new SunapeeDB();
    $db->connect();

   
    $db->disconnect();
    exit();

?>
</CENTER>
</body>
</html>