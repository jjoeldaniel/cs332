-- Dropping ALL old tables

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Professor;

-- Creating tables

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

CREATE TABLE Department (
    DeptNo INT PRIMARY KEY,
    DeptName VARCHAR(255),
    Telephone VARCHAR(20),
    OfficeLocation VARCHAR(255),
    ChairpersonSSN VARCHAR(9),
    FOREIGN KEY (ChairpersonSSN) REFERENCES Professor(SSN)
);

CREATE TABLE Course (
    CourseNo INT PRIMARY KEY,
    CourseTitle VARCHAR(255),
    Textbook VARCHAR(255),
    Units INT,
    DeptNo INT,
    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo)
);

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

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
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

CREATE TABLE Enrollment (
    StudentID INT,
    SectionNo INT,
    CourseNo INT,
    Grade VARCHAR(2),
    PRIMARY KEY (StudentID, SectionNo, CourseNo),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SectionNo, CourseNo) REFERENCES Section(SectionNo, CourseNo)
);

-- Inserting data

INSERT INTO Professor (SSN, Name, StreetAddress, City, State, ZipCode, AreaCode, PhoneNumber, Sex, Title, Salary, CollegeDegrees) VALUES
('123456789', 'John Doe', '123 Main St', 'Anytown', 'CA', '12345', '123', '4567890', 'Male', 'Professor', 60000, 'Ph.D.'),
('987654321', 'Jane Smith', '456 Oak Ave', 'Somecity', 'NY', '67890', '456', '7890123', 'Female', 'Associate Professor', 70000, 'M.S.'),
('567890123', 'David Lee', '789 Pine Ln', 'Otherville', 'TX', '54321', '789', '0123456', 'Male', 'Assistant Professor', 55000, 'B.S.');

INSERT INTO Department (DeptNo, DeptName, Telephone, OfficeLocation, ChairpersonSSN) VALUES
(101, 'Computer Science', '555-1234', 'Building A', '123456789'),
(102, 'Mathematics', '555-5678', 'Building B', '987654321');

INSERT INTO Course (CourseNo, CourseTitle, Textbook, Units, DeptNo) VALUES
(201, 'Introduction to Programming', 'Programming for Dummies', 3, 101),
(202, 'Data Structures and Algorithms', 'CLRS', 4, 101),
(203, 'Calculus I', 'Stewart Calculus', 4, 102),
(204, 'Linear Algebra', 'Linear Algebra Done Right', 3, 102);

INSERT INTO Section (SectionNo, CourseNo, Classroom, Seats, MeetingDays, BeginTime, EndTime, ProfessorSSN) VALUES
(1, 201, 'Room 101', 30, 'MWF', '08:00:00', '08:50:00', '123456789'),
(2, 201, 'Room 102', 25, 'TTh', '09:00:00', '10:15:00', '123456789'),
(1, 202, 'Room 201', 35, 'MWF', '10:00:00', '10:50:00', '987654321'),
(1, 203, 'Room 301', 40, 'MWF', '11:00:00', '11:50:00', '567890123'),
(2, 203, 'Room 302', 30, 'TTh', '12:00:00', '13:15:00', '567890123'),
(1, 204, 'Room 401', 25, 'MWF', '13:00:00', '13:50:00', '987654321');

INSERT INTO Student (StudentID, FirstName, LastName, StreetAddress, City, State, ZipCode, AreaCode, PhoneNumber, MajorDeptNo) VALUES
(1, 'Alice', 'Wonderland', '123 Main St', 'Anytown', 'CA', '12345', '123', '4567890', 101),
(2, 'Bob', 'The Builder', '456 Oak Ave', 'Somecity', 'NY', '67890', '456', '7890123', 102),
(3, 'Charlie', 'Brown', '789 Pine Ln', 'Otherville', 'TX', '54321', '789', '0123456', 101),
(4, 'David', 'Copperfield', '101 Elm St', 'Anytown', 'CA', '12345', '123', '4567891', 102),
(5, 'Emily', 'Dickinson', '202 Oak Ave', 'Somecity', 'NY', '67890', '456', '7890124', 101),
(6, 'Frank', 'Sinatra', '303 Pine Ln', 'Otherville', 'TX', '54321', '789', '0123457', 102),
(7, 'Grace', 'Hopper', '404 Elm St', 'Anytown', 'CA', '12345', '123', '4567892', 101),
(8, 'Henry', 'Ford', '505 Oak Ave', 'Somecity', 'NY', '67890', '456', '7890125', 102);

INSERT INTO Enrollment (StudentID, SectionNo, CourseNo, Grade) VALUES
(1, 1, 201, 'A'),
(1, 1, 202, 'B'),
(2, 1, 203, 'C'),
(3, 2, 201, 'B'),
(4, 1, 204, 'A'),
(5, 1, 201, 'C'),
(6, 2, 203, 'A'),
(7, 1, 202, 'B'),
(8, 1, 203, 'B'),
(1, 2, 201, 'A'),
(2, 1, 204, 'C'),
(3, 1, 202, 'A'),
(4, 2, 203, 'B'),
(5, 1, 203, 'B'),
(6, 1, 204, 'A'),
(7, 2, 201, 'C'),
(8, 1, 202, 'A'),
(1, 1, 204, 'B'),
(2, 2, 201, 'B'),
(3, 1, 203, 'A');
