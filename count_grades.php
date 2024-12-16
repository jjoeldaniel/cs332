<?php
include 'connection.php';

$conn = connect();

if (isset($_GET['course_number']) && isset($_GET['section_number'])) {
    $course_number = $_GET['course_number'];
    $section_number = $_GET['section_number'];

    $query = "SELECT Grade, COUNT(*) as Count 
              FROM Enrollment 
              WHERE CourseNo = ? AND SectionNo = ? 
              GROUP BY Grade";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ii", $course_number, $section_number);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "<h2>Grade Counts</h2>";
        echo "<table border='1'>";
        echo "<tr><th>Grade</th><th>Count</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>" . $row['Grade'] . "</td><td>" . $row['Count'] . "</td></tr>";
        }
        echo "</table>";
    } else {
        echo "<p>No grades found for Course Number: $course_number, Section Number: $section_number.</p>";
    }
} else {
    echo "<p>Please provide both course and section numbers.</p>";
}
?>
