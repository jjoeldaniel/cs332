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

        <!-- Professor Interface -->
        <section id="professor-interface">
            <h2>Professor Interface</h2>

            <!-- Search Professor by Social Security Number -->
            <h3>Search Professor by SSN</h3>
            <form action="search_professor.php" method="GET">
                <label for="ssn">Enter Professor SSN:</label>
                <input type="text" id="ssn" name="ssn">
                <button type="submit">Search</button>
            </form>

            <!-- Display professor's courses -->
            <div id="professor-classes">
                <h4>Professor's Courses:</h4>
                <ul>
                    <li>Title: Example Course 1</li>
                    <li>Classroom: Building A, Room 101</li>
                    <li>Meeting Days: Mon, Wed, Fri</li>
                    <li>Time: 9:00 AM - 10:15 AM</li>
                </ul>
            </div>

            <!-- Count Students by Grade for a Course Section -->
            <h3>Count Students by Grade for Course Section</h3>
            <form action="count_grades.php" method="GET">
                <label for="course-number">Enter Course Number:</label>
                <input type="text" id="course-number" name="course_number"><br><br>
                <label for="section-number">Enter Section Number:</label>
                <input type="text" id="section-number" name="section_number">
                <button type="submit">Count</button>
            </form>
        </section>
    </main>
</body>

</html>
