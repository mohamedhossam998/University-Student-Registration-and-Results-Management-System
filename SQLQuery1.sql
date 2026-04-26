create database university;
use University;



-- 1. Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    HeadOfDepartment VARCHAR(100),
    CreatedAt Datetime
);

    BULK INSERT Departments
    FROM 'C:\Users\Admin\Downloads\New Database\Departmentcsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 2. Programs
-- A Department has many Programs
CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY,
    DepartmentID INT,
    ProgramName VARCHAR(100) NOT NULL,
    DegreeLevel VARCHAR(50), -- e.g., Bachelor, Master, PhD
    TotalCreditsRequired INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

    BULK INSERT programs
    FROM 'C:\Users\Admin\Downloads\New Database\Programscsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 3. Students
-- A Program has many Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    EnrollmentDate DATE,
    ProgramID INT,
    Status VARCHAR(20) DEFAULT 'Active', -- Active, Graduated, Suspended
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);


    BULK INSERT Students
    FROM 'C:\Users\Admin\Downloads\New Database\Studentcsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);



-- 4. Instructors
-- Instructors belong to Departments
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DepartmentID INT,
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

    BULK INSERT Instructors
    FROM 'C:\Users\Admin\Downloads\New Database\Instructorscsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- 5. Courses
-- Courses belong to Departments
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseCode VARCHAR(20)  NOT NULL,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


    BULK INSERT Courses
    FROM 'C:\Users\Admin\Downloads\New Database\Coursescsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- 6. Course Prerequisites
-- Self-referencing many-to-many relationship for course prerequisites
CREATE TABLE CoursePrerequisites (
    CourseID INT,
    PrerequisiteCourseID INT,
    PRIMARY KEY (CourseID, PrerequisiteCourseID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID)
);

    BULK INSERT CoursePrerequisites
    FROM 'C:\Users\Admin\Downloads\New Database\CoursePrerequisitescsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);




-- 6. Semesters
CREATE TABLE Semesters (
    SemesterID INT PRIMARY KEY,
    SemesterName VARCHAR(50) NOT NULL, -- e.g., Fall 2023, Spring 2024
    StartDate DATE,
    EndDate DATE
);

    BULK INSERT Semesters
    FROM 'C:\Users\Admin\Downloads\New Database\Semesterscsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);



-- 7. Sections
-- Instances of a Course offered in a specific Semester by an Instructor
CREATE TABLE Sections (
    SectionID INT PRIMARY KEY,
    CourseID INT,
    SemesterID INT,
    InstructorID INT,
    Capacity INT,
    RoomNumber VARCHAR(50),
    ScheduleInfo VARCHAR(100), -- e.g., 'Mon/Wed 10:00-11:30'
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (SemesterID) REFERENCES Semesters(SemesterID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

    BULK INSERT Sections
    FROM 'C:\Users\Admin\Downloads\New Database\Sectionscsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- 8. Enrollments
-- Students enroll in Sections
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    SectionID INT,
    EnrollmentDate DATETIME,
    Status VARCHAR(20) DEFAULT 'Enrolled', -- Enrolled, Dropped, Withdrawn
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID),
    UNIQUE (StudentID, SectionID) -- Prevent duplicate enrollments in the same section
);

    BULK INSERT Enrollments
    FROM 'C:\Users\Admin\Downloads\New Database\Enrollmentscsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 9. Grades
-- Students receive Grades for their Enrollments
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    EnrollmentID INT UNIQUE, -- One final grade per enrollment
    GradeLetter VARCHAR(2), -- A, B+, B, C, F
    GradePoints DECIMAL(3, 2), -- 4.0, 3.5, etc.
    Remarks VARCHAR(255),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

    BULK INSERT Grades
    FROM 'C:\Users\Admin\Downloads\New Database\Gradescsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- 10. Attendance
