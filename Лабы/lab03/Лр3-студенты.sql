Use [Merh Univer]
drop table student1

create table student1
(
	[????? ???????] int primary key identity(1,1),
	??? nvarchar(50) not null,
	[???? ????????] date not null,
	[??? (?/?)] nvarchar(1) not null check([??? (?/?)] in ('?','?')),
	[???? ???????????] date not null

)

insert into student1 (???, [???? ????????], [??? (?/?)], [???? ???????????])
		Values	('??????? ????? ??????????', '2000-07-15', '?', '2021-07-15'),
				('???????? ????????? ??????????', '2010-07-15', '?', '2021-07-15'),
				('???????? ?????? ????????', '2003-07-14', '?', '2021-07-15'),
				('?????? ????? ?????????????', '2003-07-14', '?', '2021-07-15')

SELECT 	* FROM student1
	Where [??? (?/?)] = '?' And DATEDIFF(year, [???? ????????], [???? ???????????])>18
		or ([??? (?/?)] = '?' And DATEDIFF(year, [???? ????????], [???? ???????????])=18 and DATEDIFF(month, [???? ????????], [???? ???????????])>0)
		or ([??? (?/?)] = '?' And DATEDIFF(year, [???? ????????], [???? ???????????])=18 and DATEDIFF(month, [???? ????????], [???? ???????????])=0 and DATEDIFF(day, [???? ????????], [???? ???????????])>=0)
