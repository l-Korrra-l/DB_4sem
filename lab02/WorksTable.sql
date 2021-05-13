USE [Merh MyBase]
GO

/****** Object:  Table [dbo].[Works]    Script Date: 12.02.2021 17:55:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Works_](
	[Work_ID] [int] NOT NULL,
	[Worker_ID] [int] NOT NULL,
	[Operation] [varchar](20) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_Works_] PRIMARY KEY CLUSTERED 
(
	[Work_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Works_]  WITH CHECK ADD  CONSTRAINT [FK_Works_Operations] FOREIGN KEY([Operation])
REFERENCES [dbo].[Operations] ([Operation])
GO

ALTER TABLE [dbo].[Works_] CHECK CONSTRAINT [FK_Works_Operations]
GO

ALTER TABLE [dbo].[Works_]  WITH CHECK ADD  CONSTRAINT [FK_Works_Workers] FOREIGN KEY([Worker_ID])
REFERENCES [dbo].[Workers] ([Worker_ID])
GO

ALTER TABLE [dbo].[Works_] CHECK CONSTRAINT [FK_Works_Workers]
GO


