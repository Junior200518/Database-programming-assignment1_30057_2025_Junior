-- ============================================
-- PART B : SQL Window Functions
-- ============================================

-- 1. Ranking Functions : ROW_NUMBER, RANK, DENSE_RANK, PERCENT_RANK
SELECT 
    s.FirstName,
    s.LastName,
    AVG(e.Grade) AS AverageGrade,
    ROW_NUMBER() OVER (ORDER BY AVG(e.Grade) DESC) AS RowNum,
    RANK() OVER (ORDER BY AVG(e.Grade) DESC) AS Rank_,
    DENSE_RANK() OVER (ORDER BY AVG(e.Grade) DESC) AS DenseRank_,
    PERCENT_RANK() OVER (ORDER BY AVG(e.Grade) DESC) AS PercentRank_
FROM Enrollments e
JOIN Students s ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName
ORDER BY AverageGrade DESC;
GO

-- 2. Aggregate Window Functions : SUM, AVG, MAX, MIN OVER()
SELECT 
    s.FirstName,
    s.LastName,
    e.Semester,
    e.Grade,
    SUM(e.Grade) OVER (PARTITION BY s.StudentID) AS TotalGradesSum,
    AVG(e.Grade) OVER (PARTITION BY s.StudentID) AS StudentAverage,
    MAX(e.Grade) OVER (PARTITION BY s.StudentID) AS StudentMax,
    MIN(e.Grade) OVER (PARTITION BY s.StudentID) AS StudentMin
FROM Enrollments e
JOIN Students s ON s.StudentID = e.StudentID
ORDER BY s.StudentID, e.Semester;
GO

-- 3. Navigation Functions : LAG, LEAD
SELECT 
    s.FirstName,
    s.LastName,
    c.CourseName,
    e.Semester,
    e.Grade,
    LAG(e.Grade) OVER (PARTITION BY s.StudentID, c.CourseID ORDER BY e.Semester) AS PreviousGrade,
    LEAD(e.Grade) OVER (PARTITION BY s.StudentID, c.CourseID ORDER BY e.Semester) AS NextGrade
FROM Enrollments e
JOIN Students s ON s.StudentID = e.StudentID
JOIN Courses c ON c.CourseID = e.CourseID
ORDER BY s.StudentID, c.CourseID, e.Semester;
GO

-- 4. Distribution Functions : NTILE, CUME_DIST
SELECT 
    s.FirstName,
    s.LastName,
    AVG(e.Grade) AS AverageGrade,
    NTILE(4) OVER (ORDER BY AVG(e.Grade) DESC) AS Quartile,
    CUME_DIST() OVER (ORDER BY AVG(e.Grade) DESC) AS CumulativeDistribution
FROM Enrollments e
JOIN Students s ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName
ORDER BY AverageGrade DESC;
GO