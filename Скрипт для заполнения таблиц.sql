CREATE DATABASE SwimCompetition_BI19onl_group2

/*Заполнение таблицы Medical_Date*/

DECLARE @Growth INT, @Chronic VARCHAR(3), @MedicationsTaken VARCHAR(20), @Allergies VARCHAR(20)

DECLARE @Counter INT = 1

WHILE (@Counter <= 10000)
BEGIN
    SET @Growth = ABS(CHECKSUM(NEWID())) % 71 + 150
    SET @Chronic = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'Yes' ELSE 'No' END
    SET @MedicationsTaken = CASE ABS(CHECKSUM(NEWID())) % 3 
                            WHEN 0 THEN 'Aspirin' 
                            WHEN 1 THEN 'Paracetamol' 
                            ELSE 'Ibuprofen' END
    SET @Allergies = CASE ABS(CHECKSUM(NEWID())) % 4 
                        WHEN 0 THEN 'Pollen' 
                        WHEN 1 THEN 'Dust' 
                        WHEN 2 THEN 'Penicillin' 
                        ELSE 'Seafood' END
    
    INSERT INTO Medical_Date (Growth, Chronic, Medications_taken, Allergies)
    VALUES (@Growth, @Chronic, @MedicationsTaken, @Allergies)
    
    SET @Counter += 1
END

Select * from Medical_Date

/*Заполнение таблицы Doping_control*/
Declare @DateDoping Date, @ResultDoring VARCHAR(20) 

DECLARE @Counter2 INT = 1

While (@Counter2 <= 10000)
Begin 
	SET @DateDoping = DATEADD(DAY, Rand()*(0-3650), GETDATE())
	SET @ResultDoring = CASE Round(Rand(),0)
				WHEN 0 THEN 'negative'
				ELSE 'positive' END
	INSERT INTO Doping_control ([Date], [Result])
	VALUES(@DateDoping, @ResultDoring)

	SET @Counter2 += 1
END
	
Select * from Doping_control

/*Заполнение таблицы Sponsor*/
Declare @NameSponsor VARCHAR(255), 
		@CountrySponsor VARCHAR(255), 
		@ContactPersonSponsor VARCHAR(255), 
		@AdressSponsor VARCHAR(255), 
		@PhoneSponsor VARCHAR(20), 
		@EmailSponsor VARCHAR(255),
		@SponsoredSummSponsor DECIMAL(10,2)

DECLARE @Counter INT = 1,
		@Varaible INT = (SELECT MIN([AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey]) from [AdventureWorksDW2017].[dbo].[DimCustomer])

WHILE (@Counter <= 10000)
Begin
	SET @NameSponsor = concat((Select TOP 1 [AdventureWorksDW2017].[dbo].[DimReseller].[ResellerName] from [AdventureWorksDW2017].[dbo].[DimReseller] order by NEWID()),' ' , 
							  (Select TOP 1 [AdventureWorks2017].[Purchasing].[Vendor].[Name] from [AdventureWorks2017].[Purchasing].[Vendor] order by NEWID()))

	SET @CountrySponsor = (SELECT TOP 1 [AdventureWorks2017].[Person].[CountryRegion].[Name] FROM [AdventureWorks2017].[Person].[CountryRegion] ORDER BY NEWID())

	SET @ContactPersonSponsor = CONCAT((SELECT [AdventureWorksDW2017].[dbo].[DimCustomer].[LastName] from [AdventureWorksDW2017].[dbo].[DimCustomer] where [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] = @Varaible), ' ',
									  (SELECT [AdventureWorksDW2017].[dbo].[DimCustomer].[FirstName] from [AdventureWorksDW2017].[dbo].[DimCustomer] where [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] = @Varaible))
	
	SET @AdressSponsor = (SELECT [AdventureWorksDW2017].[dbo].[DimCustomer].[AddressLine1] from [AdventureWorksDW2017].[dbo].[DimCustomer] where [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] = @Varaible) 

	SET @PhoneSponsor = CONCAT('+', (SELECT [AdventureWorksDW2017].[dbo].[DimCustomer].[Phone] from [AdventureWorksDW2017].[dbo].[DimCustomer] where [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] = @Varaible))

	SET @EmailSponsor = (SELECT [AdventureWorksDW2017].[dbo].[DimCustomer].[EmailAddress] from [AdventureWorksDW2017].[dbo].[DimCustomer] where [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] = @Varaible) 

	SET @SponsoredSummSponsor = ROUND(RAND()*(150000 - 10) + 10, 2)

	INSERT INTO Sponsor (Name, Country, ContactPerson, Adress, Phone, Email, SponsoredSumm)
    VALUES (@NameSponsor, @CountrySponsor, @ContactPersonSponsor, @AdressSponsor, @PhoneSponsor, @EmailSponsor, @SponsoredSummSponsor)

	SET @Varaible = (SELECT MIN([AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey]) from [AdventureWorksDW2017].[dbo].[DimCustomer] WHERE [AdventureWorksDW2017].[dbo].[DimCustomer].[CustomerKey] >  @Varaible)
	SET @Counter +=1

