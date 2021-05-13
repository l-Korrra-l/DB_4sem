use master
Exec msdb.dbo.sp_delete_database_backuphistory @database_name = N'TMPMerh_Univer'
Go
Use [master]
go
Alter Database TMPMerh_Univer Set Single_User with Rollback Immediate
Go
Drop Database TMPMerh_Univer
Go