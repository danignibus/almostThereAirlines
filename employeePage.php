<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Employee Page</h1>
<img src="AlmostThere.png" alt="Target" style="width:304px;height:228px">
<header>
Enter a start date and end date below to get popular flights:<br>
<form action="popularFlights.php" method="get">
Start date: <input type="text" name="startDate"><br>
End date: <input type="text" name="endDate"><br>
<input type="submit">
</form>
<br><br>
Enter a flight ID number below to get a list of all passengers:<br>
<form action="customerList.php" method="get">
Enter flight number: <input type="text" name="flightNumber"><br>
<input type="submit">
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