-- Attendance is recorded per student (enrollment) per section per class date
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    EnrollmentID INT,
    ClassDate DATE,
    Status VARCHAR(10), -- Present, Absent, Late
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),
    UNIQUE (EnrollmentID, ClassDate) -- One record per student per section per day
);

    BULK INSERT Attendance
    FROM 'C:\Users\Admin\Downloads\New Database\Attendancecsv.csv'
    WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


---------------------------------------------------------

    CREATE VIEW UniversityDataForEDA AS
    SELECT
 
    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentFullName,
    s.Gender,
    s.DateOfBirth,
    DateDIFF(YEAR, s.DateOfBirth, GETDATE()) AS ApproxAge,
    s.EnrollmentDate,
    s.Status AS StudentStatus,

    p.ProgramID,
    p.ProgramName,
    p.DegreeLevel,
    p.TotalCreditsRequired AS ProgramTotalCredits,

    d.DepartmentID,
    d.DepartmentName,
    d.HeadOfDepartment,

    e.EnrollmentID,
    e.EnrollmentDate AS CourseEnrollmentDate,
    e.Status AS EnrollmentStatus,

    sec.SectionID,
    sec.Capacity AS SectionCapacity,
    sec.RoomNumber,
    sec.ScheduleInfo,

    c.CourseID,
    c.CourseCode,
    c.CourseName,
    c.Credits AS CourseCredits,

    i.InstructorID,
    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorFullName,
    i.Email AS InstructorEmail,

    sem.SemesterID,
    sem.SemesterName,
    sem.StartDate AS SemesterStartDate,
    sem.EndDate AS SemesterEndDate,

    g.GradeID,
    g.GradeLetter,
    g.GradePoints

FROM
    Students s

LEFT JOIN Programs p ON s.ProgramID = p.ProgramID

LEFT JOIN Departments d ON p.DepartmentID = d.DepartmentID

INNER JOIN Enrollments e ON s.StudentID = e.StudentID

LEFT JOIN Sections sec ON e.SectionID = sec.SectionID

LEFT JOIN Courses c ON sec.CourseID = c.CourseID

LEFT JOIN Instructors i ON sec.InstructorID = i.InstructorID

LEFT JOIN Semesters sem ON sec.SemesterID = sem.SemesterID

LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID


select * from UniversityDataForEDA;

----------------------------------------------------------

-------------------------------------------------

