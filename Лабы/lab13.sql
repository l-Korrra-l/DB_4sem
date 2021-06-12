USE Merh_Univer
GO

DROP PROC PSUBJECT
-- TASK 1

CREATE PROC PSUBJECT AS
	BEGIN
	DECLARE @COUNT INT = ( SELECT COUNT( * ) FROM SUBJECT )
	SELECT
		SUBJECT.SUBJECT AS 'КОД',
		SUBJECT.SUBJECT_NAME AS 'НАЗВАНИЕ',
		SUBJECT.PULPIT AS 'КАФЕДРА'
	FROM SUBJECT
	RETURN @COUNT
	END

DECLARE @K INT;
EXEC @K = PSUBJECT
SELECT @K
GO
--  TASK 2

ALTER PROC PSUBJECT 
	@P VARCHAR(20) = NULL,
	@C INT OUTPUT AS
	BEGIN
		DECLARE @COUNT INT = ( SELECT COUNT( * ) FROM SUBJECT )
		SELECT
			SUBJECT.SUBJECT AS 'КОД',
			SUBJECT.SUBJECT_NAME AS 'НАЗВАНИЕ',
			SUBJECT.PULPIT AS 'КАФЕДРА'
		FROM SUBJECT
			WHERE SUBJECT.SUBJECT = @P
		SET @C = @@ROWCOUNT
		RETURN @COUNT
	END


	DECLARE @K INT = 0, @R INT = 0, @P VARCHAR(20)
	EXEC @K = PSUBJECT 'СУБД',  @R OUTPUT
	PRINT @R 
	GO

	-- TASK 3
	USE Merh_Univer
	ALTER PROC PSUBJECT @P VARCHAR(20) AS
		BEGIN
			DECLARE @K INT = ( SELECT COUNT( * ) FROM SUBJECT )
			SELECT * FROM SUBJECT WHERE SUBJECT.SUBJECT = @P
		END

	CREATE TABLE #SUBJECT(
		SUBJECT NVARCHAR(10) PRIMARY KEY,
		SUBJECT_NAME NVARCHAR(50),
		PULPIT NVARCHAR(50)
	)

INSERT #SUBJECT EXEC PSUBJECT @P = 'СУБД'

	SELECT * FROM #SUBJECT

	GO
-- TASK 4
DROP PROC PAUDITORIUM_INSERT
GO 

CREATE PROC PAUDITORIUM_INSERT
	@A CHAR(20), --30
	@N VARCHAR(50), --CHAR10
	@C INT = 0,
	@T CHAR(10) AS --VARCHAR50
	BEGIN
		DECLARE @RESULT INT = 1;
		BEGIN TRY
			INSERT INTO AUDITORIUM ( AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE )
				VALUES ( @A, @N, @C, @T )
			RETURN @RESULT
		END TRY
		BEGIN CATCH
			PRINT ERROR_NUMBER()
			PRINT ERROR_MESSAGE() 
			PRINT 'SEVERITY: '+CAST( ERROR_SEVERITY() AS VARCHAR(10))
			PRINT 'STATE: '+CAST(  ERROR_STATE() AS VARCHAR(10))
			PRINT 'LINE: '+CAST(  ERROR_LINE() AS VARCHAR(10))
			IF ERROR_PROCEDURE() IS NOT NULL
				PRINT ERROR_PROCEDURE()
			RETURN -1;
		END CATCH
	END
GO


DECLARE @RESULT INT;
EXEC @RESULT = PAUDITORIUM_INSERT '431-1', 'ЛК',15,'431-1';
PRINT @RESULT
go
DELETE AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_NAME='431-1'
GO


-- TASK 5
DROP PROC SUBJECT_REPORT
GO 

CREATE PROC SUBJECT_REPORT 
	@P CHAR(10) AS 
	BEGIN
		DECLARE @RESULT INT = 0
		BEGIN TRY
			DECLARE SSR cursor for
			SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE SUBJECT.PULPIT = @P;
			IF NOT EXISTS ( SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE SUBJECT.PULPIT = @P )
				--throw 51000, 'MY_ERROR', 1
				RAISERROR('MY_ERROR',51000,1)
			ELSE 
				DECLARE @TV CHAR(20), @T CHAR(300) = ' '
				OPEN SR
				FETCH SR INTO @TV
				PRINT 'SUBJECT: '
				FETCH SR INTO @TV
				SET @RESULT = @RESULT + 1
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @T = RTRIM(@TV) + ', ' + @T
						SET @RESULT = @RESULT + 1
						FETCH SR INTO @TV
					END
				PRINT @T
				CLOSE SR
				RETURN @RESULT
		END TRY
		BEGIN CATCH
			PRINT 'ERROR PARAMETERS'
			IF ERROR_PROCEDURE() IS NOT NULL
				PRINT ERROR_PROCEDURE()
			RETURN @RESULT
		END CATCH
	END

