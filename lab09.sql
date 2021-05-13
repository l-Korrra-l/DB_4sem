use Merh_Univer
GO

-----1
DECLARE @CH CHAR='A',
		@VCH VARCHAR(4)='BSTU',
		@DT DATETIME, @T TIME,
		@IN INT, @SIN SMALLINT,
		@TIN TINYINT, @NUM NUMERIC(12,5)

SET @DT=GETDATE()
SET	@T= CONVERT(TIME, @DT)

USE Merh_Univer
SELECT	@IN = MAX(PROGRESS.NOTE),
		@SIN = COUNT(PROGRESS.NOTE),
		@NUM = AVG(PROGRESS.NOTE)
FROM PROGRESS

PRINT CAST(@IN  AS VARCHAR(15))
PRINT CAST(@SIN  AS VARCHAR(15))
PRINT CAST(@NUM  AS VARCHAR(15))

SELECT @VCH,@CH, @DT, @T

-----2
DECLARE @SUM_CAP INT = 
	( SELECT SUM( AUDITORIUM.AUDITORIUM_CAPACITY ) FROM AUDITORIUM ),
			 	@NUMBER INT,
				@AVG_CAPACITY NUMERIC(8,3),
				@COUNT INT,
				@PER NUMERIC(8,3)

IF @SUM_CAP > 200
	BEGIN
		SET @NUMBER = ( SELECT COUNT(*) FROM AUDITORIUM )
		SET @AVG_CAPACITY = ( SELECT CAST(AVG( AUDITORIUM.AUDITORIUM_CAPACITY ) AS NUMERIC(8,3)) FROM AUDITORIUM )
		SET @COUNT = ( SELECT COUNT( * ) FROM AUDITORIUM
												WHERE AUDITORIUM_CAPACITY < @AVG_CAPACITY )
		SET @PER = CAST(@COUNT AS NUMERIC(8,3))/CAST(@NUMBER AS NUMERIC(8,3))
		SELECT @NUMBER 'Amount', @AVG_CAPACITY 'Avg capacity',
					 @COUNT 'Aud < avg capacity', @PER '%'
	END
ELSE 
	BEGIN 
		PRINT 'SUMMARY CAPACITY ' + CAST( @SUM_CAP AS VARCHAR(15) )
	END

-----3
--print 'Найти по шаблону       : '+  cast (patindex ('%xY%', '123456YxY7890') as varchar(5));

PRINT 'Число обработанных строк:';
PRINT @@ROWCOUNT;
PRINT 'Версия SQL Server:'
PRINT @@VERSION;
PRINT 'Системный идентификатор процесса, назначенный сервером текущему под-ключению:';
PRINT @@SPID;
PRINT 'Код последней ошибки: ';
PRINT @@ERROR;
PRINT 'Имя сервера: ';
PRINT @@SERVERNAME;
PRINT 'Уровень вложенности транзакции: ';
PRINT @@TRANCOUNT;
PRINT 'Проверка результата считывания строк результирующего набора: ';
PRINT @@FETCH_STATUS;
PRINT 'Уровень вложенности текущей процедуры: ';
PRINT @@NESTLEVEL;

-----4
---ВЫЧИСЛЕНИЕ ФУНКЦИИ
DECLARE @Z REAL, @T1 REAL, @X INT;
SET @T1 = 5;
SET @X = 4;

WHILE @X < 7
BEGIN
IF @T1 > @X
	BEGIN
		SET @Z = SIN(@T1)*SIN(@T1);
	END
ELSE IF @T1 < @X
	BEGIN
		SET @Z = 4*(@T1 + @X);
	END
ELSE 
	BEGIN
		SET @Z = 1-EXP(@X-2);
	END
PRINT @Z;
SET @X = @X + 1;
END

---преобразование полного ФИО студента в сокращенное


DECLARE @NAME VARCHAR(20)=(SELECT TOP 1 NAME FROM STUDENT)
SELECT	SUBSTRING(@NAME,1,PATINDEX( '% %', STUDENT.NAME )) +
		SUBSTRING(@NAME,PATINDEX( '% %', STUDENT.NAME )+1,1 )+'.' +
		SUBSTRING(@NAME,PATINDEX( '% %', SUBSTRING(@NAME, PATINDEX( '% %', STUDENT.NAME )+1, 
					LEN(@NAME)-PATINDEX('%_ _%', STUDENT.NAME)))+1,1 )+'.'
FROM STUDENT

--поиск студентов, у которых день рож-дения в следующем месяце, и определе-ние их возраста;
DECLARE @CUR_MON INT = MONTH( GETDATE() ),
				@CUR_YEAR INT = YEAR( GETDATE() );