CREATE VIEW StudentMasterView AS
SELECT

    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentFullName,
    s.FirstName,
    s.LastName,
    s.Email AS StudentEmail,
    s.Phone AS StudentPhone,
    s.Gender,
    s.DateOfBirth,
    DATEDIFF(YEAR, s.DateOfBirth, GETDATE()) AS CurrentAge,
    YEAR(s.DateOfBirth) AS BirthYear,
    s.EnrollmentDate AS UniversityStartDate,
    YEAR(s.EnrollmentDate) AS EnrollmentYear,
    s.Status AS CurrentStudentStatus,

    p.ProgramID,
    p.ProgramName,
    p.DegreeLevel,
    p.TotalCreditsRequired,

    d.DepartmentID,
    d.DepartmentName,
    d.HeadOfDepartment,


    -- عدد الكورسات الفريدة الالتحق بها الطالب
    COUNT(DISTINCT c.CourseID) AS NumberOfUniqueCoursesTaken,

    -- إجمالي محاولات التسجيل (العدد الإجمالي للصفوف في Enrollments)
    COUNT(e.EnrollmentID) AS TotalEnrollmentAttempts,

    -- عدد الشعب (Sections) التي التحق بها
    COUNT(DISTINCT sec.SectionID) AS TotalSectionsAttended,

    -- عدد المدرسين الذين درسوا له
    COUNT(DISTINCT i.InstructorID) AS TotalInstructors,

    -- عدد الفصول الدراسية المختلفة التي درس فيها
    COUNT(DISTINCT sem.SemesterID) AS TotalSemestersAttended,

    -- عدد المواد التي حصل فيها على درجة (Graded)
    COUNT(DISTINCT CASE WHEN g.GradeID IS NOT NULL THEN e.EnrollmentID END) AS NumberOfGradedCourses,

    -- المعدل التراكمي (GPA)
    AVG(g.GradePoints) AS GPA,

    -- مجموع نقاط الدرجات
    SUM(g.GradePoints) AS TotalGradePoints,

    -- أعلى وأدنى درجة حصل عليها
    MAX(g.GradeLetter) AS HighestGradeLetter,
    MIN(g.GradeLetter) AS LowestGradeLetter,

    -- عدد مرات الحصول على كل تقدير
    SUM(CASE WHEN g.GradeLetter = 'A' THEN 1 ELSE 0 END) AS Count_A,
    SUM(CASE WHEN g.GradeLetter = 'A-' THEN 1 ELSE 0 END) AS Count_A_minus,
    SUM(CASE WHEN g.GradeLetter = 'B+' THEN 1 ELSE 0 END) AS Count_B_plus,
    SUM(CASE WHEN g.GradeLetter = 'B' THEN 1 ELSE 0 END) AS Count_B,
    SUM(CASE WHEN g.GradeLetter = 'B-' THEN 1 ELSE 0 END) AS Count_B_minus,
    SUM(CASE WHEN g.GradeLetter = 'C+' THEN 1 ELSE 0 END) AS Count_C_plus,
    SUM(CASE WHEN g.GradeLetter = 'C' THEN 1 ELSE 0 END) AS Count_C,
    SUM(CASE WHEN g.GradeLetter = 'C-' THEN 1 ELSE 0 END) AS Count_C_minus,
    SUM(CASE WHEN g.GradeLetter = 'D' THEN 1 ELSE 0 END) AS Count_D,
    SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) AS Count_F,

    -- عدد المواد الناجح فيها (الدرجة ليست F)
    SUM(CASE WHEN g.GradeLetter != 'F' AND g.GradeLetter IS NOT NULL THEN 1 ELSE 0 END) AS NumberOfPassedCourses,

    -- عدد المواد الراسب فيها (F)
    SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) AS NumberOfFailedCourses,

    -- نسبة النجاح
    CASE 
        WHEN SUM(CASE WHEN g.GradeID IS NOT NULL THEN 1 ELSE 0 END) > 0 
        THEN (SUM(CASE WHEN g.GradeLetter != 'F' AND g.GradeLetter IS NOT NULL THEN 1 ELSE 0 END) * 100.0) 
             / SUM(CASE WHEN g.GradeID IS NOT NULL THEN 1 ELSE 0 END)
        ELSE 0 
    END AS SuccessRatePercentage,

    -- =========================================================================
    -- ⏳ 6. تحليل زمني (Timeline) - بدون تكرار
    -- =========================================================================

    -- تاريخ أول وآخر تسجيل كورس
    MIN(e.EnrollmentDate) AS FirstCourseEnrollmentDate,
    MAX(e.EnrollmentDate) AS LastCourseEnrollmentDate,

    -- أول وآخر فصل دراسي
    MIN(sem.SemesterName) AS FirstSemesterAttended,
    MAX(sem.SemesterName) AS LastSemesterAttended,

    -- عدد الأيام بين أول وآخر كورس (تم تعديلها لتناسب SQL Server 2008)
    DATEDIFF(DAY, MIN(e.EnrollmentDate), MAX(e.EnrollmentDate)) AS AcademicActiveDays

FROM
    Students s
LEFT JOIN Programs p ON s.ProgramID = p.ProgramID
LEFT JOIN Departments d ON p.DepartmentID = d.DepartmentID
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Sections sec ON e.SectionID = sec.SectionID
LEFT JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Instructors i ON sec.InstructorID = i.InstructorID
LEFT JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID

