USE [Merh_Univer];
GO

-----1
DROP VIEW Преподаватель;

CREATE VIEW Преподаватель
	AS SELECT
			TEACHER AS Код,
			TEACHER_NAME AS Имя_Преподавателя,
			GENDER AS Пол,
			PULPIT AS Код_кафедры 
		 FROM TEACHER


SELECT * FROM Преподаватель 
	ORDER BY Код;


-----2
DROP VIEW Количество_кафедр;

CREATE VIEW Количество_кафедр
	AS SELECT
		   FACULTY.FACULTY AS ФАКУЛЬТЕТ,
			 COUNT( PULPIT.PULPIT ) AS КОЛИЧЕСТВО_КАФЕДР
		 FROM FACULTY 
		   JOIN PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;


SELECT * FROM Количество_кафедр;

-----3
DROP VIEW Аудитории

CREATE VIEW Аудитории ( КОД, НАИМЕНОВАНИЕ_АУДИТОРИИ,  ТИП )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE 'ЛК%';


SELECT * FROM Аудитории;

INSERT Аудитории VALUES( 'TEST', 'TEST_NAME', 'ЛК' );
SELECT * FROM Аудитории;

UPDATE Аудитории
	 SET КОД = 'UPDATE' WHERE НАИМЕНОВАНИЕ_АУДИТОРИИ = 'TEST_NAME'
SELECT * FROM Аудитории;

DELETE FROM Аудитории WHERE НАИМЕНОВАНИЕ_АУДИТОРИИ = 'TEST_NAME'
SELECT * FROM Аудитории;

DELETE FROM AUDITORIUM WHERE AUDITORIUM_NAME = 'TEST_NAME'
SELECT * FROM AUDITORIUM;

-----4
DROP VIEW Лекционные_аудитории;

CREATE VIEW Лекционные_аудитории ( КОД, НАИМЕНОВАНИЕ_АУДИТОРИИ, ТИП )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE 'ЛК%' WITH CHECK OPTION;


INSERT Лекционные_аудитории VALUES( 'TEST', 'TEST_NAME', 'ЛК' );
INSERT Лекционные_аудитории VALUES( 'TEST1', 'TEST_NAME', 'ЛБ' );
DELETE FROM Лекционные_аудитории WHERE НАИМЕНОВАНИЕ_АУДИТОРИИ = 'TEST_NAME'

SELECT * FROM Лекционные_аудитории;

-----5
DROP VIEW Дисциплины;
GO
CREATE VIEW Дисциплины 
	( КОД, НАИМЕНОВАНИЕ_ДИСЦИПЛИНЫ, КОД_КАФЕДРЫ )
	AS SELECT TOP 20 SUBJECT, SUBJECT_NAME, PULPIT
		 FROM SUBJECT
		 ORDER BY SUBJECT_NAME;


SELECT * FROM Дисциплины;

-----6

ALTER VIEW Количество_кафедр WITH SCHEMABINDING
	AS SELECT
		   FACULTY.FACULTY AS ФАКУЛЬТЕТ,
			 COUNT( PULPIT.PULPIT ) AS КОЛИЧЕСТВО_КАФЕДР
		 FROM dbo.FACULTY 
		   JOIN dbo.PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;


SELECT * FROM Количество_кафедр;
-----7
use [Merh MyBase]
GO
CREATE VIEW My(oper, diff)
AS SELECT Operation, [Difficulty indicator]
FROM Operations

SELECT *FROM My
------8
USE [Merh_Univer];
GO

DROP VIEW TIMETAB 

CREATE VIEW TIMETAB (IDGROUP, AUDITORIUM, SUBJECT, TEACHER, wday, lessons)
 AS SELECT IDGROUP, AUDITORIUM, SUBJECT, TEACHER, WEEKDAY, LESSON
 FROM TIMETABLE

 SELECT WEEKDAY FROM TIMETABLE

 SELECT * 
FROM (
    SELECT 
          TEACHER,
        wday [WeekDay] 
    FROM TIMETAB
) t
PIVOT (
    COUNT([WeekDay]) 
    FOR [WeekDay] IN (
        понедельник, вторник, среда, четверг, пятница, суббота, воскресенье
    )
) p

