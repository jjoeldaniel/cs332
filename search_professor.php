<?php
include 'connection.php';

$conn = connect();

if (isset($_GET['ssn'])) {
    $ssn = $_GET['ssn'];
    $query = "SELECT * FROM Professor WHERE SSN = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $ssn);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $professor = $result->fetch_assoc();
        echo "<h2>Professor Details</h2>";
        echo "<p>Name: " . $professor['Name'] . "</p>";
        echo "<p>Address: " . $professor['StreetAddress'] . ", " . $professor['City'] . ", " . $professor['State'] . " " . $professor['ZipCode'] . "</p>";
        echo "<p>Phone: (" . $professor['AreaCode'] . ") " . $professor['PhoneNumber'] . "</p>";
        echo "<p>Title: " . $professor['Title'] . "</p>";
        echo "<p>Salary: $" . number_format($professor['Salary'], 2) . "</p>";
    } else {
        echo "<p>No professor found with SSN: $ssn</p>";
    }
} else {
    echo "<p>SSN not provided.</p>";
}
?>