GROUP BY
    -- هنا بنحدد لكل طالب سطر واحد، وبنستخدم الدوال التجميعية فوق
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.Email,
    s.Phone,
    s.Gender,
    s.DateOfBirth,
    s.EnrollmentDate,
    s.Status,
    p.ProgramID,
    p.ProgramName,
    p.DegreeLevel,
    p.TotalCreditsRequired,
    d.DepartmentID,
    d.DepartmentName,
    d.HeadOfDepartment;

-- عرض النتيجة
SELECT * FROM StudentMasterView
ORDER BY TotalEnrollmentAttempts DESC;

-------------------------------------------------------------

-----------------Student Master View Q1-----------------------------------------
CREATE VIEW vw_StudentMaster AS
SELECT
    
    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS FullName,
    s.StudentID AS NationalID,  
    s.Gender,
    s.DateOfBirth AS DOB,
    
    p.ProgramName,
    d.DepartmentName,

    s.EnrollmentDate,
    s.Status AS AcademicStatus,
    

    DATEDIFF(YEAR, s.DateOfBirth, GETDATE()) AS Age
    

FROM Students s
LEFT JOIN Programs p ON s.ProgramID = p.ProgramID
LEFT JOIN Departments d ON p.DepartmentID = d.DepartmentID;

select *
from vw_StudentMaster
where AcademicStatus = 'Active';
----------------------------------------------------------

----------------------Semester Course Load Q2----------------------------------
CREATE VIEW vw_StudentCourseLoad AS
SELECT 
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    sem.SemesterName,
    c.CourseCode,
    c.CourseName,
    c.Credits AS CreditHours,
    sec.SectionID,
    s.StudentID,
    sem.SemesterID
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
JOIN Courses c ON sec.CourseID = c.CourseID


SELECT *
FROM vw_StudentCourseLoad
where StudentID = 430 AND SemesterID = 1;
-----------------------------------------------------------------

-----------Course Enrollment & Capacity Report Q3----------------
SELECT 
    c.CourseCode,
    sec.SectionID,
    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName,
    sec.Capacity,
    COUNT(e.EnrollmentID) AS EnrolledCount,
    (sec.Capacity - COUNT(e.EnrollmentID)) AS RemainingSeats
FROM Sections sec
JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Instructors i ON sec.InstructorID = i.InstructorID
LEFT JOIN Enrollments e ON sec.SectionID = e.SectionID AND e.Status = 'Enrolled'
WHERE sec.SemesterID = 2
GROUP BY sec.SectionID,
c.CourseCode,
i.FirstName,
i.LastName,
sec.Capacity
ORDER BY RemainingSeats ASC;
----------------------------------------------------------------

-----------------Semester GPA Q4--------------------------------
CREATE VIEW vw_SemesterGPA AS
SELECT 
    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentFullName,
    sec.SemesterID,
    sem.SemesterName,
    
    SUM(c.Credits) AS TotalCreditsAttempted,
    
    SUM(c.Credits * g.GradePoints) AS TotalQualityPoints,
    
    CASE 
        WHEN SUM(c.Credits) > 0 
        THEN ROUND(SUM(c.Credits * g.GradePoints) / SUM(c.Credits), 2)
        ELSE 0 
    END AS SemesterGPA,
    
    COUNT(e.EnrollmentID) AS CoursesTakenInSemester,
    
    SUM(CASE WHEN g.GradeLetter != 'F' THEN 1 ELSE 0 END) AS PassedCourses,
    
    SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) AS FailedCourses

FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID

WHERE g.GradePoints IS NOT NULL 

GROUP BY 
    s.StudentID,
    s.FirstName,
    s.LastName,
    sec.SemesterID,
    sem.SemesterName;

select *
from vw_SemesterGPA;
-------------------------------------------------------

-------------Cumulative GPA Q5-------------------------
SELECT TOP 20
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    p.ProgramName,
    SUM(c.Credits) AS TotalCredits,
    
    -- حساب CGPA مع تجنب القسمة على صفر
    CASE 
        WHEN SUM(c.Credits) > 0 
        THEN ROUND(SUM(c.Credits * g.GradePoints) / SUM(c.Credits), 2)
        ELSE 0 
    END AS CGPA