END

Select * from [dbo].[Sponsor]

/*Заполнение таблицы Juge*/
Declare @FirstNameJuge VARCHAR(255), 
		@LastNameJuge VARCHAR(255), 
		@GenderJuge VARCHAR(10), 
		@BirthdayJuge DATE, 
		@CountryJuge VARCHAR(255), 
		@AdressJuge VARCHAR(255),
		@PhoneJuge VARCHAR(20),
		@EmailJuge VARCHAR(255),
		@RankJuge VARCHAR(255),
		@ID_card VARCHAR(255)

DECLARE @Counter1 INT = 1

WHILE (@Counter1 <= 10000)
BEGIN
	SET @FirstNameJuge = (SELECT TOP 1 [FirstName] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID())
	SET @LastNameJuge = (SELECT TOP 1 [LastName] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID())
	SET @GenderJuge = CASE (SELECT TOP 1 [Gender] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] WHERE [FirstName] = @FirstNameJuge)
					  WHEN 'F' THEN 'woman'
					  ELSE 'man' END
	SET @BirthdayJuge = dateadd(day, - (rand()*(10000 - 1000) + 1000), dateadd(year, -30, getdate())) 
	SET @CountryJuge = (SELECT TOP 1 [AdventureWorks2017].[Person].[CountryRegion].[Name] FROM [AdventureWorks2017].[Person].[CountryRegion] ORDER BY NEWID())
	SET @AdressJuge = CONCAT( (SELECT TOP 1 City FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID()), ', ',  (SELECT TOP 1 AddressLine1 FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID()))
	SET @PhoneJuge = '+38 (' + LEFT(ABS(CHECKSUM(NEWID())), 3) + ') ' + STUFF(STUFF(LEFT(ABS(CHECKSUM(NEWID())), 9), 4, 1, '-'), 7, 1, '-')
	SET @EmailJuge = CONCAT(@LastNameJuge, '_', LEFT(@FirstNameJuge, 4), '@gmail.com')
	SET @RankJuge = CASE Round(Rand(),0)
					WHEN 0 THEN 'MS'
					ELSE 'WMS' END

	SET @ID_card = concat (ROUND(RAND()*50 + 10,0), LEFT(@CountryJuge, 1), ROUND(RAND()*(500 -100) + 100,0), left(@LastNameJuge, 3), ROUND(RAND()*(2000 -1000) + 1000,0))

	INSERT INTO [dbo].[Juge] ([FirstName], [LastName], [Gender], [Birthday], [Country], [Adress], [Phone], [Email], [Rank], [ID_card])
	VALUES (@FirstNameJuge, @LastNameJuge, @GenderJuge, @BirthdayJuge, @CountryJuge, @AdressJuge, @PhoneJuge, @EmailJuge, @RankJuge, @ID_card)

	SET @Counter1 += 1
END

Select * from [dbo].[Juge]


/*Заполнение таблицы COACH*/
-- Добавление столбца
Alter table Coach add Rank varchar(5)
-- Заполнение таблицы
DECLARE @ID_card VARCHAR(50),    @FirstName varchar(30),
    @LastName varchar(30),     @Birthday date, 
    @Country varchar(50),     @Phone varchar(50), 
    @Email varchar(50),    @Rank varchar(50),
  @Gender VARCHAR(200),     @City varchar (100),     @Street varchar(60), @House varchar(3)
    
