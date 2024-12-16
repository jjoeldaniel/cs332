<!doctype html>
<html lang="en">

<?php
include 'connection.php';
$conn = connect();
?>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <title>University Database Interface</title>
</head>

<body>
    <main class="container">
        <nav>
            <ul>
                <li><a href="index.html"><strong>University Database Interface</strong></a></li>
            </ul>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="professors.php">Professors</a></li>
                <li><a href="students.php">Students</a></li>
            </ul>
        </nav>

        <!-- Professor Interface -->
        <section id="professor-interface">
            <h2>Professor Interface</h2>

            <!-- Search Professor by Social Security Number -->
            <h3>Search Professor by SSN</h3>
            <form method="POST">
                <label for="ssn">Enter Professor SSN:</label>
                <input type="text" id="ssn" name="ssn" value="<?php echo $_POST['ssn'] ?? ''; ?>">
                <button type="submit">Search</button>
            </form>

            <?php
            if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['ssn'])) {
                $ssn = $_POST['ssn'];
                $query = "SELECT * FROM Professor WHERE SSN = ?";
                $stmt = $conn->prepare($query);
                $stmt->bind_param("s", $ssn);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    $professor = $result->fetch_assoc();
                    echo "<h4>Professor Details</h4>";
                    echo "<p>Name: " . $professor['Name'] . "</p>";
                    echo "<p>Address: " . $professor['StreetAddress'] . ", " . $professor['City'] . ", " . $professor['State'] . " " . $professor['ZipCode'] . "</p>";
                    echo "<p>Phone: (" . $professor['AreaCode'] . ") " . $professor['PhoneNumber'] . "</p>";
                    echo "<p>Title: " . $professor['Title'] . "</p>";
                    echo "<p>Salary: $" . number_format($professor['Salary'], 2) . "</p>";
                } else {
                    echo "<p>No professor found with SSN: $ssn</p>";
                }

                // Display professor's courses
                $query = "SELECT C.CourseTitle, S.Classroom, S.MeetingDays, S.BeginTime, S.EndTime 
                          FROM Section S 
                          INNER JOIN Course C ON S.CourseNo = C.CourseNo 
                          WHERE S.ProfessorSSN = ?";
                $stmt = $conn->prepare($query);
                $stmt->bind_param("s", $ssn);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    echo "<h4>Professor's Courses:</h4><ul>";
                    while ($row = $result->fetch_assoc()) {
                        echo "<li>Title: " . $row['CourseTitle'] . "</li>";
                        echo "<li>Classroom: " . $row['Classroom'] . "</li>";
                        echo "<li>Meeting Days: " . $row['MeetingDays'] . "</li>";
                        echo "<li>Time: " . $row['BeginTime'] . " - " . $row['EndTime'] . "</li>";
                        echo "<br>";
                    }
                    echo "</ul>";
                } else {
                    echo "<p>No courses found for this professor.</p>";
                }
            }
            ?>

            <!-- Count Students by Grade for a Course Section -->
            <h3>Count Students by Grade for Course Section</h3>
            <form method="POST">
                <label for="course-number">Enter Course Number:</label>
                <input type="text" id="course-number" name="course_number" value="<?php echo $_POST['course_number'] ?? ''; ?>"><br><br>
                <label for="section-number">Enter Section Number:</label>
                <input type="text" id="section-number" name="section_number" value="<?php echo $_POST['section_number'] ?? ''; ?>">
                <button type="submit">Count</button>
            </form>

            <?php
            if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['course_number'], $_POST['section_number'])) {
                $course_number = $_POST['course_number'];
                $section_number = $_POST['section_number'];

                $query = "SELECT Grade, COUNT(*) as Count 
                          FROM Enrollment 
                          WHERE CourseNo = ? AND SectionNo = ? 
                          GROUP BY Grade";
                $stmt = $conn->prepare($query);
                $stmt->bind_param("ii", $course_number, $section_number);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    echo "<h4>Grade Counts</h4>";
                    echo "<table>";
                    echo "<thead><tr><th>Grade</th><th>Count</th></tr></thead>";
                    echo "<tbody>";
                    while ($row = $result->fetch_assoc()) {
                        echo "<tr><td>" . $row['Grade'] . "</td><td>" . $row['Count'] . "</td></tr>";
                    }
                    echo "</tbody></table>";
                } else {
                    echo "<p>No grades found for Course Number: $course_number, Section Number: $section_number.</p>";
                }
            }
            ?>
        </section>
    </main>
</body>

</html>
