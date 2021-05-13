USE [Merh_Univer];
GO

-----1
DROP VIEW �������������;

CREATE VIEW �������������
	AS SELECT
			TEACHER AS ���,
			TEACHER_NAME AS ���_�������������,
			GENDER AS ���,
			PULPIT AS ���_������� 
		 FROM TEACHER


SELECT * FROM ������������� 
	ORDER BY ���;


-----2
DROP VIEW ����������_������;

CREATE VIEW ����������_������
	AS SELECT
		   FACULTY.FACULTY AS ���������,
			 COUNT( PULPIT.PULPIT ) AS ����������_������
		 FROM FACULTY 
		   JOIN PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;


SELECT * FROM ����������_������;

-----3
DROP VIEW ���������

CREATE VIEW ��������� ( ���, ������������_���������,  ��� )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE '��%';


SELECT * FROM ���������;

INSERT ��������� VALUES( 'TEST', 'TEST_NAME', '��' );
SELECT * FROM ���������;

UPDATE ���������
	 SET ��� = 'UPDATE' WHERE ������������_��������� = 'TEST_NAME'
SELECT * FROM ���������;

DELETE FROM ��������� WHERE ������������_��������� = 'TEST_NAME'
SELECT * FROM ���������;

DELETE FROM AUDITORIUM WHERE AUDITORIUM_NAME = 'TEST_NAME'
SELECT * FROM AUDITORIUM;

-----4
DROP VIEW ����������_���������;

CREATE VIEW ����������_��������� ( ���, ������������_���������, ��� )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE '��%' WITH CHECK OPTION;


INSERT ����������_��������� VALUES( 'TEST', 'TEST_NAME', '��' );
INSERT ����������_��������� VALUES( 'TEST1', 'TEST_NAME', '��' );
DELETE FROM ����������_��������� WHERE ������������_��������� = 'TEST_NAME'

SELECT * FROM ����������_���������;

-----5
DROP VIEW ����������;
GO
CREATE VIEW ���������� 
	( ���, ������������_����������, ���_������� )
	AS SELECT TOP 20 SUBJECT, SUBJECT_NAME, PULPIT
		 FROM SUBJECT
		 ORDER BY SUBJECT_NAME;


SELECT * FROM ����������;

-----6

ALTER VIEW ����������_������ WITH SCHEMABINDING
	AS SELECT
		   FACULTY.FACULTY AS ���������,
			 COUNT( PULPIT.PULPIT ) AS ����������_������
		 FROM dbo.FACULTY 
		   JOIN dbo.PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;


SELECT * FROM ����������_������;
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
        �����������, �������, �����, �������, �������, �������, �����������
    )
) p