DECLARE @COUNTER4 INT = 1
WHILE (@COUNTER4 <= 10000)
BEGIN   SET @ID_card = concat (ROUND(RAND()*50 + 10,0), LEFT((SELECT TOP 1 FirstName FROM [AdventureWorks2017].Person.Person ORDER BY NEWID()), 1), ROUND(RAND()*(500 -100) + 100,0),
      left((SELECT TOP 1 LastName FROM [AdventureWorks2017].Person.Person ORDER BY NEWID()), 3), ROUND(RAND()*(2000 -1000) + 1000,0))
  SET @FirstName = (SELECT TOP 1 FirstName FROM [AdventureWorks2017].Person.Person ORDER BY NEWID())  
  SET @LastName = (SELECT TOP 1 LastName FROM [AdventureWorks2017].Person.Person ORDER BY NEWID())
  SET @Birthday = dateadd(day, - rand()*5000, dateadd(year, -25, getdate()))   
  SET @Country = (SELECT TOP 1 [Name] FROM [AdventureWorks2017].[Person].[CountryRegion] ORDER BY NEWID())
  SET @Phone = '+38 (' + LEFT(ABS(CHECKSUM(NEWID())), 3) + ') ' +            STUFF(STUFF(LEFT(ABS(CHECKSUM(NEWID())), 9)
                , 4, 1, '-')                    , 7, 1, '-')
  SET @Email = LOWER(@LastName) + LEFT(ABS(CHECKSUM(NEWID())), 3) + '@gmail.com'  
  SET @Rank = CASE ROUND((Rand()*(3-1) + 1), 0) 
    WHEN 1 THEN 'WMS'    WHEN 2 THEN 'MS'
    ELSE 'CMS' END 
  SET @Gender = CASE 
        WHEN @FirstName Like '%e' or @FirstName Like  '%et' or @FirstName Like '%th' 
        or @FirstName like '%ya' or @FirstName Like '%in'
        THEN 'Woman'
        ELSE 'Man' END
      
SET @City =  (SELECT TOP 1 [City] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID())
SET @Street = (SELECT TOP 1 [City] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID())
SET @House = (SELECT(ABS(CHECKSUM(NEWID())) % 101) + 1)
  



 INSERT INTO [dbo].[Coach] (ID_card, FirstName, LastName, Birthday, Country, Phone, Email, Rank, 
 [Gender],[City],[Street],[House]) VALUES(@ID_card,@FirstName,@LastName,@Birthday,@Country,@Phone,@Email,@Rank,
 @Gender,@City,@Street,@House)
 SET @COUNTER4 += 1
END

Select * from [dbo].[Coach]

/*Заполнение таблицы POOL*/
-- Изменение констрейнта
Alter table [dbo].[Pool] Drop constraint [CK__Pool__Length__5070F446]
Alter table [dbo].[Pool] Add constraint [Length] CHECK ([Length] IN (50, 100, 200, 400, 800))

-- Заполнение бассейнов на 50
Declare @NamePool VARCHAR(255), @CountryPool VARCHAR(255), @CityPool VARCHAR(255), @LenthPool Int

DECLARE @i INT = 1, @S INT = 1, @N INT = 1, @AU INT = 1, @E INT = 1, @A INT = 1, @Supp int

