-- ============================================
-- PART A : Common Table Expressions (CTEs)
-- ============================================

-- 1. CTE Simple : étudiants ayant une moyenne générale supérieure à 14
WITH GoodStudents AS (
    SELECT StudentID, AVG(Grade) AS AverageGrade
    FROM Enrollments
    GROUP BY StudentID
)
SELECT s.FirstName, s.LastName, g.AverageGrade
FROM GoodStudents g
JOIN Students s ON s.StudentID = g.StudentID
WHERE g.AverageGrade > 14
ORDER BY g.AverageGrade DESC;
GO

-- 2. Multiple CTEs : moyenne par étudiant + classification Pass/Fail
WITH StudentAverage AS (
    SELECT StudentID, AVG(Grade) AS AverageGrade
    FROM Enrollments
    GROUP BY StudentID
),
StudentStatus AS (
    SELECT StudentID, AverageGrade,
           CASE WHEN AverageGrade >= 12 THEN 'Pass' ELSE 'Fail' END AS Status
    FROM StudentAverage
)
SELECT s.FirstName, s.LastName, ss.AverageGrade, ss.Status
FROM StudentStatus ss
JOIN Students s ON s.StudentID = ss.StudentID
ORDER BY ss.AverageGrade DESC;
GO

-- 3. CTE Récursive : génère une séquence de 1 à 10 (simule un compteur de semestres)
WITH SemesterSequence AS (
    SELECT 1 AS SemesterNumber
    UNION ALL
    SELECT SemesterNumber + 1
    FROM SemesterSequence
    WHERE SemesterNumber < 10
)
SELECT * FROM SemesterSequence;
GO

-- 4. CTE avec Agrégation : statistiques par cours
WITH CourseStats AS (
    SELECT CourseID,
           COUNT(*) AS TotalEnrollments,
           AVG(Grade) AS AverageGrade,
           MAX(Grade) AS MaxGrade,
           MIN(Grade) AS MinGrade
    FROM Enrollments
    GROUP BY CourseID
)
SELECT c.CourseName, cs.TotalEnrollments, cs.AverageGrade, cs.MaxGrade, cs.MinGrade
FROM CourseStats cs
JOIN Courses c ON c.CourseID = cs.CourseID
ORDER BY cs.AverageGrade DESC;
GO

-- 5. CTE avec JOIN : meilleure note obtenue par chaque étudiant, avec le nom du cours
WITH BestGrades AS (
    SELECT StudentID, MAX(Grade) AS BestGrade
    FROM Enrollments
    GROUP BY StudentID
)
SELECT s.FirstName, s.LastName, c.CourseName, e.Grade, e.Semester
FROM BestGrades bg
JOIN Enrollments e ON e.StudentID = bg.StudentID AND e.Grade = bg.BestGrade
JOIN Students s ON s.StudentID = e.StudentID
JOIN Courses c ON c.CourseID = e.CourseID
ORDER BY e.Grade DESC;
GO