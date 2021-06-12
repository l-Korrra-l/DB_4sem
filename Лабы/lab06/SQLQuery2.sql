USE [Merh MyBase]

select distinct Workers_.Worker_ID, Workers_.Firstname from Workers_
	join Works_ on Works_.Worker_ID=Workers_.Worker_ID
	where Workers_.Worker_ID in(select Worker_ID from Works_ where Quantity like '1_')

select Works_.Operation from Works_
where not exists (select * from Works_ where Works_.Quantity=344)
		and  Works_.Operation is not null

select Works_.Operation from Works_
where Works_.Worker_ID >=any (select Works_.Quantity from Works_ where Works_.Quantity=34)
		and  Works_.Operation is not null