WHILE @i <= 2000
BEGIN
	SET @Supp = ROUND((Rand()*(10000-1) + 1),0)
	SET @S = (CASE WHEN @Supp % 5 = 1 THEN @S + 1 ELSE @S End)
	SET @N = (CASE WHEN @Supp % 5 = 2 THEN @N + 1 ELSE @N End)
	SET @AU = (CASE WHEN @Supp % 5 = 3 THEN @AU + 1 ELSE @AU End)
	SET @E = (CASE WHEN @Supp % 5 = 4 THEN @E + 1 ELSE @E End)
	SET @A = (CASE WHEN @Supp % 5 != 1 and @i % 5 != 2 and @i % 5 != 3 and @i % 5 != 4 THEN @A + 1 ELSE @A End)

	SET @NamePool = CASE WHEN @Supp % 5 = 1 THEN concat('South American pool No. ', @S)
					WHEN @Supp % 5 = 2 THEN concat('North American pool No. ', @N)
					WHEN @Supp % 5 = 3 THEN concat('Australian pool No. ', @AU)
					WHEN @Supp % 5 = 4 THEN concat('Eurasian pool No ', @E)
					ELSE concat('African pool No ', @A) END
	SET @CountryPool = (SELECT TOP 1 [AdventureWorks2017].[Person].[CountryRegion].[Name] FROM [AdventureWorks2017].[Person].[CountryRegion] ORDER BY NEWID())
	SET @CityPool = (Select top 1 City from [AdventureWorks2017].[Person].[Address] ORDER BY NEWID())
	SET @LenthPool = 50 
									   
    INSERT INTO Pool (Name, Country, City, Length)
    VALUES (@NamePool, @CountryPool, @CityPool, @LenthPool)
    SET @i = @i + 1
END

-- Заполнение бассейнов на 100
DECLARE @i INT = 1
WHILE @i <= 2000
BEGIN
	INSERT INTO Pool (Name, Country, City, Length)
    VALUES ((Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Country] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 100)
    SET @i = @i + 1
END

-- Заполнение бассейнов на 200
DECLARE @i INT = 1
WHILE @i <= 2000
BEGIN
	INSERT INTO Pool (Name, Country, City, Length)
    VALUES ((Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Country] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 200)
    SET @i = @i + 1
END

-- Заполнение бассейнов на 400
DECLARE @i INT = 1
WHILE @i <= 2000
BEGIN
	INSERT INTO Pool (Name, Country, City, Length)
    VALUES ((Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Country] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 400)
    SET @i = @i + 1
END

-- Заполнение бассейнов на 800
DECLARE @i INT = 1
WHILE @i <= 2000
BEGIN
	INSERT INTO Pool (Name, Country, City, Length)
    VALUES ((Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Country] from [dbo].[Pool] where [Pool_ID] = @i), 
			(Select [Name] from [dbo].[Pool] where [Pool_ID] = @i), 800)
    SET @i = @i + 1
END

Select * from [dbo].[Pool]

/*Заполнение таблицы Swimmer*/
-- Изменение типов данных
Alter table [dbo].[Swimmer] Alter column [FirstName] VARCHAR(255)
Alter table [dbo].[Swimmer] Alter column [LastName] VARCHAR(255)
Alter table [dbo].[Swimmer] Alter column [Country] VARCHAR(255)
Alter table [dbo].[Swimmer] Alter column [City] VARCHAR(255)
Alter table [dbo].[Swimmer] Alter column [Street] VARCHAR(255)
Alter table [dbo].[Swimmer] Alter column [Rezident] VARCHAR(255)
Alter table [dbo].[Swimmer] Drop constraint [CK__Swimmer__Gender__60A75C0F]
Alter table [dbo].[Swimmer] Add constraint [Gender] CHECK (Gender IN ('F', 'M'))
Alter table [dbo].[Swimmer] Alter column [Gender] VARCHAR(1)

-- Заполнение
Declare @FirstNameSwimmer VARCHAR(255), 
		@LastNameSwimmer VARCHAR(255), 
		@GenderSwimmer VARCHAR(10), 
		@BirthdaySwimmer DATE, 
		@CountrySwimmer VARCHAR(255), 
		@CitySwimmer VARCHAR(255),
		@StreetSwimmer VARCHAR(255),
		@HouseSwimmer VARCHAR(255),
		@PhoneSwimmer VARCHAR(20),
		@EmailSwimmer VARCHAR(255),
		@RezidentSwimmer VARCHAR(255),
		@RankSwimmer VARCHAR(255),
		@ID_MedicalCard INT,
		@TrainerID INT,
		@ID_Doping INT,
		@ID_card VARCHAR(50)

DECLARE @Counter2 INT = 1