SELECT * FROM PULPIT

DECLARE @RC INT
EXEC @RC = SUBJECT_REPORT 'ИСиТ'
PRINT 'count= ' + CAST( @RC AS VARCHAR(3))

DECLARE @RC1 INT
EXEC @RC1 = SUBJECT_REPORT 'ИСиТ'
PRINT 'count= ' + CAST( @RC1 AS VARCHAR(3))
GO
select *from SUBJECT
-- TASK 6
CREATE PROC PAUDITORIUM_INSERTX
	@A CHAR(20), 
	@N VARCHAR(50), 
	@C INT = NULL, 
	@T CHAR(10),
	@TN VARCHAR(50)
	as 
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE       
		BEGIN TRAN
			INSERT AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
				VALUES ( @T, @TN )
			EXEC @TN = PAUDITORIUM_INSERT @A, @N, @C, @T
		COMMIT TRAN
		RETURN @TN
	END TRY
	BEGIN CATCH
		PRINT 'номер ошибки  : ' + cast(error_number() as varchar(6))
		PRINT 'сообщение     : ' + error_message()
		PRINT 'уровень       : ' + cast(error_severity()  as varchar(6))
		PRINT 'метка         : ' + cast(error_state()   as varchar(8))
		PRINT 'номер строки  : ' + cast(error_line()  as varchar(8))
		IF ERROR_PROCEDURE() IS NOT NULL
			PRINT ERROR_PROCEDURE()
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
		RETURN -1
	END CATCH
GO

DECLARE @TN INT
EXEC @TN = PAUDITORIUM_INSERTX @A = '101-1', @N ='ИСиТ', @C = 50, @T = '101-1', @TN='TEST TYPE'
IF @TN!=1
PRINT 'ERROR CODE: ' + cast(@TN as varchar(3))

SELECT *FROM AUDITORIUM WHERE AUDITORIUM_NAME='101-1'
SELECT *FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME='TEST TYPE'

DROP PROC PAUDITORIUM_INSERTX
GO

