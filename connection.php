<?php

function connect() {
  $host = 'mariadb';
  $db = 'cs332g18';
  $user = 'cs332g18';
  $pass = '3GYZP1WY';

  // Create connection
  try {
    $conn = new mysqli($host, $user, $pass, $db);

    // Check connection
    if ($conn->connect_error) {
        return $conn->connect_error;
    } else {
      return $conn;
    }

  } catch (Exception $e) {
    echo $e->getMessage();
  }
}
?>
