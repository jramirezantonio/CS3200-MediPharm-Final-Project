DROP DATABASE IF EXISTS medipharm; 
CREATE DATABASE medipharm;
USE medipharm; 

CREATE TABLE address (
	addressID INT PRIMARY KEY AUTO_INCREMENT, 
    streetNum INT NOT NULL,
    streetName VARCHAR(255) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE company(
	name VARCHAR(100) PRIMARY KEY, 
    addressID INT UNIQUE NOT NULL,
    FOREIGN KEY(addressID) REFERENCES address(addressID)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE customer (
	customerID INT PRIMARY KEY, 
    firstName VARCHAR(100) NOT NULL, 
    lastName VARCHAR(100) NOT NULL,
    mobilePhone INT NOT NULL, 
    emailAddress VARCHAR(255) NOT NULL, 
	addressID INT UNIQUE NOT NULL,
    companyName VARCHAR(100) NOT NULL, 
    FOREIGN KEY (addressID) REFERENCES address(addressID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (companyName) REFERENCES company(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE employee (
	employeeID INT PRIMARY KEY,
    employeeType ENUM("manager", "regular") NOT NULL, 
    firstName VARCHAR(100) NOT NULL, 
    lastName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL, 
    mobilePhone INT NOT NULL, 
    emailAddress VARCHAR(255) NOT NULL, 
	addressID INT UNIQUE NOT NULL,
    companyName VARCHAR(100), 
    FOREIGN KEY (addressID) REFERENCES address(addressID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (companyName) REFERENCES company(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE supplier(
supplierID INT PRIMARY KEY AUTO_INCREMENT,
companyName VARCHAR(64) NOT NULL,
mobilePhone VARCHAR(32) NOT NULL,
emailAddress VARCHAR(32) NOT NULL,
addressID INT UNIQUE NOT NULL,
FOREIGN KEY (companyName) REFERENCES company (name)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY (addressID) REFERENCES address (addressID)
ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE supplier_receipt(
supplierInvoiceID INT PRIMARY KEY AUTO_INCREMENT,
date DATE NOT NULL,
totalAmount DECIMAL(13, 4) NOT NULL,
paymentType ENUM("Check", "...") NOT NULL,
discount DECIMAL(13, 4),
paidAmount DECIMAL(13, 4),
remainingAmount DECIMAL(13, 4),
employeeID INT,
supplierID INT,
FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY (supplierID) REFERENCES supplier (supplierID)
ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE customer_receipt(
customerInvoiceID INT PRIMARY KEY AUTO_INCREMENT,
date DATE,
totalAmount DECIMAL(13, 4) NOT NULL,
paymentType ENUM("Check", "...") NOT NULL,
discount DECIMAL(13, 4) NOT NULL,
paidAmount DECIMAL(13, 4) NOT NULL,
remainingAmount DECIMAL(13, 4) NOT NULL,
employeeID INT NOT NULL,
customerID INT NOT NULL,
FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY (customerID) REFERENCES customer (customerID)
ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE manufacturer(
manufacturerName VARCHAR(200) PRIMARY KEY,
drugsProduced ENUM("OTC", "BTC") NOT NULL,
scientificName VARCHAR(200) UNIQUE NOT NULL,
addressID INT UNIQUE NOT NULL,
FOREIGN KEY (addressID) REFERENCES address(addressID)
ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE drug(
drugID INT PRIMARY KEY AUTO_INCREMENT,
drugName VARCHAR(100) NOT NULL,
scientificName VARCHAR(200) UNIQUE NOT NULL,
drugCategory ENUM("depressant", "stimulant", "hallucinogen", "anesthetic", "analgesic", 
"inhalant", "cannabis") NOT NULL,
storageTemp DECIMAL(3,2) NOT NULL,
dangerousLevel ENUM("Schedule I", "Schedule II", "Schedule III", "Schedule IV", 
"Schedule V") NOT NULL,
quantity INT,
manufacturerName VARCHAR(200) NOT NULL,
unitPrice DECIMAL(13, 4) NOT NULL,
storageLocation INT NOT NULL,
FOREIGN KEY (manufacturerName) REFERENCES manufacturer(manufacturerName)
ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE stored_drug(
batchNO INT PRIMARY KEY AUTO_INCREMENT,
drugID INT NOT NULL,
drugName VARCHAR(100) NOT NULL,
manufacturingDate DATE NOT NULL,
expiryDate DATE NOT NULL,
quantity INT NOT NULL,
dateOfEntry DATE NOT NULL,
FOREIGN KEY (drugID) REFERENCES drug(drugID)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- tables for the many to many relationships 
CREATE TABLE supplier_company(
    supplierID INT NOT NULL,
    companyName VARCHAR(100) NOT NULL,
    PRIMARY KEY(supplierID, companyName),
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (companyName) REFERENCES company(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE supplier_receipt_drug(
    supplierInvoiceID INT NOT NULL,
    batchNO INT NOT NULL,
    quantity INT NOT NULL,
    priceTotal DECIMAL(13, 4),
    PRIMARY KEY(supplierInvoiceID, batchNO),
    FOREIGN KEY (supplierInvoiceID) REFERENCES supplier_receipt(supplierInvoiceID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE drug_manufacturer(
    drugID INT NOT NULL,
    manufacturerName VARCHAR(200) NOT NULL,
    PRIMARY KEY(drugID, manufacturerName),
    FOREIGN KEY (drugID) REFERENCES drug(drugID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (manufacturerName) REFERENCES manufacturer(manufacturerName)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE customer_receipt_drug(
    customerInvoiceID INT NOT NULL,
    batchNO INT NOT NULL,
	quantity INT NOT NULL,
    priceTotal DECIMAL(13, 4),
    PRIMARY KEY(customerInvoiceID, batchNO),
    FOREIGN KEY (customerInvoiceID) REFERENCES customer_receipt(customerInvoiceID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
    ON UPDATE CASCADE ON DELETE RESTRICT
);