SELECT 
	NAME, BDAY, 
	( @CUR_YEAR - YEAR( BDAY ) ) AS AGE
	FROM STUDENT
	WHERE 
		@CUR_MON + 1 = MONTH( BDAY ) 

--поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД.
DECLARE @GROUP INT = 4;

SELECT 
	GROUPS.IDGROUP,
	STUDENT.NAME,
	PROGRESS.SUBJECT,
	PROGRESS.NOTE,
	DATEPART( DW, PROGRESS.PDATE ) AS WDAY  --DW с воскресенья
	FROM
		GROUPS
			JOIN STUDENT
				ON GROUPS.IDGROUP = STUDENT.IDGROUP
			JOIN PROGRESS
				ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	WHERE GROUPS.IDGROUP = @GROUP AND
				PROGRESS.SUBJECT = 'СУБД'

----5
DECLARE @COUNT1 INT =
	( SELECT SUM( AUDITORIUM_CAPACITY ) FROM AUDITORIUM );
	
IF ( @COUNT1 > 400 )
	BEGIN
		PRINT 'Вместимость аудиторий больше 400';
		PRINT 'Вместимость: ' + CAST( @COUNT1 AS VARCHAR( 10 ) );
	END
ELSE
		BEGIN
			PRINT 'Вместимость аудиторий меньше 400';
			PRINT 'Вместимость: ' + CAST( @COUNT1 AS VARCHAR( 10 ) );
		END

-----6
SELECT PROGRESS.IDSTUDENT,
	CASE 
		WHEN PROGRESS.NOTE BETWEEN 0 AND 3 THEN 'НЕ УД'
		WHEN PROGRESS.NOTE BETWEEN 4 AND 6 THEN 'УД'
		WHEN PROGRESS.NOTE BETWEEN 7 AND 9 THEN 'ХОРОШО'
		ELSE 'ОТЛИЧНО'
	END 'MARK'
	FROM PROGRESS, STUDENT, GROUPS
	WHERE PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT AND
			STUDENT.IDGROUP = GROUPS.IDGROUP 
	GROUP BY PROGRESS.IDSTUDENT,
		CASE 
			WHEN PROGRESS.NOTE BETWEEN 0 AND 3 THEN 'НЕ УД'
			WHEN PROGRESS.NOTE BETWEEN 4 AND 6 THEN 'УД'
			WHEN PROGRESS.NOTE BETWEEN 7 AND 9 THEN 'ХОРОШО'
			ELSE 'ОТЛИЧНО'
		END

-----7
drop table #Users
CREATE TABLE #Users ( CreatedAt DATE, UserName VARCHAR(20), UserStatus VARCHAR(20));
 
DECLARE  @period INT, @check INT, @date DATE, @stat VARCHAR(20), @name VARCHAR(20);
SET @date = GETDATE();
SET @name = 'User';
SET @period = 0;
SET @stat = 'exists';
SET @check = 1; 

WHILE @period <10
    BEGIN
        INSERT INTO #Users VALUES( @date, @name, @stat );
        SET @period = @period + 1;
        SET @date = DATEADD(year, 1, @date);
        SET @name = 'User' + CAST( @period AS VARCHAR(1) );
		IF @check > 0
		BEGIN
		SET @check = 0
		SET @stat = 'deleted'
		END
		ELSE
		BEGIN
		SET @check = 1
		SET @stat = 'exists'
		END
    END
 
SELECT * FROM #Users;

-----8
DECLARE @X INT = 1;
	WHILE @X > 0
		BEGIN
			SET @X = @X + 1;
			PRINT @X;
			IF @X = 5
				RETURN;
		END

-----9
DROP TABLE #Account

CREATE TABLE #Account (FirstName NVARCHAR NOT NULL, Age INT NOT NULL)
 
BEGIN TRY
    INSERT INTO #Account VALUES(NULL, NULL)
    PRINT 'Данные успешно добавлены!'
END TRY
BEGIN CATCH
    PRINT 'Error     ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE();
		PRINT 'ERROR_LINE    ' + CONVERT( VARCHAR, ERROR_LINE() );
		PRINT 'ERROR_PROCEDURE    ' + CONVERT( VARCHAR, ERROR_PROCEDURE());
		PRINT 'ERROR_SEVERITY ' + CONVERT( VARCHAR, ERROR_SEVERITY());
		PRINT 'ERROR_STATE    ' + CONVERT( VARCHAR, ERROR_STATE());
END CATCH