While (@Counter2 <= 57)
Begin
	SET @ID_MedicalCard = (Select top 1 ID_MedicalCard from [dbo].[Medical_Date] ORDER BY NEWID())
	SET @TrainerID = (Select top 1 TrainerID from [dbo].[Coach] ORDER BY NEWID())
	SET @ID_Doping = (Select top 1 ID_Doping from [dbo].[Doping_control] ORDER BY NEWID())
	SET @FirstNameSwimmer = (Select top 1 FirstName from [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] ORDER BY NEWID())
	SET @LastNameSwimmer = (Select top 1 LastName from [AdventureWorksDW2017].[dbo].[DimCustomer] ORDER BY NEWID())
	SET @GenderSwimmer = (SELECT TOP 1 [Gender] FROM [AdventureWorksDW2017].[dbo].[ProspectiveBuyer] WHERE [FirstName] = @FirstNameSwimmer)
	SET @BirthdaySwimmer = dateadd(day, - (rand()*(7000 - 1000) + 1000), dateadd(year, -20, getdate())) 
	SET @CountrySwimmer = (SELECT [Country] FROM [dbo].[Coach] where [TrainerID] = @TrainerID)
	SET @CitySwimmer = (Select top 1 City from [AdventureWorks2017].[Person].[Address] ORDER BY NEWID())
	SET @StreetSwimmer = (Select top 1 AddressLine1 from [AdventureWorks2017].[Person].[Address] ORDER BY NEWID())
	SET @HouseSwimmer = ROUND(RAND()*(150 - 1) + 1, 0)
	SET @PhoneSwimmer = '+38 (' + LEFT(ABS(CHECKSUM(NEWID())), 3) + ') ' + STUFF(STUFF(LEFT(ABS(CHECKSUM(NEWID())), 9), 4, 1, '-'), 7, 1, '-')
	SET @EmailSwimmer = CONCAT(lower(@LastNameSwimmer), '.', lower(LEFT(@FirstNameSwimmer, 1)), '@gmail.com')
	SET @RezidentSwimmer = 'National team of ' + @CountrySwimmer
	SET @RankSwimmer = CASE ROUND((Rand()*(8-1) + 1), 0) 
		WHEN 1 THEN 'U1'
		WHEN 2 THEN 'U2'
		WHEN 3 THEN 'U3'
		WHEN 4 THEN '1'
		WHEN 5 THEN '2'
		WHEN 6 THEN '3'
		WHEN 7 THEN 'CMS'
		ELSE 'MS' END
	SET @ID_card = 	concat (ROUND(RAND()*50 + 10,0), LEFT(@CountrySwimmer, 1), ROUND(RAND()*(500 -100) + 100,0), left(@LastNameSwimmer, 1), ROUND(RAND()*(2000 -1000) + 1000,0))

	SET @Counter2 += 1

	INSERT INTO [dbo].[Swimmer] ([FirstName], [LastName], [Gender], [Birthday], [Country], [City], [Street], [House], [Phone], [Email], [Rezident], [Rank], [ID_MedicalCard], [TrainerID], [ID_Doping], [ID_card])
	VALUES (@FirstNameSwimmer, @LastNameSwimmer, @GenderSwimmer,@BirthdaySwimmer, @CountrySwimmer, @CitySwimmer, @StreetSwimmer, @HouseSwimmer, @PhoneSwimmer, @EmailSwimmer,  @RezidentSwimmer, @RankSwimmer, @ID_MedicalCard, @TrainerID, @ID_Doping, @ID_card)

End

Select * from [dbo].[Coach] 

/*Заполнение таблицы Competition*/
-- Часть 1
Declare @NameCompetition VARCHAR(255), @DateCompetition Date, @IDSponsorCompetition INT, @LevelCompetition VARCHAR(255), @PrizeFundCompetition MONEY, @PollIDCompetition Int

DECLARE @i INT = 1, @S INT = 1, @N INT = 1, @AU INT = 1, @E INT = 1, @A INT = 1, @Supp int, @RangT VARCHAR(2) 

