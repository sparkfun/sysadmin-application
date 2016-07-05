<?php
// -->>BUILD= ???<<--
// -->>VERSION= 1.3.0<<--


//connect to ldap
include 'vars.php';


function getUserInfo(){
	//run a script to return infos
	$info = exec("/var/www/blackbox.pl " . $USERGID);


}


session_start();
$ldapHost = "ldaps://ldap.example.com";
$ldapPort = 636; //protocol on 636 for https
$ldapConnect = ldap_connect($ldapHost, $ldapPort) or die("Could not connect to $ldapHost");

// Define $USERGID and $USERPASSWD
$USERGID=$_POST['user'];
$USERPASSWD=$_POST['password'];
$bind = "uid=$USERGID,ou=people,o=example.com,o=SDS";
$ldapBind = ldap_bind($ldapConnect, $bind, $USERPASSWD);


//Set INVALID username and password to FALSE To start with
$_SESSION['INVALID'] = "FALSE";


if($ldapBind && $USERPASSWD != ""){
	//Set things that will be loaded on pages
	$_SESSION['USERGID'] = $USERGID;
	$_SESSION['VERSION'] = $VERSION;


	header("location:reset.php");
}

else {
	$_SESSION['INVALID'] = "TRUE";
	header("location:login.php");
}

ldap_close($ldapConnect);


?>
