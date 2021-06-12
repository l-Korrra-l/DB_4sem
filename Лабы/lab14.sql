use Merh_Univer;
-----------1
drop function COUNT_STUDENTS;
go
create function COUNT_STUDENTS (@faculty varchar(20) = null) returns int
as begin  
	return (select count(*) from FACULTY join GROUPs on FACULTY.FACULTY = GROUPS.FACULTY
				join STUDENT on GROUPS.IDGROUP = STUDENT.IDGROUP where FACULTY.FACULTY = @faculty);
end;
go
select FACULTY.FACULTY,dbo.COUNT_STUDENTS(FACULTY)[Count] from FACULTY;
go
alter FUNCTION COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin
	return (select count(*) from FACULTY join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY 
				join STUDENT on GROUPS.IDGROUP = STUDENT.IDGROUP where (FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof))
end;
go
select FACULTY.FACULTY, dbo.COUNT_STUDENTS(FACULTY.FACULTY, GROUPS.PROFESSION)[Count] from FACULTY, GROUPS;
-------2
go
create FUNCTION FSUBJECTS (@p varchar(20)) returns varchar(300)
as 
begin
	declare @part char(20);
	declare @Full varchar(300) = 'Дисциплины: ';
	declare TakeSubjects  cursor local 
	for select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p;
	open TakeSubjects;
	fetch TakeSubjects into @part;
	while @@FETCH_STATUS = 0
	begin
		set @Full = @Full + ', ' + rtrim(@part);
		fetch TakeSubjects into @part;
	end;
	close TakeSubjects
	return @Full;
end;
go
select PULPIT, dbo.FSUBJECTS(PULPIT)[Предметы по дисциплинам] from PULPIT;
go
drop FUNCTION FSUBJECTS;
------3
use Merh_Univer;
go 
create function FFACPUL(@codeFaculty varchar(20), @codePulpit nchar(20)) returns table
as return select FACULTY.FACULTY , PULPIT.PULPIT 
from FACULTY left join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY 
where FACULTY.FACULTY = isnull(@codeFaculty, FACULTY.FACULTY)
	and PULPIT.PULPIT = ISNULL(@codePulpit, PULPIT.PULPIT);
go
select * from dbo.FFACPUL(null, null); 
select * from dbo.FFACPUL('ИДиП', null);
select * from dbo.FFACPUL(null, 'ИСиТ'); 
select * from dbo.FFACPUL('ТОВ', 'ХПД'); 
drop function FFACPUL;
-------4
go
create function FCTEACHER(@codePulp nchar(20)) returns int
as 
begin
	declare @result int = (select count(*) from TEACHER 
	where TEACHER.PULPIT = isnull(@codePulp, TEACHER.PULPIT));
	return @result;
end;
go
select PULPIT.PULPIT, dbo.FCTEACHER(PULPIT.PULPIT)[Количество учителей]
from PULPIT;
select dbo.FCTEACHER(null)[общее количество ];
drop function FCTEACHER;
------5

use [Merh MyBase]
drop function MYBASE
GO
create function MYBASE(@oper nvarchar(10)) returns TABLE
AS RETURN SELECT *FROM Operations WHERE Operations.Operation=@oper
GO
SELECT * from dbo.MYBASE('idk')
------6
go
use Merh_Univer
drop FUNCTION PULPIT_COUNT;
drop FUNCTION GROUP_COUNT;
drop FUNCTION PROFESSION_COUNT;
drop FUNCTION FACULTY_REPORT;
go
CREATE FUNCTION PULPIT_COUNT(@faculty nchar(10)) returns int  
as begin 
	return (select count(PULPIT.PULPIT) from PULPIT where PULPIT.FACULTY = @faculty);
end;
go
CREATE FUNCTION GROUP_COUNT(@faculty nchar(10)) returns int
as begin
	return (select count(GROUPS.IDGROUP) from GROUPS where GROUPS.FACULTY = @faculty);
end;
go
CREATE FUNCTION PROFESSION_COUNT(@faculty nchar(10)) returns int
as begin
	return (select count(PROFESSION.PROFESSION) from PROFESSION where PROFESSION.FACULTY = @faculty);
