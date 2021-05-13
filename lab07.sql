USE Merh_Univer


-----1
SELECT	max(AUDITORIUM_CAPACITY) [Max capacity],
		min(AUDITORIUM_CAPACITY) [Min capacity],
		avg(AUDITORIUM_CAPACITY) [Average capacity],
		sum(AUDITORIUM_CAPACITY) [Summary capacity],
		count(*) [Amount]
FROM AUDITORIUM

-----2
SELECT	AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
		max(AUDITORIUM_CAPACITY) [Max capacity],
		min(AUDITORIUM_CAPACITY) [Min capacity],
		avg(AUDITORIUM_CAPACITY) [Average capacity],
		sum(AUDITORIUM_CAPACITY) [Summary capacity],
		count(*) [Amount]
FROM AUDITORIUM A INNER JOIN AUDITORIUM_TYPE 
	ON A.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
	group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

-----3
SELECT * FROM (SELECT 
			CASE WHEN A.NOTE=10 THEN '10'
				 WHEN A.NOTE BETWEEN 8 AND 9 THEN '8-9'
				 WHEN A.NOTE BETWEEN 6 AND 7 THEN '6-7'
				 WHEN A.NOTE BETWEEN 4 AND 5 THEN '4-5'
				 END AS 'MARKS' , COUNT(*) [NUMBER]
		FROM PROGRESS A
		GROUP BY CASE 
				 WHEN A.NOTE=10 THEN '10'
				 WHEN A.NOTE BETWEEN 8 AND 9 THEN '8-9'
				 WHEN A.NOTE BETWEEN 6 AND 7 THEN '6-7'
				 WHEN A.NOTE BETWEEN 4 AND 5 THEN '4-5'
				 END) AS B
ORDER BY CASE B.MARKS
				 WHEN '10' THEN 1
				 WHEN '8-9'THEN 2
				 WHEN '6-7' THEN 3
				 WHEN '4-5' THEN 4
				 END

------4
SELECT  A.FACULTY 'FACULTY',
		B.PROFESSION 'PROFESSION',
		B.YEAR_FIRST-2009 'COURSE',
		ROUND(AVG(CAST(D.NOTE AS FLOAT(4))),2) 'AVER_MARK'
FROM FACULTY A INNER JOIN GROUPS B
	ON A.FACULTY=B.FACULTY
	INNER JOIN STUDENT C
	ON C.IDGROUP=B.IDGROUP
	INNER JOIN PROGRESS D
	ON D.IDSTUDENT=C.IDSTUDENT
GROUP BY B.PROFESSION, B.YEAR_FIRST, A.FACULTY
ORDER BY AVER_MARK DESC

--ONLY DB, OAP
SELECT  A.FACULTY 'FACULTY',
		B.PROFESSION 'PROFESSION',
		B.YEAR_FIRST-2009 'COURSE',
		ROUND(AVG(CAST(D.NOTE AS FLOAT(4))),2) 'AVER_MARK'
FROM FACULTY A INNER JOIN GROUPS B
	ON A.FACULTY=B.FACULTY
	INNER JOIN STUDENT C
	ON C.IDGROUP=B.IDGROUP
	INNER JOIN PROGRESS D
	ON D.IDSTUDENT=C.IDSTUDENT
WHERE D.SUBJECT = '����' OR D.SUBJECT = '����'
GROUP BY B.PROFESSION, B.YEAR_FIRST, A.FACULTY
ORDER BY AVER_MARK DESC

------5
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT,
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			 FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT

SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT,
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			 FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY ROLLUP( FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT )
------6
SELECT GROUPS.PROFESSION, PROGRESS.SUBJECT,
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			 FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY CUBE( FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT )

-----7
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '����'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT
UNION 
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT

------8
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '����'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT
INTERSECT
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT
-----9
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '����'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT
EXCEPT 
SELECT FACULTY.FACULTY, GROUPS.PROFESSION,
			 PROGRESS.SUBJECT, 
			 ROUND( AVG( CAST (PROGRESS.NOTE AS FLOAT(3)) ), 2 ) AS �������_������
			  FROM GROUPS
				JOIN FACULTY
					ON GROUPS.FACULTY = FACULTY.FACULTY
				JOIN STUDENT
					ON STUDENT.IDGROUP = GROUPS.IDGROUP
				JOIN PROGRESS
					ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE FACULTY.FACULTY = '���'
				GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION,
				PROGRESS.SUBJECT

-----10
SELECT PROGRESS.SUBJECT, PROGRESS.NOTE, COUNT( PROGRESS.IDSTUDENT ) AS NUMBER
	FROM PROGRESS
	GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE
	HAVING PROGRESS.NOTE = 8 OR PROGRESS.NOTE = 9

-----12
SELECT GROUPS.FACULTY, STUDENT.IDGROUP,
		COUNT(STUDENT.IDSTUDENT) AS [STUDENTS]
FROM STUDENT, GROUPS
WHERE GROUPS.IDGROUP = STUDENT.IDGROUP
GROUP BY ROLLUP (GROUPS.FACULTY, STUDENT.IDGROUP);


SELECT AUDITORIUM_TYPE AS [TYPE], 
		AUDITORIUM_CAPACITY AS [CAPACITY],
		CASE 
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-1' THEN 1
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-2' THEN 2
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-3' THEN 3
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-4' THEN 4
		END [CORP], COUNT(*) AS 'AMOUNT'
FROM AUDITORIUM 
GROUP BY AUDITORIUM_TYPE, AUDITORIUM_CAPACITY,
CASE 
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-1' THEN 1
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-2' THEN 2
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-3' THEN 3
			WHEN AUDITORIUM.AUDITORIUM LIKE '%-4' THEN 4
		END WITH ROLLUP
---MYBASE
USE [Merh MyBase]
GO

SELECT	max([Experience(months)]) [Max exp],
		min([Experience(months)]) [Min exp],
		avg([Experience(months)]) [Average exp],
		sum([Experience(months)]) [Summary exp],
		count(*) [Amount]
FROM Workers_

SELECT Worker_ID,
		COUNT(Quantity) AS [workers]
FROM Works_
GROUP BY ROLLUP (Worker_ID, Quantity);