FROM Students s
JOIN Programs p ON s.ProgramID = p.ProgramID
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
JOIN Grades g ON e.EnrollmentID = g.EnrollmentID

WHERE g.GradePoints IS NOT NULL 

GROUP BY 
    s.StudentID,
    s.FirstName,
    s.LastName,
    p.ProgramName

ORDER BY CGPA DESC;
----------------------------------------------------

--------------At risk student Q6--------------------
SELECT 
    s.FirstName + ' ' + s.LastName AS StudentName,
    sem.SemesterName,
    AVG(g.GradePoints) AS GPA,
    SUM(CASE WHEN g.GradeLetter = 'F' THEN c.Credits ELSE 0 END) AS FailedCredits,
    'No Advisor' AS Advisor
FROM Students s, Enrollments e, Sections sec, Semesters sem, Courses c, Grades g
WHERE s.StudentID = e.StudentID 
  AND e.SectionID = sec.SectionID
  AND sec.SemesterID = sem.SemesterID
  AND sec.CourseID = c.CourseID
  AND e.EnrollmentID = g.EnrollmentID
  AND sem.SemesterID = (SELECT MAX(SemesterID) FROM Semesters)
GROUP BY s.StudentID, s.FirstName, s.LastName, sem.SemesterName
HAVING AVG(g.GradePoints) < 2.0 OR SUM(CASE WHEN g.GradeLetter = 'F' THEN c.Credits ELSE 0 END) >= 6;
----------------------------------------------------

------------------Prerequisite Validation Q7-------
SELECT 
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    c.CourseName AS CourseEnrolled,
    c2.CourseName AS MissingPrerequisiteCourse
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
JOIN CoursePrerequisites cp ON c.CourseID = cp.CourseID
JOIN Courses c2 ON cp.PrerequisiteCourseID = c2.CourseID
LEFT JOIN Enrollments e2 ON s.StudentID = e2.StudentID
LEFT JOIN Sections sec2 ON e2.SectionID = sec2.SectionID AND sec2.CourseID = cp.PrerequisiteCourseID
LEFT JOIN Grades g2 ON e2.EnrollmentID = g2.EnrollmentID AND g2.GradeLetter != 'F'
WHERE g2.EnrollmentID IS NULL -- And  s.StudentID = 450
ORDER BY s.StudentID, c.CourseName;
--------------------------------------------------

