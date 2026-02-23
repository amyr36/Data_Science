IF OBJECT_ID('Persons', 'U') IS NOT NULL
    DROP TABLE Persons;

CREATE TABLE Persons
(
    PersonID int,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255)
);

INSERT INTO Persons
VALUES (12, 'Hamidi', 'Amirhossein', 'bolvar15khordad', 'qom');

EXEC sp_rename 'Persons.PersonID', 'ID', 'COLUMN';

ALTER TABLE Persons
ALTER COLUMN ID bigint NOT NULL;




