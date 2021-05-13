USE [master]
GO

/****** Object:  Database [Merh MyBase]   ******/
drop database [Merh_MyBase]

CREATE DATABASE [Merh_MyBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Merh_MyBase_mdf', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh_MyBase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
( NAME = N'Merh_MyBase_ndf', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh MyBase.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
Filegroup [G1]
( NAME = N'Merh_MyBase11_ndf', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh_MyBase11.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
( NAME = N'Merh_MyBase12_ndf', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh_MyBase12.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Merh_MyBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Merh_MyBase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Merh MyBase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO



USE [Merh_MyBase]
GO


drop table [Operations]

CREATE TABLE [Operations](
	[Operation] [varchar](20) NOT NULL,
	[Difficulty indicator] [varchar](20) NULL,
 CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED 
(
	[Operation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [G1]
) ON [G1]
GO
