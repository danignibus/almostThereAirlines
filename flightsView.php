<!DOCTYPE html>
<html>
<body>
<CENTER>
<header>
<h1>Almost There Airlines: Available Flights</h1>
<header>
<header>
<form action="customerPage.php" method="get">
<input type="submit" value="Return to homepage" style="height:150px; width:200px">
</form>
<form action="bookFlight.php" method="get">
Enter the flight ID of the flight you'd like to book: <input type="text" name="flightID"><br>
<input type="submit">
</form>
<br><br>

<?php
    include 'sunapeedb.php';

    $db = new SunapeeDB();
    $db->connect();
    $db->get_table("UPCOMINGFLIGHTS");
   
       $db->disconnect();
?>
</CENTER>
</body>
</html>
