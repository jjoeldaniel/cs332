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
                <li><a href="index.html"><strong>University Database Interface</strong></a>
                </li>
            </ul>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="professors.php">Professors</a></li>
                <li><a href="students.php">Students</a></li>
            </ul>
        </nav>

        <!-- Student Interface -->
        <section id="student-interface">
            <h2>Student Interface</h2>

            <!-- Search Sections by Course Number -->
            <h3>Search Sections by Course Number</h3>
            <form method="POST">
                <label for="course_number_student">Enter Course Number:</label>
                <input type="text" id="course_number_student" name="course_number_student" value="<?php echo $_POST['course_number_student'] ?? ''; ?>">
                <button type="submit">Search</button>
            </form>

            <!-- Display course sections -->
            <div id="course-sections">
                <h4>Course Sections:</h4>
                <ul>
                    <?php
                    if (isset($_POST['course_number_student'])) {
                        $courseNumber = $_POST['course_number_student'];

                        // Join Course to get the "current" course,
                        // then LEFT JOIN Prerequisite to check if there's a prerequisite,
                        // then LEFT JOIN Course again (aliased as P) to get the prerequisite course title
                        $stmt = $conn->prepare("
                            SELECT
                                S.SectionNo,
                                S.Classroom,
                                S.MeetingDays,
                                S.BeginTime,
                                S.EndTime,
                                S.Seats,
                                P.CourseTitle AS PrereqTitle
                            FROM Section S
                            JOIN Course C ON S.CourseNo = C.CourseNo
                            LEFT JOIN Prerequisite R ON R.CourseNo = C.CourseNo
                            LEFT JOIN Course P ON R.PrereqCourseNo = P.CourseNo
                            WHERE S.CourseNo = ?
                        ");
                        $stmt->bind_param("i", $courseNumber);
                        $stmt->execute();
                        $result = $stmt->get_result();

                        if ($result->num_rows > 0) {
                            while ($row = $result->fetch_assoc()) {
                                echo "<li>Section: " . htmlspecialchars($row['SectionNo']) . "</li>";
                                echo "<li>Classroom: " . htmlspecialchars($row['Classroom']) . "</li>";
                                echo "<li>Meeting Days: " . htmlspecialchars($row['MeetingDays']) . "</li>";
                                echo "<li>Time: " . htmlspecialchars($row['BeginTime']) . " - " . htmlspecialchars($row['EndTime']) . "</li>";
                                echo "<li>Enrolled Students: " . htmlspecialchars($row['Seats']) . "</li>";

                                // Display Prerequisite Title if it exists
                                $prereq = $row['PrereqTitle'] ?? 'None';
                                if (empty($prereq)) {
                                    $prereq = 'None';
                                }
                                echo "<li>Prerequisite Course: " . htmlspecialchars($prereq) . "</li>";
                                
                                echo "<br>";
                            }
                        } else {
                            echo "<li>No sections found for the specified course number.</li>";
                        }

                        $stmt->close();
                    }
                    ?>
                </ul>
            </div>

            <!-- List Student's Courses -->
            <h3>List Student's Courses</h3>
            <form method="POST">
                <label for="cwidid">Enter Student CWID:</label>
                <input type="text" id="cwid" name="cwid" value="<?php echo $_POST['cwid'] ?? ''; ?>">
                <button type="submit">List Courses</button>
            </form>

            <!-- Display student's courses -->
            <div id="student-courses">
                <h4>Student's Courses:</h4>
                <ul>
                    <?php
                    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['cwid'])) {
                        $cwid = $_POST['cwid'];
                        $stmt = $conn->prepare(
                            "SELECT Course.CourseTitle, Enrollment.SectionNo, Enrollment.Grade 
                             FROM Enrollment
                             JOIN Course ON Enrollment.CourseNo = Course.CourseNo 
                             WHERE Enrollment.CWID = ?"
                        );
                        $stmt->bind_param("i", $cwid);
                        $stmt->execute();
                        $result = $stmt->get_result();

                        if ($result->num_rows > 0) {
                            while ($row = $result->fetch_assoc()) {
                                echo "<li>Course: " . htmlspecialchars($row['CourseTitle']) . "</li>";
                                echo "<li>Section: " . htmlspecialchars($row['SectionNo']) . "</li>";
                                echo "<li>Grade: " . htmlspecialchars($row['Grade']) . "</li><br>";
                            }
                        } else {
                            echo "<li>No courses found for the specified student CWID.</li>";
                        }

                        $stmt->close();
                    }
                    ?>
                </ul>
            </div>
        </section>
    </main>
</body>

</html>
