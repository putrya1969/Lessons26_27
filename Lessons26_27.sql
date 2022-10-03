--LESSON 27
--CREATE DATABASE Lesson27;
--GO
USE Lesson27;
GO
DROP TABLE Persons
CREATE TABLE Persons
(
    Id INT IDENTITY PRIMARY KEY,
    LastName NVARCHAR(20),
	FirstName NVARCHAR(20),
	Age INT,
	SexType INT,
	Sex NVARCHAR(8),
    Address VARCHAR(100),
)

INSERT INTO Lesson27.dbo.Persons
SELECT 
	TOP 100 
	p.LastName, 
	p.FirstName, 
	(ceiling(RAND(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)))*60)) as Age, 
	(ceiling(RAND(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)))*2)) as SexType,
	'',
	a.AddressLine1 as Address 
FROM [AdventureWorks2019].[Person].[Person] as p
INNER JOIN  [AdventureWorks2019].[Person].[Address] as a ON p.[BusinessEntityID] = a.[AddressID]

UPDATE Persons
SET Sex = CASE SexType WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' END

ALTER TABLE Persons
DROP COLUMN SexType

SELECT * FROM Persons

/*
Using the same person’s table as on the lesson do next: 
select all males
select all persons with age about 18
select all persons without address
update age of all persons, add 1 year
delete all rows without address
count number of rows in table
group persons by age and show how many persons with same age
*/
SELECT * FROM Persons
WHERE Sex = 'male'

SELECT * FROM Persons
WHERE Age > 18

DELETE FROM Persons 
WHERE Address = ''

UPDATE Persons
SET Age = Age + 1

SELECT COUNT(*) as Persons_Rows_Count FROM Persons

SELECT Age, COUNT(Age) as Persons_With_Same_Age FROM Persons
GROUP BY Age
HAVING COUNT(Age) > 1

/*
LESSON 28
Create few tables schemas:
*/
--table for ‘phone book’
SELECT 
	TOP 100 
	p.LastName, 
	p.FirstName, 
	ph.PhoneNumber,
	a.AddressLine1 as Address 
INTO Lesson27.dbo.PhoneBook
FROM [AdventureWorks2019].[Person].[Person] as p
INNER JOIN  [AdventureWorks2019].[Person].[Address] as a ON p.[BusinessEntityID] = a.[AddressID]
INNER JOIN [AdventureWorks2019].[Person].PersonPhone as ph ON p.BusinessEntityID = ph.BusinessEntityID
--table to store school schedule
CREATE TABLE Schedule
(
    Id INT IDENTITY PRIMARY KEY,
    DateTime smalldatetime NOT NULL,
	LessonName NVARCHAR(20) NOT NULL,
	Teacher NVARCHAR(20),
	Form NVARCHAR(5) NOT NULL

)
--table to store user’s login history
CREATE TABLE LogHistory
(
    Id INT IDENTITY PRIMARY KEY,
    DateTime smalldatetime NOT NULL,
	IpAddress NVARCHAR (15) NOT NULL,
	Login NVARCHAR(20) NOT NULL
)
--table to store bank accounts
CREATE TABLE Account
(
    Id INT IDENTITY PRIMARY KEY,
    ClientLastName NVARCHAR(20) NOT NULL,
	ClientFirstName NVARCHAR(20) NOT NULL,
	ClientPhoneId INT,
	FOREIGN KEY (ClientPhoneId) REFERENCES ClientPhones(Id),
	ClientAddressId INT,
	FOREIGN KEY (ClientAddressId) REFERENCES ClientAddresses(Id),
	ClientIN NVARCHAR(20),
	AccountBalance DECIMAL DEFAULT 0
)
--table to store bank transactions data

CREATE TABLE BankTransaction
(
	TransactionId INT IDENTITY PRIMARY KEY,
	TransactionDateTime DateTime  NOT NULL,
	SourceBankId INT  NOT NULL,
	FOREIGN KEY (SourceBankId) REFERENCES Banks(Id),
	SourceAccount NVARCHAR(30)  NOT NULL,
	TargetBankId INT  NOT NULL,
	FOREIGN KEY (TargetBankId) REFERENCES Banks(Id),
	TargetAccount NVARCHAR(30)  NOT NULL,
    TransactionSun MONEY  NOT NULL,
	PurposeOfPayment NVARCHAR(250)  NOT NULL,
	TransactionStatus TINYINT NOT NULL
)
--checked
