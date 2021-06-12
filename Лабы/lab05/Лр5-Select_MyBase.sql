USE [Merh MyBase]

SELECT Workers_.Worker_ID, Workers_.[Last name], Works_.Operation, Works_.Quantity
	FROM Workers_ INNER JOIN Works_
	ON Workers_.Worker_ID = Works_.Worker_ID AND Works_.Quantity > 12;

SELECT distinct Workers_.Worker_ID AS 'Пропуск',
		Works_.Operation AS 'Работа',
		Workers_.[Last name] AS 'ФИО', 
		Workers_.Firstname AS 'ФИО', 
		Workers_.Adress AS 'Адрес'
	FROM Workers_ join Works_ on Workers_.Worker_ID = Works_.Worker_ID 
					join Operations  on Works_.Operation = Operations.Operation
	ORDER BY Workers_.Worker_ID


SELECT distinct Workers_.Worker_ID AS 'Пропуск',
	   Workers_.[Last name] AS 'ФИО',
	   Operations.[Difficulty indicator] AS 'Сложность',		
CASE
	WHEN Operations.Operation Like '%idk%' THEN 'idk'
	else 	'smth else'
END 'Вид операции'
FROM Workers_	INNER JOIN Works_ ON Workers_.Worker_ID = Works_.Worker_ID
					join Operations  ON Works_.Operation = Operations.Operation
	ORDER BY 
	(CASE 
		WHEN Operations.Operation Like '%1%' THEN 1
		WHEN Operations.Operation Like '%0%' THEN 2
		ELSE 3
	 END);

