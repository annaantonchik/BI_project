/*Создание БД*/
CREATE DATABASE SwimCompetition_BI19onl_group2

/*Таблица Juge*/

CREATE TABLE Juge (
  JugeID INT PRIMARY KEY IDENTITY(1,1),
  ID_card VARCHAR(255) NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  Gender VARCHAR(10) CHECK (Gender IN ('man', 'woman')),
  Birthday DATE NOT NULL,
  Country VARCHAR(255) NOT NULL,
  Adress VARCHAR(255),
  Phone VARCHAR(20),
  Email VARCHAR(255),
  Rank VARCHAR(255)
);

/*Таблица Sponsor*/
CREATE TABLE Sponsor (              
  ID_Sponsor INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL,
  Country VARCHAR(255),
  ContactPerson VARCHAR(255),
  Adress VARCHAR(255),
  Phone VARCHAR(20) NOT NULL CHECK (Phone LIKE '+%'),
  Email VARCHAR(255) NOT NULL CHECK (Email LIKE '%@%'),
  SponsoredSumm DECIMAL(10,2)
);

/*Таблица Pool*/
CREATE TABLE Pool (
  Pool_ID INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL,
  Country VARCHAR(255),
  City VARCHAR(255),
  Length INT NOT NULL CHECK (Length IN (50, 25))
);

/*Таблица Coach*/
CREATE TABLE Coach (
  TrainerID INT PRIMARY KEY IDENTITY(1,1),
  ID_card VARCHAR(255) NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  Gender VARCHAR(255) CHECK (Gender IN ('man', 'woman')),
  Birthday DATE NOT NULL,
  Country VARCHAR(255) NOT NULL,
  City VARCHAR(255),
  Street VARCHAR(255),
  House VARCHAR(255),
  Phone VARCHAR(255) NOT NULL CHECK (Phone LIKE '+%'),
  Email VARCHAR(255) NOT NULL CHECK (Email LIKE '%@%')
);

/*Таблица Doping_control*/
CREATE TABLE Doping_control (
  ID_Doping INT PRIMARY KEY IDENTITY(1,1),
  Date DATE NOT NULL,
  Result VARCHAR(255) NOT NULL CHECK (Result IN ('positive', 'negative'))
);

/*Таблица Medical_Date*/
CREATE TABLE Medical_Date (
  ID_MedicalCard INT PRIMARY KEY IDENTITY(1,1),
  Growth INT NOT NULL,
  Chronic VARCHAR(255) NOT NULL,
  Medications_taken VARCHAR(255) NOT NULL,
  Allergies VARCHAR(255) NOT NULL
);

/*Таблица Competition*/
CREATE TABLE Competition (
  ID_competition INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL
  Date DATE NOT NULL,
  ID_Sponsor INT,
  Level VARCHAR(255) NOT NULL,
  Prize_fund MONEY NOT NULL,
  Pool_ID INT,
  FOREIGN KEY (ID_Sponsor) REFERENCES Sponsor(ID_Sponsor),
  FOREIGN KEY (Pool_ID) REFERENCES Pool(Pool_ID)
);

/*Таблица Swimmer*/
CREATE TABLE Swimmer (
    ID_Swimmer INT IDENTITY(1,1) PRIMARY KEY,
	ID_card VARCHAR(255) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('man', 'woman')),
    Birthday DATE NOT NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Street VARCHAR(50) NOT NULL,
    House VARCHAR(10) NOT NULL,
    Phone VARCHAR(20) NOT NULL CHECK (Phone LIKE '+%'),
    Email VARCHAR(100) NOT NULL CHECK (Email LIKE '%@%'),
    Rezident VARCHAR(10) NOT NULL,
    Rank VARCHAR(50) NOT NULL,
    ID_MedicalCard INT,
    TrainerID INT,
    ID_Doping INT,
    FOREIGN KEY (ID_MedicalCard) REFERENCES Medical_Date(ID_MedicalCard),
    FOREIGN KEY (TrainerID) REFERENCES Coach(TrainerID),
    FOREIGN KEY (ID_Doping) REFERENCES Doping_control(ID_Doping)
);

/*Таблица Result*/

CREATE TABLE Result (
    ID_Result INT IDENTITY(1,1) PRIMARY KEY,
    Prize MONEY NOT NULL,
    Place INT NOT NULL,
    Time TIME NOT NULL,
    ID_competition INT,
    ID_Swimmer INT,
	SwimmingStyle VARCHAR(255) NOT NULL,
    JugeID INT,
    FOREIGN KEY (ID_competition) REFERENCES Competition(ID_competition),
    FOREIGN KEY (ID_Swimmer) REFERENCES Swimmer(ID_Swimmer),
    FOREIGN KEY (JugeID) REFERENCES Juge(JugeID)
);
