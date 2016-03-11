<?php
class SunapeeDB
{
    const HOST = "sunapee.cs.dartmouth.edu";
    const USER = "danignibus";
    const PASS = "danisql43";
    const DB   = "danignibus_db";
    private $con = NULL;

    public function connect()
    {
        $this->con = mysql_connect(self::HOST, self::USER, self::PASS);
	if(!$this->con) { die("SQL Error: " . mysql_error()); }
	mysql_select_db(self::DB, $this->con);
	mysql_set_charset("utf8mb4");
    }

    public function get_table($table)
    {
	if($this->con === NULL) { return; }
	
	$result = mysql_query("SELECT * FROM $table;");

	if(!$result) { die("SQL Error: " . mysql_error()); }

	$this->print_table($result);

	mysql_free_result($result);
    }

    public function insert_student($id, $name, $dept, $credits)
    {
        if($this->con === NULL) { return false; }

	$result = mysql_query("INSERT INTO student (ID, name, dept_name, tot_cred) VALUES (" . $id . ",\"" . $name . "\",\"" . $dept . "\"," . $credits . ");");

	if(!$result) { die("SQL Error: " . mysql_error()); }

	mysql_free_result($result);

	return true;
    }

    private function print_table($result)
    {
     	print("<table>\n<thead><tr>");
	for($i=0; $i < mysql_num_fields($result); $i++) {
	    print("<th>" . mysql_field_name($result, $i) . "</th>");
	}
	print("</tr></thead>\n");
	
	while ($row = mysql_fetch_assoc($result)) {
    	      print("\t<tr>\n");
    	      foreach ($row as $col) {
       	          print("\t\t<td>$col</td>\n");
    	      }
    	      print("\t</tr>\n");
	}
	print("</table>\n");    
    }	

    public function disconnect()
    {
	if($this->con != NULL) { mysql_close($this->con);}
    }
}
?>