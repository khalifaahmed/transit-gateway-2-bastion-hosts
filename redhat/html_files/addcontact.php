<?php
$servername = "3.80.54.230";   
$database   = "iti";   
$username   = "iti";     
$password   = "iti";     
//$table      = "userinfo";

if(isset($_POST['firstname'], $_POST['lastname'], $_POST['email'])){
session_start();
$firstname = $_POST['firstname'];  
$lastname = $_POST['lastname'];    
$email = $_POST['email'];

$_SESSION['firstname'] = $firstname;  
$_SESSION['lastname'] = $lastname; 
$_SESSION['email'] = $email;

}

$conn = mysqli_connect($servername, $username, $password, $database);

if ($conn->connect_error) {
die("Connection failed: " . $conn->connect_error);
}

$sql = "insert into userinfo (fname, lname, email) values ('$firstname', '$lastname', '$email')";

if ($conn->query($sql) === TRUE) {
	echo "new record created successfully";
} else {
	echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();