end;
go
create function FACULTY_REPORT(@c int) returns @fr table
([Факультет]varchar(50), [Количество кафедр]int, [Количество групп]int,
	[Количество студентов]int, [Количество специальностей]int)
	as begin
		declare cc CURSOR static for
			select FACULTY.FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY, default)>@c;
		declare @f varchar(30);
		open cc;
			fetch cc into @f
			while @@FETCH_STATUS = 0 
			begin
				insert @fr values(@f, dbo.PULPIT_COUNT(@f), dbo.GROUP_COUNT(@f), dbo.COUNT_STUDENTS(@f,null), dbo.PROFESSION_COUNT(@f))
				fetch cc into @f; 
			end;
		close cc;
		return;
	end;
go
select * from dbo.FACULTY_REPORT(-1);
go
-------7
select * from STUDENT;
select * from GROUPS;
select * from FACULTY;
drop procedure PRINT_REPORTX;
use Merh_Univer
go
create procedure PRINT_REPORTX @f char(10) = null, @p char(10) = null
as begin 
	declare @count int = 0;
	if(@f is not null AND @p is null)
	begin
		DECLARE Faculties CURSOR local STATIC for
		select FACULTY.FACULTY, PULPIT.PULPIT, dbo.FCTEACHER(PULPIT.PULPIT),  ISNULL (SUBJECT.SUBJECT, 'Нет')  FROM 
		FACULTY JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
		JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
		left JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
		where FACULTY.FACULTY = @f
		GROUP BY SUBJECT.SUBJECT, PULPIT.PULPIT , FACULTY.FACULTY;
	end
	if(@f is not null AND @p is not null)
	begin
		DECLARE Faculties CURSOR local STATIC for
		select FACULTY.FACULTY, PULPIT.PULPIT, dbo.FCTEACHER(PULPIT.PULPIT),  ISNULL (SUBJECT.SUBJECT, 'Нет')  FROM 
		FACULTY JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
		JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
		left JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
		where FACULTY.FACULTY = @f AND PULPIT.PULPIT = @p
		GROUP BY SUBJECT.SUBJECT, PULPIT.PULPIT , FACULTY.FACULTY;
	end
	if(@f is null AND @p is not null)
	begin
		DECLARE Faculties CURSOR local STATIC for
		select PULPIT.FACULTY, PULPIT.PULPIT, dbo.FCTEACHER(PULPIT.PULPIT),  ISNULL (SUBJECT.SUBJECT, 'Нет')  FROM 
		FACULTY JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
		JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
		left JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
		where PULPIT.PULPIT= @p
		GROUP BY SUBJECT.SUBJECT, PULPIT.PULPIT , PULPIT.FACULTY;
	end
	declare @checkNumb int =0
	select @checkNumb = count(*) FROM 
	FACULTY JOIN PULPIT ON FACULTY.FACULTY = PULPIT.FACULTY
	JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
	left JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
	where PULPIT.PULPIT= @p
	GROUP BY SUBJECT.SUBJECT, PULPIT.PULPIT , FACULTY.FACULTY
	--if(@checkNumb<=0)
		--throw 5100, 'Ошибка в параметрах',1;
	open Faculties
DECLARE @Faculty nvarchar(10) = '', @Pulpit nvarchar(15) = '', @CountTeacher int, @Subject nvarchar(10) = '';
FETCH Faculties into @Faculty, @Pulpit, @CountTeacher, @Subject;
DECLARE @PriorFaculty nvarchar(10) = '', @PriorPulpit nvarchar(15) = '', @PriorCountTeacher int = -2, @PriorSubject nvarchar(10) = '';
WHILE @@FETCH_STATUS = 0
begin
if(@Faculty != @PriorFaculty)
print 'Факультет: ' + @Faculty + char(13);
if(@Pulpit != @PriorPulpit)
begin
print space(5) + 'Кафедра:' + @Pulpit + char(13);
set @count +=1;
end
if(@CountTeacher != @PriorCountTeacher)
begin
print space(7) + 'Количество преводавателей: ' + cast(@CountTeacher as varchar(10)) + char(13) + space(7);
declare @ffcaplful varchar(300) = (select PULPIT from dbo.FFACPFUL(@Faculty,@Pulpit));
print @ffcaplful + char(13);
print @ffcaplful + char(13);
end
print replace(@Subject ,char(13), '') + ',';
SET @PriorFaculty = @Faculty; SET @PriorPulpit = @Pulpit; SET @PriorCountTeacher = @CountTeacher; SET @PriorSubject = @Subject;
FETCH Faculties into @Faculty, @Pulpit, @CountTeacher, @Subject;
end;
close Faculties;
return @count;
end;
go
declare @count int =0;	
exec @count = PRINT_REPORTX 'ИТ'
print 'Количество выведенных кафедр ' + cast(@count as varchar(5));