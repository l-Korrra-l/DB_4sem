EXEC sp_helpdb Merh_Univer
GO

EXEC sp_helpfilegroup 'PRIMARY'
GO
EXEC sp_helpfilegroup 'G1'
GO
EXEC sp_helpfilegroup 'G2'
GO

SELECT USER_NAME(o.uid) [Owner],
 OBJECT_NAME(i.id) [Table Name], 
 FILEGROUP_NAME(groupid) AS [Filegroup Name]
 FROM sysindexes i inner join sysobjects o
 ON i.id = o.id
 WHERE i.indid IN (0, 1) AND OBJECTPROPERTY(i.id, 'IsMSShipped') = 0 AND
 FILEGROUP_NAME(groupid) = 'PRIMARY' 
 ORDER BY 1,3,2
GO

SELECT USER_NAME(o.uid) [Owner],
 OBJECT_NAME(i.id) [Table Name], 
 FILEGROUP_NAME(groupid) AS [Filegroup Name]
 FROM sysindexes i inner join sysobjects o
 ON i.id = o.id
 WHERE i.indid IN (0, 1) AND OBJECTPROPERTY(i.id, 'IsMSShipped') = 0 AND
 FILEGROUP_NAME(groupid) = 'G1' 
 ORDER BY 1,3,2
GO

SELECT USER_NAME(o.uid) [Owner],
 OBJECT_NAME(i.id) [Table Name], 
 FILEGROUP_NAME(groupid) AS [Filegroup Name]
 FROM sysindexes i inner join sysobjects o
 ON i.id = o.id
 WHERE i.indid IN (0, 1) AND OBJECTPROPERTY(i.id, 'IsMSShipped') = 0 AND
 FILEGROUP_NAME(groupid) = 'G2' 
 ORDER BY 1,3,2
GO