-----Course Pass Rate by Department Q8------------
SELECT 
    d.DepartmentName,
    c.CourseCode,
    c.CourseName,
    COUNT(e.EnrollmentID) AS TotalEnrolled,
    SUM(CASE WHEN g.GradeLetter != 'F' THEN 1 ELSE 0 END) AS PassedCount,
    SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) AS FailedCount,
    ROUND(
        (SUM(CASE WHEN g.GradeLetter != 'F' THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(e.EnrollmentID), 2
    ) AS PassRate
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Sections sec ON c.CourseID = sec.CourseID
JOIN Enrollments e ON sec.SectionID = e.SectionID
LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
WHERE sec.SemesterID = 3 
  AND g.GradeLetter IS NOT NULL
GROUP BY d.DepartmentName, c.CourseCode, c.CourseName
ORDER BY PassRate DESC, d.DepartmentName;

SELECT TOP 5 * FROM (
    --code
) AS Results
ORDER BY PassRate DESC;
-------------------------------------------------------

----------------Instructor Workload & Performance View Q9
CREATE VIEW vw_InstructorPerformance AS
SELECT 

    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName,
    d.DepartmentName,
    
    sem.SemesterID,
    sem.SemesterName,
    
    COUNT(DISTINCT sec.SectionID) AS SectionsTaught,
    COUNT(DISTINCT e.StudentID) AS TotalStudents,
    
    ROUND(AVG(g.GradePoints), 2) AS AverageGradePoint,
    
    ROUND(
        (SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) * 100.0) 
        / NULLIF(COUNT(g.GradeID), 0), 2
    ) AS FailRate,
    
    COUNT(g.GradeID) AS TotalGradesGiven,
    SUM(CASE WHEN g.GradeLetter = 'F' THEN 1 ELSE 0 END) AS FailedCount,
    SUM(CASE WHEN g.GradeLetter != 'F' THEN 1 ELSE 0 END) AS PassedCount

FROM Instructors i
LEFT JOIN Departments d ON i.DepartmentID = d.DepartmentID
LEFT JOIN Sections sec ON i.InstructorID = sec.InstructorID
LEFT JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
LEFT JOIN Enrollments e ON sec.SectionID = e.SectionID
LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID

GROUP BY 
    i.InstructorID,
    i.FirstName,
    i.LastName,
    d.DepartmentName,
    sem.SemesterID,
    sem.SemesterName;

select * from vw_InstructorPerformance;

--top 10 
SELECT TOP 10
    InstructorName,
    DepartmentName,
    SectionsTaught,
    TotalStudents,
    AverageGradePoint,
    FailRate
FROM vw_InstructorPerformance
WHERE SemesterID = (SELECT MAX(SemesterID) FROM Semesters)
ORDER BY AverageGradePoint DESC;

--Best Instructor
SELECT 
    InstructorName,
    DepartmentName,
    AverageGradePoint,
    FailRate,
    TotalStudents
FROM vw_InstructorPerformance
WHERE TotalStudents > 0
ORDER BY AverageGradePoint DESC;

--fail rate > 20%
SELECT 
    InstructorName,
    DepartmentName,
    FailRate,
    AverageGradePoint,
    TotalStudents
FROM vw_InstructorPerformance
WHERE FailRate > 20  
ORDER BY FailRate DESC;
---------------------------------------------

-----------------Attendance Analytics--------
CREATE VIEW vw_AttendanceEligibility AS
SELECT 
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    c.CourseCode,
    c.CourseName,
    sem.SemesterName,

    COUNT(a.AttendanceID) AS TotalClasses,
    SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) AS PresentCount,
    SUM(CASE WHEN a.Status = 'Late' THEN 1 ELSE 0 END) AS LateCount,
    SUM(CASE WHEN a.Status = 'Absent' THEN 1 ELSE 0 END) AS AbsentCount,

    ROUND(
        (SUM(CASE WHEN a.Status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100.0) 
        / NULLIF(COUNT(a.AttendanceID), 0), 2
    ) AS AttendancePercent,

    CASE 
        WHEN (SUM(CASE WHEN a.Status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100.0) 
             / NULLIF(COUNT(a.AttendanceID), 0) >= 75 
        THEN 'Eligible' 
        ELSE 'Not Eligible' 
    END AS ExamEligibility
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Sections sec ON e.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
LEFT JOIN Attendance a ON e.EnrollmentID = a.EnrollmentID
GROUP BY 
s.StudentID,
s.FirstName,
s.LastName,
c.CourseCode,
c.CourseName,
sem.SemesterName;

SELECT * FROM vw_AttendanceEligibility
ORDER BY AttendancePercent, SemesterName;


--student Not Eligible
SELECT 
    StudentName,
    CourseCode,
    SemesterName,
    AttendancePercent,
    PresentCount,
    LateCount,
    AbsentCount
FROM vw_AttendanceEligibility
WHERE ExamEligibility = 'Not Eligible'
ORDER BY AttendancePercent DESC;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Add New Student 
CREATE PROCEDURE sp_AddStudent
    @StudentID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @Gender NVARCHAR(10),
    @DateOfBirth DATE,
    @ProgramID INT
AS
BEGIN
    INSERT INTO Students (StudentID, FirstName, LastName, Email, Phone, Gender, DateOfBirth, EnrollmentDate, ProgramID, Status)
    VALUES (@StudentID, @FirstName, @LastName, @Email, @Phone, @Gender, @DateOfBirth, GETDATE(), @ProgramID, 'Active');
    
    SELECT @StudentID AS NewStudentID;
END;

EXEC sp_AddStudent 1200, 'Ahmed', 'Ali', 'ahmed@email.com', '0123456789', 'Male', '2000-01-01', 1;
EXEC sp_AddStudent 'Ahmed', 'Ali', 'ahmed@email.com', '0123456789', 'Male', '2000-01-01', 1;
select * 
from Students
where StudentID=1200;
---------------------------------------------------------------------------------
--update Student
CREATE PROCEDURE sp_UpdateStudent
    @StudentID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @Status NVARCHAR(20)
AS
BEGIN
    UPDATE Students
    SET FirstName = @FirstName,
        LastName = @LastName,
        Email = @Email,
        Phone = @Phone,
        Status = @Status
    WHERE StudentID = @StudentID;
    
    SELECT @@ROWCOUNT AS RowsAffected;
END;
--------------------------------------------------------------------
--Delete Student
CREATE PROCEDURE sp_DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Students WHERE StudentID = @StudentID;
    SELECT @@ROWCOUNT AS RowsAffected;
END;
--------------------------------------------------------------------
--search Student
CREATE PROCEDURE sp_SearchStudent
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SELECT 
        s.StudentID,
        CONCAT(s.FirstName, ' ', s.LastName) AS FullName,
        s.Email,
        s.Phone,
        s.Gender,
        s.DateOfBirth,
        s.EnrollmentDate,
        s.Status,
        p.ProgramName,
        d.DepartmentName
    FROM Students s
    JOIN Programs p ON s.ProgramID = p.ProgramID
    JOIN Departments d ON p.DepartmentID = d.DepartmentID
    WHERE s.FirstName LIKE '%' + @SearchTerm + '%'
       OR s.LastName LIKE '%' + @SearchTerm + '%'
       OR s.Email LIKE '%' + @SearchTerm + '%';
END;
---------------------------------------------------------------
--EnrollStudent
CREATE PROCEDURE sp_EnrollStudent
    @StudentID INT,
    @SectionID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM CoursePrerequisites cp
        JOIN Sections sec ON cp.CourseID = sec.CourseID
        LEFT JOIN Enrollments e ON e.StudentID = @StudentID
        LEFT JOIN Sections sec2 ON e.SectionID = sec2.SectionID
        LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
        WHERE sec.SectionID = @SectionID
          AND cp.PrerequisiteCourseID NOT IN (
              SELECT sec2.CourseID
              FROM Enrollments e2
              JOIN Sections sec2 ON e2.SectionID = sec2.SectionID
              JOIN Grades g2 ON e2.EnrollmentID = g2.EnrollmentID
              WHERE e2.StudentID = @StudentID
                AND g2.GradeLetter != 'F'
          )
    )
    BEGIN
        INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Status)
        VALUES (@StudentID, @SectionID, GETDATE(), 'Enrolled');
        
        SELECT 'Enrolled Successfully' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Prerequisites not met' AS Message;
    END;
