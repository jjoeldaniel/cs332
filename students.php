<!doctype html>
<html lang="en">

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
            <form action="search_sections.php" method="GET">
                <label for="course-number-student">Enter Course Number:</label>
                <input type="text" id="course-number-student" name="course_number_student">
                <button type="submit">Search</button>
            </form>

            <!-- Display course sections -->
            <div id="course-sections">
                <h4>Course Sections:</h4>
                <ul>
                    <li>Section: 001</li>
                    <li>Classroom: Building B, Room 202</li>
                    <li>Meeting Days: Tue, Thu</li>
                    <li>Time: 1:00 PM - 2:15 PM</li>
                    <li>Enrolled Students: 30</li>
                </ul>
            </div>

            <!-- List Student's Courses -->
            <h3>List Student's Courses</h3>
            <form action="list_student_courses.php" method="GET">
                <label for="student-id">Enter Student Campus ID:</label>
                <input type="text" id="student-id" name="student_id">
                <button type="submit">List Courses</button>
            </form>

            <!-- Display student's courses -->
            <div id="student-courses">
                <h4>Student's Courses:</h4>
                <ul>
                    <li>Course: Math 101</li>
                    <li>Section: 002</li>
                    <li>Grade: A</li>
                </ul>
            </div>
        </section>
    </main>
</body>

</html>