WHILE (@i <= 2500)
BEGIN
	SET @Supp = ROUND((Rand()*(10000-1) + 1),0)
	SET @S = (CASE WHEN @Supp % 5 = 1 THEN @S + 1 ELSE @S End)
	SET @N = (CASE WHEN @Supp % 5 = 2 THEN @N + 1 ELSE @N End)
	SET @AU = (CASE WHEN @Supp % 5 = 3 THEN @AU + 1 ELSE @AU End)
	SET @E = (CASE WHEN @Supp % 5 = 4 THEN @E + 1 ELSE @E End)
	SET @A = (CASE WHEN @Supp % 5 != 1 and @i % 5 != 2 and @i % 5 != 3 and @i % 5 != 4 THEN @A + 1 ELSE @A End)
	SET @RangT = CASE WHEN @i % 5 = 1 THEN 'A'
                 WHEN @i % 5 = 2 THEN 'B'
                 WHEN @i % 5 = 3 THEN 'C'
                 WHEN @i % 5 = 4 THEN 'AB'
                 ELSE 'BC' END

	SET @NameCompetition = Case @i % 2 When 0 then (concat('Competition of ',  (CASE WHEN @Supp % 5 = 1 THEN 'South America '
																			WHEN @Supp % 5 = 2 THEN 'North American '
																			WHEN @Supp % 5 = 3 THEN 'Australia '
																			WHEN @Supp % 5 = 4 THEN 'Eurasian '
																			ELSE 'Africa ' END), @RangT, @i))
							ElSE (concat ('National Competition of', (SELECT TOP 1 [AdventureWorks2017].[Person].[CountryRegion].[Name] FROM [AdventureWorks2017].[Person].[CountryRegion] ORDER BY NEWID()), ' ', @RangT, ' ', @i-1)) END

	SET @DateCompetition = dateadd(day, - (rand()*(10000 - 1000) + 1000), getdate())
	SET @IDSponsorCompetition = (select top 1 [ID_Sponsor] from [dbo].[Sponsor] ORDER BY NEWID())
	SET @LevelCompetition = @RangT
	SET @PrizeFundCompetition = (Select [SponsoredSumm] from [dbo].[Sponsor] where [ID_Sponsor] = @IDSponsorCompetition)
	SET @PollIDCompetition = (select top 1 [Pool_ID] from [dbo].[Pool] ORDER BY NEWID())

	INSERT INTO [dbo].[Competition] ([Date], [ID_Sponsor], [Level], [Prize_fund], [Pool_ID], [Name])
    VALUES (@DateCompetition, @IDSponsorCompetition,@LevelCompetition ,@PrizeFundCompetition, @PollIDCompetition, @NameCompetition)

    SET @i = @i + 1
END

-- Повторить 3 раза
Declare @NameCompetition VARCHAR(255), @DateCompetition Date, @IDSponsorCompetition INT, @LevelCompetition VARCHAR(255), @PrizeFundCompetition MONEY, @PollIDCompetition Int
DECLARE @i INT = 1
WHILE (@i <= 2500)
BEGIN
	SET @NameCompetition = (select [Name] from [dbo].[Competition] where [ID_competition] = @i)
	SET @DateCompetition = (select [Date] from [dbo].[Competition] where [ID_competition] = @i)
	SET @IDSponsorCompetition = (select top 1 [ID_Sponsor] from [dbo].[Sponsor] ORDER BY NEWID())
	SET @LevelCompetition =  (select [Level] from [dbo].[Competition] where [ID_competition] = @i)
	SET @PrizeFundCompetition = (Select [SponsoredSumm] from [dbo].[Sponsor] where [ID_Sponsor] = @IDSponsorCompetition)
	SET @PollIDCompetition = (select [Pool_ID] from [dbo].[Competition] where [ID_competition] = @i)

	INSERT INTO [dbo].[Competition] ([Date], [ID_Sponsor], [Level], [Prize_fund], [Pool_ID], [Name])
    VALUES (@DateCompetition, @IDSponsorCompetition,@LevelCompetition ,@PrizeFundCompetition, @PollIDCompetition, @NameCompetition)

    SET @i = @i + 1
END

Select * from [dbo].[Competition]

/*Заполнение таблицы Result*/
-- Заполнение 1 место
Declare @Prize MONEY, @DPlace INT, @Time TIME, @ID_competition INT, @SwimmingStyle VARCHAR(255), @JugeID INT, @ID_Swimmer INT