END;
---------------------------------------------------------------
--Drop Enroll
CREATE PROCEDURE sp_DropEnrollment
    @EnrollmentID INT
AS
BEGIN
    DELETE FROM Enrollments WHERE EnrollmentID = @EnrollmentID;
    SELECT @@ROWCOUNT AS RowsAffected;
END;
--------------------------------------------------------------
--Student Schedule
CREATE PROCEDURE sp_StudentSchedule
    @StudentID INT,
    @SemesterID INT = NULL
AS
BEGIN
    IF @SemesterID IS NULL
        SET @SemesterID = (SELECT MAX(SemesterID) FROM Semesters);
    
    SELECT 
        c.CourseCode,
        c.CourseName,
        sec.SectionID,
        sem.SemesterName,
        sec.ScheduleInfo,
        sec.RoomNumber,
        CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName
    FROM Enrollments e
    JOIN Sections sec ON e.SectionID = sec.SectionID
    JOIN Courses c ON sec.CourseID = c.CourseID
    JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
    JOIN Instructors i ON sec.InstructorID = i.InstructorID
    WHERE e.StudentID = @StudentID
      AND sec.SemesterID = @SemesterID
      AND e.Status = 'Enrolled'
    ORDER BY sec.ScheduleInfo;
END;

exec sp_StudentSchedule
@StudentID = 110,
@SemesterID = 2;