-----8
drop proc PRINT_REPORT
CREATE PROC PRINT_REPORT
	@F CHAR(10) ='',
	@P CHAR(10) =''
	AS
	BEGIN TRY
	DECLARE @faculty varchar(150), @pulpit varchar(200), @discipline varchar(10), @discipline_list varchar(200) = '', @qteacher varchar(3), @temp_faculty varchar(50), @temp_pulpit varchar(50)
	IF (@F='')
		BEGIN
			IF (@P='')
				THROW 51000, 'ERROR PARAMETERS', 1
			ELSE
				SET @F=(SELECT TOP 1 PULPIT.FACULTY FROM PULPIT WHERE PULPIT.PULPIT=@P)
		END
	IF (@P!='')
		BEGIN 
		SELECT FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT, count(TEACHER.TEACHER_NAME)
		from FACULTY inner join PULPIT
		on PULPIT.FACULTY = FACULTY.FACULTY left outer join SUBJECT
		on SUBJECT.PULPIT = PULPIT.PULPIT left outer join TEACHER
		on TEACHER.PULPIT = PULPIT.PULPIT
		WHERE FACULTY.FACULTY=@F AND PULPIT.PULPIT=@P
		group by FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT order by FACULTY_NAME, PULPIT_NAME asc;
		DECLARE GET_REPORT_CURSOR CURSOR LOCAL STATIC for
		SELECT FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT, count(TEACHER.TEACHER_NAME)
		from FACULTY  inner join PULPIT
		on PULPIT.FACULTY = FACULTY.FACULTY left outer join SUBJECT
		on SUBJECT.PULPIT = PULPIT.PULPIT left outer join TEACHER
		on TEACHER.PULPIT = PULPIT.PULPIT
		WHERE FACULTY.FACULTY=@F AND PULPIT.PULPIT=@P
		group by FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT order by FACULTY_NAME, PULPIT_NAME asc;
	OPEN GET_REPORT_CURSOR
	FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
	while(@@FETCH_STATUS = 0)
	begin
		print ' - Факультет: ' + rtrim(@faculty);
		set @temp_faculty = @faculty;
		while (@faculty = @temp_faculty)
			begin
				print '		Кафедра: ' + rtrim(@pulpit);
				print '			Количество преподавателей: '+ rtrim(@qteacher) ;
				set @discipline_list = '			Дисциплины: ';
				set @temp_pulpit = @pulpit;
						if(@discipline != '')
							begin	
								if(@discipline_list = '			Дисциплины: ')
									begin
										set @discipline_list += @discipline;
									end
								else
									begin
										set @discipline_list = rtrim(@discipline_list) + ', ' + @discipline;
									end;
							end;
				FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
				while (@pulpit = @temp_pulpit)
					begin
						if(@discipline != '')
							begin	
								if(@discipline_list = '			Дисциплины: ')
									begin
										set @discipline_list += @discipline;
									end
								else
									begin
										set @discipline_list = rtrim(@discipline_list) + ', ' + @discipline;
									end;
							end;
						FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
					end;
				if(@discipline_list != '			Дисциплины: ')
					begin
						print rtrim(@discipline_list) ;
						set @discipline_list = '			Дисциплины: ';
					end
				else
					begin
						print rtrim(@discipline_list) + ' нет' ;
					end;
					if(@@FETCH_STATUS != 0)
						begin
							break;
						end;
			end;
	end;
	END
	ELSE IF (@F!='' AND @P='')
		BEGIN
		SELECT FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT, count(TEACHER.TEACHER_NAME)
		from FACULTY inner join PULPIT
		on PULPIT.FACULTY = FACULTY.FACULTY left outer join SUBJECT
		on SUBJECT.PULPIT = PULPIT.PULPIT left outer join TEACHER
		on TEACHER.PULPIT = PULPIT.PULPIT
		WHERE FACULTY.FACULTY=@F
		group by FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT order by FACULTY_NAME, PULPIT_NAME asc;
		DECLARE GET_REPORT_CURSOR CURSOR LOCAL STATIC for
		SELECT FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT, count(TEACHER.TEACHER_NAME)
		from FACULTY  inner join PULPIT
		on PULPIT.FACULTY = FACULTY.FACULTY left outer join SUBJECT
		on SUBJECT.PULPIT = PULPIT.PULPIT left outer join TEACHER
		on TEACHER.PULPIT = PULPIT.PULPIT
		WHERE FACULTY.FACULTY=@F
		group by FACULTY.FACULTY_NAME,PULPIT.PULPIT_NAME,SUBJECT.SUBJECT order by FACULTY_NAME, PULPIT_NAME asc;
	OPEN GET_REPORT_CURSOR
	FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
	while(@@FETCH_STATUS = 0)
	begin
		print ' - Факультет: ' + rtrim(@faculty);
		set @temp_faculty = @faculty;
		while (@faculty = @temp_faculty)
			begin
				print '		Кафедра: ' + rtrim(@pulpit);
				print '			Количество преподавателей: '+ rtrim(@qteacher) ;
				set @discipline_list = '			Дисциплины: ';
				set @temp_pulpit = @pulpit;
						if(@discipline != '')
							begin	
								if(@discipline_list = '			Дисциплины: ')
									begin
										set @discipline_list += @discipline;
									end
								else
									begin
										set @discipline_list = rtrim(@discipline_list) + ', ' + @discipline;
									end;
							end;
				FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
				while (@pulpit = @temp_pulpit)
					begin
						if(@discipline != '')
							begin	
								if(@discipline_list = '			Дисциплины: ')
									begin
										set @discipline_list += @discipline;
									end
								else
									begin
										set @discipline_list = rtrim(@discipline_list) + ', ' + @discipline;
									end;
							end;
						FETCH GET_REPORT_CURSOR into @faculty,@pulpit,@discipline,@qteacher;
					end;
				if(@discipline_list != '			Дисциплины: ')
					begin
						print rtrim(@discipline_list) ;
						set @discipline_list = '			Дисциплины: ';
					end
				else
					begin
						print rtrim(@discipline_list) + ' нет' ;
					end;
					if(@@FETCH_STATUS != 0)
						begin
							break;
						end;
			end;
	end;
		END
	END TRY
	BEGIN CATCH
		PRINT 'номер ошибки  : ' + cast(error_number() as varchar(6))
		PRINT 'сообщение     : ' + error_message()
		PRINT 'уровень       : ' + cast(error_severity()  as varchar(6))
		PRINT 'метка         : ' + cast(error_state()   as varchar(8))
		PRINT 'номер строки  : ' + cast(error_line()  as varchar(8))
		IF ERROR_PROCEDURE() IS NOT NULL
			PRINT ERROR_PROCEDURE()
		IF @@TRANCOUNT > 0 ROLLBACK TRAN
		RETURN -1
	END CATCH
GO

EXEC PRINT_REPORT 'ИТ', 'ИСиТ'
EXEC PRINT_REPORT '', 'ИСиТ'
EXEC PRINT_REPORT 'ИТ', ''
EXEC PRINT_REPORT '', ''