DECLARE @i INT = 1
WHILE (@i <= 200000)
BEGIN
	SET @SwimmingStyle = Case ROUND((Rand()*(5 - 1) + 1),0) When 1 then 'Front Crawl'
							When 2 then 'Breaststroke'
							When 3 then 'Butterfly Stroke'
							When 4 then 'Backstroke'
							Else 'Sidestroke' end
	SET @ID_competition = (select top 1 [ID_competition] from [dbo].[Competition] order by NEWID())
	SET @Prize = (select sum([Prize_fund]) from [dbo].[Competition] where [ID_competition] = @ID_competition) / 20 * 10
	SET @DPlace = 1
	SET @JugeID = (select top 1 [JugeID] from [dbo].[Juge] order by NEWID())
	SET @ID_Swimmer = (select top 1 [ID_Swimmer] from [dbo].[Swimmer] order by NEWID())
	SET @Time = concat(0, ':', round((Rand()*(10 - 1) + 1), 0), ':', round((Rand()*(59 - 0) + 0), 0))
		
	INSERT INTO [dbo].[Result] ([Prize], [Place], [Time], [ID_competition], [ID_Swimmer], [JugeID], [SwimmingStyle])
    VALUES (@Prize, @DPlace, @Time, @ID_competition, @ID_Swimmer, @JugeID, @SwimmingStyle)

	 SET @i = @i + 1
END

-- 2 место

Declare @Prize MONEY, @DPlace INT, @Time TIME, @ID_competition INT, @SwimmingStyle VARCHAR(255), @JugeID INT, @ID_Swimmer INT

DECLARE @i INT = 1
WHILE (@i <= 200000)
BEGIN
	SET @SwimmingStyle = (select [SwimmingStyle] from [dbo].[Result] where [ID_Result] = @i)
	SET @ID_competition = (select [ID_competition] from [dbo].[Result] where [ID_Result] = @i)
	SET @Prize = (select sum([Prize_fund]) from [dbo].[Competition] where [ID_competition] = @ID_competition) / 20 * 5
	SET @DPlace = 2
	SET @JugeID = (select top 1 [JugeID] from [dbo].[Juge] order by NEWID())
	SET @ID_Swimmer = (select top 1 [ID_Swimmer] from [dbo].[Swimmer] where ([Gender] = (select [Gender] from[dbo].[Swimmer] where  [ID_Swimmer] = (select [ID_Swimmer] from [dbo].[Result] where [ID_Result] = @i)))order by NEWID())
	SET @Time = concat(0, ':', round((Rand()*(10 - 1) + 1), 0), ':', round((Rand()*(59 - 0) + 0), 0))
		
	INSERT INTO [dbo].[Result] ([Prize], [Place], [Time], [ID_competition], [ID_Swimmer], [JugeID], [SwimmingStyle])
    VALUES (@Prize, @DPlace, @Time, @ID_competition, @ID_Swimmer, @JugeID, @SwimmingStyle)

	 SET @i = @i + 1
END

-- 3 место

Declare @Prize MONEY, @DPlace INT, @Time TIME, @ID_competition INT, @SwimmingStyle VARCHAR(255), @JugeID INT, @ID_Swimmer INT

DECLARE @i INT = 1
WHILE (@i <= 200000)
BEGIN
	SET @SwimmingStyle = (select [SwimmingStyle] from [dbo].[Result] where [ID_Result] = @i)
	SET @ID_competition = (select [ID_competition] from [dbo].[Result] where [ID_Result] = @i)
	SET @Prize = (select sum([Prize_fund]) from [dbo].[Competition] where [ID_competition] = @ID_competition) / 20 * 3
	SET @DPlace = 3
	SET @JugeID = (select top 1 [JugeID] from [dbo].[Juge] order by NEWID())
	SET @ID_Swimmer = (select top 1 [ID_Swimmer] from [dbo].[Swimmer] where ([Gender] = (select [Gender] from[dbo].[Swimmer] where  [ID_Swimmer] = (select [ID_Swimmer] from [dbo].[Result] where [ID_Result] = @i)))order by NEWID())
	SET @Time = concat(0, ':', round((Rand()*(10 - 1) + 1), 0), ':', round((Rand()*(59 - 0) + 0), 0))
		
	INSERT INTO [dbo].[Result] ([Prize], [Place], [Time], [ID_competition], [ID_Swimmer], [JugeID], [SwimmingStyle])
    VALUES (@Prize, @DPlace, @Time, @ID_competition, @ID_Swimmer, @JugeID, @SwimmingStyle)

	 SET @i = @i + 1
