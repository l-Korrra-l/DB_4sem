
-----1

SET NONCOUNT ON
IF EXISTS(SELECT *FROM SYS.OBJECTS 
			WHERE OBJECT_ID=OBJECT_ID(N'DBO.TASK1'))
	DROP TABLE TASK1

DECLARE @I INT, @FLAG CHAR='C'
SET IMPLICIT_TRANSACTION ON

CREATE TABLE TASK1(K INT)
INSERT TASK1 VALUES (1),(2),(3)
SET @I=(SELECT COUNT(*) FROM TASK1)
PRINT 'ROWS IN TASK1: '+CAST(@I AS VARCHAR(2))
IF @FLAG='C' COMMIT
	ELSE ROLLBACK

SET IMPLICIT_TRANSACTION OFF


IF EXISTS(SELECT *FROM SYS.OBJECTS 
			WHERE OBJECT_ID=OBJECT_ID(N'DBO.TASK1'))
			PRINT 'TASK1 EXIXTS'
	ELSE PRINT 'TASK1 DOESNT EXIST'

-----2
use Merh_Univer

BEGIN TRY
	BEGIN TRAN
	INSERT AUDITORIUM VALUES('431-1', '��',15,'431-1')
	INSERT AUDITORIUM VALUES('431-1', '��',15,'431-1')
	DELETE AUDITORIUM WHERE AUDITORIUM.AUDITORIUM = '206-1'
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'MY ERROR-----------'+CASE
	WHEN ERROR_NUMBER()=2627 AND PATINDEX('%PK_Merh_Univer%', ERROR_MESSAGE())>0
		THEN 'CAN NOT INSERT DUPLICATED ITEM'
			ELSE 'UNKNOWN ERROR: '+CAST(ERROR_NUMBER() AS VARCHAR(5))+ERROR_MESSAGE()
	END
	IF @@TRANCOUNT>0 ROLLBACK TRAN
END CATCH

-----3
INSERT AUDITORIUM VALUES('206-1', '��',15,'431-1')
DECLARE @SAVE_POINT VARCHAR(30);
BEGIN TRY
	BEGIN TRAN
		DELETE AUDITORIUM WHERE AUDITORIUM.AUDITORIUM = '206-1';
		SET @SAVE_POINT = 'DELETE_SAVEPOINT';
		SAVE TRAN @SAVE_POINT;

		INSERT AUDITORIUM VALUES ('TEST', 'KK', 555, 'TEST');
		SET @SAVE_POINT = 'INSERT_SAVEPOINT';
		SAVE TRAN @SAVE_POINT;
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'ERROR: ' + CASE
	WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%AUDITORIUM_PK%', ERROR_MESSAGE()) > 0
		THEN 'DUPLICATE'
		ELSE 'UNKHOW ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
	END;
	IF @@TRANCOUNT > 0 
	BEGIN
		PRINT 'SAVEPOINT ' + @SAVE_POINT;
		ROLLBACK TRAN @SAVE_POINT;
		COMMIT TRAN;
	END
END CATCH

-----4

SELECT * FROM AUDITORIUM
SELECT * FROM AUDITORIUM_TYPE

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
	SELECT @@SPID, 'INSERT', * FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_NAME = '236-1';
	SELECT @@SPID, 'UPDATE', * FROM AUDITORIUM_TYPE
		WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '���������� �����������';
COMMIT

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
	SELECT @@SPID;
	INSERT AUDITORIUM VALUES ('0', '��-X', 25, '1' );
	UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '��-XXX'
		WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '��-X';
ROLLBACK;

------5


SELECT * FROM AUDITORIUM
SELECT * FROM AUDITORIUM_TYPE

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
	SELECT COUNT( * ) FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
	SELECT 'UPDATE', COUNT( * ) FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
COMMIT

BEGIN TRAN
	UPDATE AUDITORIUM SET AUDITORIUM_CAPACITY = 15
		WHERE AUDITORIUM_CAPACITY = 50;
COMMIT;

-----6

SELECT * FROM AUDITORIUM

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
	SELECT AUDITORIUM.AUDITORIUM_NAME FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
	SELECT CASE 
		WHEN AUDITORIUM.AUDITORIUM_NAME = '236-1'
			THEN 'INSERT'
			ELSE ''
			END 'RESULT', AUDITORIUM.AUDITORIUM_NAME FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
COMMIT
SET TRANSACTION ISOLATION LEVEL READ COMMITED
BEGIN TRAN
	INSERT AUDITORIUM VALUES ( '545', '��', 15, '236-1');
COMMIT;

------7
  INSERT AUDITORIUM_TYPE VALUES ('AUD', 'AUD'),
								('AUD1', 'AUD1'),
								('AUD2', 'AUD2');
  SELECT * FROM AUDITORIUM_TYPE;

  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
  BEGIN TRAN
	DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE LIKE('AUD%');
	INSERT AUDITORIUM_TYPE VALUES ('AUAUAU', 'AUAUA');
	UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPENAME = 'QWERTY' WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUAU';
	SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUAU';
COMMIT;
	SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUAU';

	SET TRANSACTION ISOLATION LEVEL READ COMMITED
	  BEGIN TRAN
	DELETE AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE LIKE('AUD%');
	INSERT AUDITORIUM_TYPE VALUES ('AUAUA', 'AUAUAU');
	UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPENAME = 'QWERTY' WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUA';
	SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUA';
COMMIT;
	SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'AUAUA';
	
-----8
SELECT * FROM AUDITORIUM

BEGIN TRAN 
	INSERT AUDITORIUM_TYPE VALUES ( 'SSS', 'SSSSS' );
	BEGIN TRAN
		UPDATE AUDITORIUM SET AUDITORIUM_NAME = 'SSS' WHERE AUDITORIUM_TYPE = 'SSS';
	COMMIT;
	IF @@TRANCOUNT > 0
		ROLLBACK;
SELECT 
	(SELECT COUNT( * ) FROM AUDITORIUM WHERE AUDITORIUM_NAME = 'SSS' ),
	(SELECT COUNT( * ) FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = 'SSSSS' );
	COMMIT;

	----
		ELSE IF (@F!='' AND @P='')
		BEGIN
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
		print ' - ���������: ' + rtrim(@faculty);
		set @temp_faculty = @faculty;
		while (@faculty = @temp_faculty)
			begin
				print '		�������: ' + rtrim(@pulpit);
				print '			���������� ��������������: '+ rtrim(@qteacher) ;
				set @discipline_list = '			����������: ';
				set @temp_pulpit = @pulpit;
						if(@discipline != '')
							begin	
								if(@discipline_list = '			����������: ')
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
								if(@discipline_list = '			����������: ')
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
				if(@discipline_list != '			����������: ')
					begin
						print rtrim(@discipline_list) ;
						set @discipline_list = '			����������: ';
					end
				else
					begin
						print rtrim(@discipline_list) + ' ���' ;
					end;
					if(@@FETCH_STATUS != 0)
						begin
							break;
						end;
			end;
	end;
		END