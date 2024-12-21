-- ====================================
-- 0) Disable FK checks for clean drops
-- ====================================
SET FOREIGN_KEY_CHECKS = 0;

-- 1) DROP TABLES
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS StudentMinor;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Professor;

-- Re-enable FK checks
SET FOREIGN_KEY_CHECKS = 1;

-- ====================================
-- 2) CREATE TABLES
-- ====================================

-- Professor
CREATE TABLE Professor (
    SSN VARCHAR(9) PRIMARY KEY,
    Name VARCHAR(255),
    StreetAddress VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    ZipCode VARCHAR(10),
    AreaCode VARCHAR(3),
    PhoneNumber VARCHAR(7),
    Sex VARCHAR(10),
    Title VARCHAR(255),
    Salary DECIMAL,
    CollegeDegrees VARCHAR(255)
);

-- Department
CREATE TABLE Department (
    DeptNo INT PRIMARY KEY,
    DeptName VARCHAR(255),
    Telephone VARCHAR(20),
    OfficeLocation VARCHAR(255),
    ChairpersonSSN VARCHAR(9),
    FOREIGN KEY (ChairpersonSSN) REFERENCES Professor(SSN)
);

-- Course
CREATE TABLE Course (
    CourseNo INT PRIMARY KEY,
    CourseTitle VARCHAR(255),
    Textbook VARCHAR(255),
    Units INT,
    DeptNo INT,
    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo)
);

-- Prerequisite (self-referencing many-to-many for Courses)
CREATE TABLE Prerequisite (
    CourseNo INT,
    PrereqCourseNo INT,
    PRIMARY KEY (CourseNo, PrereqCourseNo),
    FOREIGN KEY (CourseNo) REFERENCES Course(CourseNo),
    FOREIGN KEY (PrereqCourseNo) REFERENCES Course(CourseNo)
);

-- Section
CREATE TABLE Section (
    SectionNo INT,
    CourseNo INT,
    Classroom VARCHAR(255),
    Seats INT,
    MeetingDays VARCHAR(255),
    BeginTime TIME,
    EndTime TIME,
    ProfessorSSN VARCHAR(9),
    PRIMARY KEY (SectionNo, CourseNo),
    FOREIGN KEY (CourseNo) REFERENCES Course(CourseNo),
    FOREIGN KEY (ProfessorSSN) REFERENCES Professor(SSN)
);

-- Student
CREATE TABLE Student (
    CWID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StreetAddress VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    ZipCode VARCHAR(10),
    AreaCode VARCHAR(3),
    PhoneNumber VARCHAR(7),
    MajorDeptNo INT,
    FOREIGN KEY (MajorDeptNo) REFERENCES Department(DeptNo)
);

-- StudentMinor (many-to-many between Student and Department)
CREATE TABLE StudentMinor (
    CWID INT,
    DeptNo INT,
    PRIMARY KEY (CWID, DeptNo),
    FOREIGN KEY (CWID) REFERENCES Student(CWID),
    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo)
);

-- Enrollment
CREATE TABLE Enrollment (
    CWID INT,
    SectionNo INT,
    CourseNo INT,
    Grade VARCHAR(2),
    PRIMARY KEY (CWID, SectionNo, CourseNo),
    FOREIGN KEY (CWID) REFERENCES Student(CWID),
    FOREIGN KEY (SectionNo, CourseNo) REFERENCES Section(SectionNo, CourseNo)
);

-- ====================================
-- 3) INSERT MOCK DATA
-- ====================================

-- 3.1) Professors
INSERT INTO Professor 
    (SSN, Name, StreetAddress, City, State, ZipCode, AreaCode, PhoneNumber, Sex, Title, Salary, CollegeDegrees)
VALUES
    ('123456789', 'Dr. John Smith', '123 Main St', 'Fullerton', 'CA', '92831', '714', '5551234', 'M', 'Professor', 95000.00, 'Ph.D. Computer Science'),
    ('987654321', 'Dr. Mary Johnson', '456 College Ave', 'Fullerton', 'CA', '92831', '714', '5555678', 'F', 'Associate Professor', 85000.00, 'Ph.D. Mathematics'),
    ('555555555', 'Dr. Alice Brown', '789 University Blvd', 'Fullerton', 'CA', '92831', '714', '5559999', 'F', 'Lecturer', 70000.00, 'M.S. Computer Science');

-- 3.2) Departments
INSERT INTO Department 
    (DeptNo, DeptName, Telephone, OfficeLocation, ChairpersonSSN)
VALUES
    (1, 'Computer Science', '714-123-4567', 'CS-100', '123456789'),
    (2, 'Mathematics',     '714-234-5678', 'MH-200', '987654321'),
    (3, 'Game Development','714-345-6789', 'GD-300', '555555555');