--------------------------------------------------------------
--Add Grade
CREATE PROCEDURE sp_AddGrade
    @EnrollmentID INT,
    @GradeLetter NVARCHAR(2),
    @GradePoints DECIMAL(3,2)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM Enrollments WHERE EnrollmentID = @EnrollmentID)
    BEGIN

        DELETE FROM Grades WHERE EnrollmentID = @EnrollmentID;
        

        INSERT INTO Grades (EnrollmentID, GradeLetter, GradePoints, Remarks)
        VALUES (@EnrollmentID, @GradeLetter, @GradePoints, 'Entered by Instructor');
        
        SELECT 'Grade added successfully' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Enrollment not found' AS Message;
    END;
END;

EXECUTE sp_AddGrade 
    @EnrollmentID = 1, 
    @GradeLetter = 'B', 
    @GradePoints = 3.30;

    
-----------------------------------------------------------
--CalculateSemesterGPA
CREATE PROCEDURE sp_CalculateSemesterGPA
    @StudentID INT,
    @SemesterID INT
AS
BEGIN
    SELECT 
        CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
        sem.SemesterName,
        SUM(c.Credits) AS TotalCredits,
        ROUND(SUM(c.Credits * g.GradePoints) / NULLIF(SUM(c.Credits), 0), 2) AS SemesterGPA
    FROM Students s
    JOIN Enrollments e ON s.StudentID = e.StudentID
    JOIN Sections sec ON e.SectionID = sec.SectionID
    JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
    JOIN Courses c ON sec.CourseID = c.CourseID
    JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
    WHERE s.StudentID = @StudentID
      AND sec.SemesterID = @SemesterID
    GROUP BY s.StudentID, s.FirstName, s.LastName, sem.SemesterName;
END;

EXEC sp_CalculateSemesterGPA 
    @StudentID = 1,
    @SemesterID = 2;
------------------------------------------------------------
--Add Instructor 
CREATE PROCEDURE sp_AddInstructor
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DepartmentID INT,
    @HireDate DATE = NULL
AS
BEGIN
    IF @HireDate IS NULL
        SET @HireDate = GETDATE();
    
    INSERT INTO Instructors (FirstName, LastName, Email, DepartmentID, HireDate)
    VALUES (@FirstName, @LastName, @Email, @DepartmentID, @HireDate);
    
    SELECT SCOPE_IDENTITY() AS NewInstructorID;
END;
--------------------------------------------------------------
--Add Department 
CREATE PROCEDURE sp_AddDepartment
    @DepartmentName NVARCHAR(100),
    @HeadOfDepartment NVARCHAR(100)
AS
BEGIN
    INSERT INTO Departments (DepartmentName, HeadOfDepartment, CreatedAt)
    VALUES (@DepartmentName, @HeadOfDepartment, GETDATE());
    
    SELECT SCOPE_IDENTITY() AS NewDepartmentID;
END;
----------------------------------------------------------------
--Add Program
CREATE PROCEDURE sp_AddProgram
    @DepartmentID INT,
    @ProgramName NVARCHAR(100),
    @DegreeLevel NVARCHAR(50),
    @TotalCreditsRequired INT
AS
BEGIN
    INSERT INTO Programs (DepartmentID, ProgramName, DegreeLevel, TotalCreditsRequired)
    VALUES (@DepartmentID, @ProgramName, @DegreeLevel, @TotalCreditsRequired);
    
    SELECT SCOPE_IDENTITY() AS NewProgramID;
END;
--------------------------------------------------------------