END

-- 4 место

Declare @Prize MONEY, @DPlace INT, @Time TIME, @ID_competition INT, @SwimmingStyle VARCHAR(255), @JugeID INT, @ID_Swimmer INT

DECLARE @i INT = 1
WHILE (@i <= 200000)
BEGIN
	SET @SwimmingStyle = (select [SwimmingStyle] from [dbo].[Result] where [ID_Result] = @i)
	SET @ID_competition = (select [ID_competition] from [dbo].[Result] where [ID_Result] = @i)
	SET @Prize = (select sum([Prize_fund]) from [dbo].[Competition] where [ID_competition] = @ID_competition) / 20 * 1
	SET @DPlace = 4
	SET @JugeID = (select top 1 [JugeID] from [dbo].[Juge] order by NEWID())
	SET @ID_Swimmer = (select top 1 [ID_Swimmer] from [dbo].[Swimmer] where ([Gender] = (select [Gender] from[dbo].[Swimmer] where  [ID_Swimmer] = (select [ID_Swimmer] from [dbo].[Result] where [ID_Result] = @i)))order by NEWID())
	SET @Time = concat(0, ':', round((Rand()*(10 - 1) + 1), 0), ':', round((Rand()*(59 - 0) + 0), 0))
		
	INSERT INTO [dbo].[Result] ([Prize], [Place], [Time], [ID_competition], [ID_Swimmer], [JugeID], [SwimmingStyle])
    VALUES (@Prize, @DPlace, @Time, @ID_competition, @ID_Swimmer, @JugeID, @SwimmingStyle)

	 SET @i = @i + 1
END

-- 5 место
Declare @Prize MONEY, @DPlace INT, @Time TIME, @ID_competition INT, @SwimmingStyle VARCHAR(255), @JugeID INT, @ID_Swimmer INT

DECLARE @i INT = 1
WHILE (@i <= 200000)
BEGIN
	SET @SwimmingStyle = (select [SwimmingStyle] from [dbo].[Result] where [ID_Result] = @i)
	SET @ID_competition = (select [ID_competition] from [dbo].[Result] where [ID_Result] = @i)
	SET @Prize = (select sum([Prize_fund]) from [dbo].[Competition] where [ID_competition] = @ID_competition) / 20 * 1
	SET @DPlace = 5
	SET @JugeID = (select top 1 [JugeID] from [dbo].[Juge] order by NEWID())
	SET @ID_Swimmer = (select top 1 [ID_Swimmer] from [dbo].[Swimmer] where ([Gender] = (select [Gender] from[dbo].[Swimmer] where  [ID_Swimmer] = (select [ID_Swimmer] from [dbo].[Result] where [ID_Result] = @i)))order by NEWID())
	SET @Time = concat(0, ':', round((Rand()*(10 - 1) + 1), 0), ':', round((Rand()*(59 - 0) + 0), 0))
		
	INSERT INTO [dbo].[Result] ([Prize], [Place], [Time], [ID_competition], [ID_Swimmer], [JugeID], [SwimmingStyle])
    VALUES (@Prize, @DPlace, @Time, @ID_competition, @ID_Swimmer, @JugeID, @SwimmingStyle)

	 SET @i = @i + 1
END




Select * from [dbo].[Competition] -- ?????????
Select * from [dbo].[Doping_control] -- ?????????
Select * from [dbo].[Juge] -- ?????????
Select * from [dbo].[Medical_Date] -- ?????????
Select * from [dbo].[Pool] -- ?????????
Select * from [dbo].[Result] where ID_competition = 1 -- ?????????
Select * from [dbo].[Sponsor] -- ?????????
Select * from [dbo].[Swimmer] -- ?????????