-- 3.3) Courses
INSERT INTO Course 
    (CourseNo, CourseTitle, Textbook, Units, DeptNo)
VALUES
    (120, 'CPSC 120A Intro to Programming Lecture', 'Intro to C++', 3, 1),
    (121, 'CPSC 121A Object-Oriented Programming Lecture', 'OOP with C++', 3, 1),
    (254, 'CPSC 254 Software Development with Open Source Systems', 'Open Source Software Dev', 3, 1),
    (349, 'CPSC 349 Web Front-End Engineering', 'HTML, CSS, JS Mastery', 3, 1),
    (351, 'CPSC 351 Operating Systems Concepts', 'Operating System Concepts', 3, 1),
    (411, 'CPSC 411 Mobile Device Application Programming (iOS)', 'iOS Programming Guide', 3, 1),
    (431, 'CPSC 431 Database and Applications', 'Database Systems, 2nd Ed', 3, 1),
    (490, 'CPSC 490 Undergraduate Seminar in CS', 'No Textbook', 1, 1),
    (500, 'Math 150A Calculus 1', 'Calculus: Early Transcendentals', 4, 2),
    (501, 'Math 170B Math Structures 2', 'Discrete Mathematics & Its Applications', 3, 2),
    (486, 'CPSC 486 Game Programming', 'Game Programming Patterns', 3, 3),
    (489, 'CPSC 489 Game Development Project', 'Team-based Project Manual', 3, 3);

-- 3.4) Prerequisite
INSERT INTO Prerequisite (CourseNo, PrereqCourseNo)
VALUES
    (121, 120),  -- OOP requires Intro to Programming
    (254, 121),  -- Software Dev w/ OSS requires OOP
    (349, 121),  -- Web Front-End requires OOP
    (351, 121),  -- OS Concepts requires OOP
    (490, 351),  -- Seminar requires OS Concepts
    (489, 486);  -- Game Dev Project requires Game Programming

-- 3.5) Sections
INSERT INTO Section 
    (SectionNo, CourseNo, Classroom, Seats, MeetingDays, BeginTime, EndTime, ProfessorSSN)
VALUES
    (1, 120, 'CS-101', 30, 'MW', '09:00', '10:15', '123456789'),
    (2, 121, 'CS-102', 30, 'TR', '10:30', '11:45', '123456789'),
    (1, 254, 'CS-201', 25, 'MW', '12:00', '13:15', '555555555'),
    (1, 349, 'CS-202', 25, 'MW', '14:00', '15:15', '555555555'),
    (1, 490, 'CS-303', 15, 'F',  '09:00', '11:45', '987654321'),
    (1, 489, 'GD-100', 25, 'TR', '09:30', '10:45', '555555555'),
    (1, 500, 'MH-201', 30, 'MW', '10:30', '11:45', '987654321');

-- 3.6) Students
INSERT INTO Student 
    (CWID, FirstName, LastName, StreetAddress, City, State, ZipCode, AreaCode, PhoneNumber, MajorDeptNo)
VALUES
    (800000001, 'Alice',   'Williams', '111 Apple St',  'Irvine',     'CA', '92618', '949', '1111111', 1),
    (800000002, 'Bob',     'Johnson',  '222 Orange St', 'Anaheim',    'CA', '92804', '714', '2222222', 2),
    (800000003, 'Charlie', 'Kim',      '333 Banana Ave','Fullerton',  'CA', '92831', '714', '3333333', 1),
    (800000004, 'Diana',   'Lopez',    '444 Peach Rd',  'Brea',       'CA', '92821', '714', '4444444', 3),
    (800000005, 'Ethan',   'Garcia',   '555 Grape Dr',  'Yorba Linda','CA', '92887', '714', '5555555', 1);

-- 3.7) Student Minors
INSERT INTO StudentMinor (CWID, DeptNo)
VALUES
    (800000001, 2),  -- Alice: major=CS(1), minor=Math(2)
    (800000003, 2),  -- Charlie: major=CS(1), minor=Math(2)
    (800000004, 1),  -- Diana: major=GameDev(3), minor=CS(1)
    (800000005, 3);  -- Ethan: major=CS(1), minor=GameDev(3)

-- 3.8) Enrollments
INSERT INTO Enrollment (CWID, SectionNo, CourseNo, Grade)
VALUES
    (800000001, 1, 120, 'A-'),
    (800000001, 2, 121, 'C+'),
    (800000002, 1, 500, 'C'),
    (800000003, 1, 120, 'A'),
    (800000003, 2, 121, 'D'),
    (800000004, 1, 489, 'B'),
    (800000005, 1, 120, 'D+'),
    (800000005, 1, 254, 'F');
