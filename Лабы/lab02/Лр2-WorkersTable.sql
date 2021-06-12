USE [Merh MyBase]
GO

/****** Object:  Table [dbo].[Workers]    Script Date: 12.02.2021 17:43:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Workers_](
	[Worker_ID] [int] NOT NULL,
	[Last name] [varchar](30) NOT NULL,
	[Firstname] [varchar](30) NOT NULL,
	[Surname] [varchar](30) NOT NULL,
	[Adress] [varchar](50) NULL,
	[Phone] [varchar](13) NULL,
	[Experience(months)] [int] NOT NULL,
 CONSTRAINT [PK_Workers_] PRIMARY KEY CLUSTERED 
(
	[Worker_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


