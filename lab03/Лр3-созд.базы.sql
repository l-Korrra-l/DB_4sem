USE master;

drop database [Merh Univer]
drop table Student
drop table Results


CREATE database [Merh Univer]
CONTAINMENT = NONE
 ON PRIMARY
( 
	NAME = N'Merh Univer_mdf', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh Univer.mdf' ,
	SIZE = 5120KB , MAXSIZE = 10240KB , FILEGROWTH = 1024KB 
)
 LOG ON --журнал событий .ldf
( 
	NAME=N'Merh Univer_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh Univer.ldf',
	SIZE = 1024KB, MAXSIZE= UNLIMITED, FILEGROWTH = 10%
)
GO


-- task 2 
CREATE TABLE Student
(
	Student_ID int NOT NULL primary key,
	Surname nvarchar(15) NOT NULL,
	Group_Number int NOT NULL

)
SELECT *from Student
--task 3
ALTER Table Student ADD Enter_date date NOT NULL
ALTER Table Student DROP column Enter_date

--task 4
INSERT into Student(Student_ID, Surname, Group_Number)
		values	(123,'Бобров', 4),
				(321,'Иванов',4),
				(1,'Лисичкина',1),
				(2,'Афанасьева',2);
INSERT into Student values (4,'Куликов',2)

--task 5
SELECT *from Student
Select Student_ID, Surname from Student
Select count(*) from Student

Select Surname[First Group] from Student
		where Group_Number=1

Select Distinct top(3) *from Student 
		order by Surname Desc

--task 5 again
UPDATE Student set Group_Number=5
SELECT *from Student

delete from Student where Student_ID=123

--task 6
Select Distinct *from Student 
		where Student_ID Between 5 And 1000

Select Distinct *from Student 
		where Student_ID Like '%[%]%'

Select Distinct *from Student 
		where Group_Number In(2,4)

drop table Student

--task 7
Create table Results
(
	ID int primary key identity(1,1),
	Student_name nvarchar(15),
	Math int,
	Physics int,
	Biology int,
	Aver_value as (Math+Physics+Biology)/3
)

Insert Results values	('Котов', 5, 6, 7),
						('Алексеев', 6, 4, 9)

Select *from Results
