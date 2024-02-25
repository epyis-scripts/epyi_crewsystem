ALTER TABLE users
ADD crewName VARCHAR(99) DEFAULT 'citizen',
ADD crewRank INT DEFAULT 0,
ADD crewPower INT DEFAULT 0,
ADD crewMaxPower INT DEFAULT 10;

CREATE TABLE crews_territories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    x INT,
    y INT,
    owner VARCHAR(99)
);

CREATE TABLE crews_influence (
    crew VARCHAR(99) PRIMARY KEY,
    influence INT
);