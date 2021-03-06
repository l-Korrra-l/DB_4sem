use Merh_Univer
GO

--?1
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE

--?2
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE 
		ON AUDITORIUM.[AUDITORIUM_TYPE]=AUDITORIUM_TYPE.AUDITORIUM_TYPE AND AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%?????????%'

--?3
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
		FROM AUDITORIUM, AUDITORIUM_TYPE
		WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

SELECT A.AUDITORIUM, B.AUDITORIUM_TYPENAME
		FROM AUDITORIUM AS A, AUDITORIUM_TYPE AS B
		WHERE A.AUDITORIUM_TYPE = B.AUDITORIUM_TYPE AND B.AUDITORIUM_TYPENAME LIKE '%?????????%';

--?4
SELECT FACULTY.FACULTY_NAME AS '?????????',
			PULPIT.PULPIT_NAME AS '???????',
			GROUPS.PROFESSION AS '?????????????',
			SUBJECT.SUBJECT_NAME AS '???????',
			STUDENT.NAME AS '???????',
CASE
	WHEN PROGRESS.NOTE = 6 THEN '?????'
	WHEN PROGRESS.NOTE = 7 THEN '????'
	WHEN PROGRESS.NOTE = 8 THEN '??????'
END '??????'
FROM GROUPS
	INNER JOIN STUDENT ON GROUPS.IDGROUP = STUDENT.IDGROUP
	INNER JOIN FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
	INNER JOIN PROFESSION ON GROUPS.PROFESSION  = PROFESSION.PROFESSION
	INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
	INNER JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
	INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
	AND PROGRESS.NOTE BETWEEN 6 AND 8
	ORDER BY FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION, STUDENT.NAME ASC, PROGRESS.NOTE DESC;

--?5

SELECT FACULTY.FACULTY_NAME AS '?????????',
			PULPIT.PULPIT_NAME AS '???????',
			GROUPS.PROFESSION AS '?????????????',
			SUBJECT.SUBJECT_NAME AS '???????',
			STUDENT.NAME AS '???????',
CASE
	WHEN PROGRESS.NOTE = 6 THEN '?????'
	WHEN PROGRESS.NOTE = 7 THEN '????'
	WHEN PROGRESS.NOTE = 8 THEN '??????'
END '??????'
FROM GROUPS
	INNER JOIN STUDENT ON GROUPS.IDGROUP = STUDENT.IDGROUP
	INNER JOIN FACULTY ON GROUPS.FACULTY = FACULTY.FACULTY
	INNER JOIN PROFESSION ON GROUPS.PROFESSION  = PROFESSION.PROFESSION
	INNER JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
	INNER JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
	INNER JOIN PROGRESS ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 AND 8
	ORDER BY 
	(CASE 
		WHEN PROGRESS.NOTE = 6 THEN 3
		WHEN PROGRESS.NOTE = 8 THEN 2
		ELSE 1
	 END);

--?6
SELECT isnull(TEACHER.TEACHER_NAME, '***')[?????????????], PULPIT.PULPIT_NAME[???????]
		FROM PULPIT LEFT OUTER JOIN TEACHER
		ON TEACHER.PULPIT=PULPIT.PULPIT

SELECT isnull(TEACHER.TEACHER_NAME, '***')[?????????????], PULPIT.PULPIT_NAME[???????]
		FROM TEACHER LEFT OUTER JOIN PULPIT
		ON TEACHER.PULPIT=PULPIT.PULPIT

--?7

SELECT isnull(TEACHER.TEACHER_NAME, '***')[?????????????], PULPIT.PULPIT_NAME[???????]
		FROM TEACHER RIGHT OUTER JOIN PULPIT
		ON TEACHER.PULPIT=PULPIT.PULPIT

--?8
USE Merh_Univer
GO
drop table T1
drop table T2
CREATE TABLE T1 (
	NUM INT CONSTRAINT T1_PK PRIMARY KEY,
	STRING NVARCHAR(10)
	);
INSERT T1 (NUM, STRING)
VALUES	(1, 'STR1'),
		(2, 'STR2'),
		(3, 'STR3'),
		(4, 'STR4');
CREATE TABLE T2 (
	NM INT CONSTRAINT T2_FK FOREIGN KEY REFERENCES T1(NUM),
	ST NVARCHAR(10) 
	);
INSERT T2 (NM, ST)
VALUES (1, 'STR5'),
		(2, 'STR6'),
		(3, 'STR7'),
		(4, 'STR8');

INSERT T2 (NM)
VALUES (5);
INSERT T1 (NUM)
VALUES (6);

SELECT *from T1
SELECT *from T2
--???????????????:
SELECT * FROM T1 a FULL OUTER JOIN T2 b
ON a.NUM = b.NM
ORDER BY a.NUM;

SELECT * FROM T2 a FULL OUTER JOIN T1 b
ON a.NM = b.NUM
ORDER BY b.NUM;

--??????????? ?????????? LOJ ? ROJ:
(SELECT * FROM T1 LEFT OUTER JOIN T2
	ON T1.NUM = T2.NM)
	UNION
(SELECT * FROM T1 RIGHT OUTER JOIN T2
	ON T1.NUM = T2.NM);

--???????? ?????????? INNER JOIN ???? ?????? 
SELECT * FROM T2 a FULL OUTER JOIN T1 b
	ON a.NM = b.NUM
	WHERE b.NUM IS NOT NULL AND b.STRING IS NOT NULL AND a.NM IS NOT NULL AND a.ST IS NOT NULL
	ORDER BY b.NUM;


SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	FROM AUDITORIUM full JOIN AUDITORIUM_TYPE
	ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	WHERE AUDITORIUM.AUDITORIUM_TYPE IS NULL;

SELECT TEACHER.TEACHER_NAME, PULPIT.PULPIT_NAME
	FROM TEACHER full JOIN PULPIT
	ON TEACHER.PULPIT=PULPIT.PULPIT
	WHERE TEACHER.TEACHER_NAME IS NULL;

SELECT TEACHER.TEACHER_NAME, PULPIT.PULPIT_NAME
	FROM TEACHER full JOIN PULPIT
	ON TEACHER.PULPIT=PULPIT.PULPIT
	WHERE TEACHER.TEACHER_NAME IS NOT NULL;

--?9
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	FROM AUDITORIUM CROSS JOIN AUDITORIUM_TYPE
	WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;


