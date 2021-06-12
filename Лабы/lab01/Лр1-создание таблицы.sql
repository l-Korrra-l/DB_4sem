USE [Мергель Продажи]
GO

/****** Object:  Table [dbo].[ЗАКАЗЧИКИ]    Script Date: 05.02.2021 18:13:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Ииииии](
	[Наименование фирмы] [nvarchar](20) NOT NULL,
	[Допустим] [nvarchar](50) NULL,
	[Расчетный счет] [nvarchar](15) NULL,
 CONSTRAINT [PK_Ну да] PRIMARY KEY CLUSTERED 
(
	[Наименование фирмы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


