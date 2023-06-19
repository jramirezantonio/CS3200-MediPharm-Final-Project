
DROP DATABASE IF EXISTS medipharm; 
CREATE DATABASE medipharm;
USE medipharm; 

DROP TABLE IF EXISTS address;
CREATE TABLE address (
	addressID INT PRIMARY KEY AUTO_INCREMENT, 
    streetNum INT NOT NULL,
    streetName VARCHAR(255) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    state VARCHAR(50) NOT NULL
);

LOCK TABLES address WRITE;
INSERT INTO address VALUES
	('1', '123', 'Main Street', '12345', 'CA'),
	('2', '456', 'Elm Street', '67890', 'NY');
UNLOCK TABLES;

DROP TABLE IF EXISTS company;
CREATE TABLE company(
	name VARCHAR(100) PRIMARY KEY, 
    addressID INT UNIQUE NOT NULL,
    CONSTRAINT company_fk_address
		FOREIGN KEY(addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES company WRITE;
INSERT INTO company VALUES
	('ABC Company', '1'),
	('XYZ Corporation', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	customerID INT PRIMARY KEY, 
    firstName VARCHAR(100) NOT NULL, 
    lastName VARCHAR(100) NOT NULL,
    mobilePhone VARCHAR(10) NOT NULL, 
    emailAddress VARCHAR(255) NOT NULL, 
	addressID INT UNIQUE NOT NULL,
    companyName VARCHAR(100) NOT NULL, 
    CONSTRAINT customer_fk_address
		FOREIGN KEY (addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT customer_fk_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES customer WRITE;
INSERT INTO customer VALUES
	('1', 'John', 'Doe', '1234567890', 'john@example.com', '1', 'ABC Company'),
	('2', 'Jane', 'Smith', '1234567891', 'jane@example.com', '2', 'XYZ Corporation');
UNLOCK TABLES;

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	employeeID INT PRIMARY KEY,
    employeeType ENUM("Manager", "Regular") NOT NULL, 
    firstName VARCHAR(100) NOT NULL, 
    lastName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL, 
    mobilePhone VARCHAR(10) NOT NULL, 
    emailAddress VARCHAR(255) NOT NULL, 
	addressID INT UNIQUE NOT NULL,
    companyName VARCHAR(100), 
    CONSTRAINT employee_fk_addresss
		FOREIGN KEY (addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT employee_fk_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES employee WRITE;
INSERT INTO employee VALUES
	('1', 'Manager', 'David', 'Johnson', '1980-01-01', '2147124567', 'david@example.com', '1', 'ABC Company'),
	('2', 'Regular', 'Sarah', 'Davis', '1990-02-02', '2147476543', 'sarah@example.com', '2', 'XYZ Corporation');
UNLOCK TABLES;

DROP TABLE IF EXISTS supplier;
CREATE TABLE supplier(
	supplierID INT PRIMARY KEY AUTO_INCREMENT,
	companyName VARCHAR(64) NOT NULL,
	mobilePhone VARCHAR(10) NOT NULL,
	emailAddress VARCHAR(32) NOT NULL,
	addressID INT UNIQUE NOT NULL,
    CONSTRAINT supplier_fk_address
		FOREIGN KEY (addressID) REFERENCES address (addressID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES supplier WRITE;
INSERT INTO supplier VALUES
	('1', 'Supplier 1', '1111111111', 'supplier1@example.com', '1'),
	('2', 'Supplier 2', '2222222222', 'supplier2@example.com', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS supplier_receipt;
CREATE TABLE supplier_receipt(
	supplierInvoiceID INT PRIMARY KEY AUTO_INCREMENT,
	date DATE NOT NULL,
	totalAmount DECIMAL(13, 4) NOT NULL,
	paymentType ENUM("Check", "VISA", "Mastercard", "Cash") NOT NULL,
	discount DECIMAL(13, 4),
	paidAmount DECIMAL(13, 4),
	remainingAmount DECIMAL(13, 4),
	employeeID INT,
	supplierID INT,
    CONSTRAINT supplier_receipt_fk_employee
		FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT supplier_receipt_fk_supplier
		FOREIGN KEY (supplierID) REFERENCES supplier (supplierID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES supplier_receipt WRITE;
INSERT INTO supplier_receipt VALUES
	('1', '2023-06-01', '1000.00', 'Check', '100.00', '900.00', '100.00', '1', '1'),
    ('2', '2023-06-02', '500.00', 'VISA', '50.00', '450.00', '50.00', '2', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS customer_receipt;
CREATE TABLE customer_receipt(
	customerInvoiceID INT PRIMARY KEY AUTO_INCREMENT,
	date DATE,
	totalAmount DECIMAL(13, 4) NOT NULL,
	paymentType ENUM("Check", "VISA", "Mastercard", "Cash") NOT NULL,
	discount DECIMAL(13, 4) NOT NULL,
	paidAmount DECIMAL(13, 4) NOT NULL,
	remainingAmount DECIMAL(13, 4) NOT NULL,
	employeeID INT NOT NULL,
	customerID INT NOT NULL,
    CONSTRAINT customer_receipt_fk_employee
		FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT customer_receipt_fk_customer
		FOREIGN KEY (customerID) REFERENCES customer (customerID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES customer_receipt WRITE;
INSERT INTO customer_receipt VALUES
	('1', '2023-06-01', '2000.00', 'Cash', '200.00', '1800.00', '200.00', '1', '1'),
    ('2', '2023-06-02', '1500.00', 'Mastercard', '150.00', '1350.00', '150.00' ,'2', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS manufacturer;
CREATE TABLE manufacturer(
	manufacturerName VARCHAR(200) PRIMARY KEY,
	drugsProduced ENUM("OTC", "BTC") NOT NULL,
	scientificName VARCHAR(200) UNIQUE NOT NULL,
	addressID INT UNIQUE NOT NULL,
    CONSTRAINT manufacturer_fk_address
		FOREIGN KEY (addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES manufacturer WRITE;
INSERT INTO manufacturer VALUES
	('Manufacturer 1', 'OTC', 'Scientific Name 1', '1'),
    ('Manufacturer 2', 'BTC', 'Scientific Name 2', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS drug;
CREATE TABLE drug(
	drugID INT PRIMARY KEY AUTO_INCREMENT,
	drugName VARCHAR(100) NOT NULL,
	scientificName VARCHAR(200) UNIQUE NOT NULL,
	drugCategory ENUM("depressant", "stimulant", "hallucinogen", "anesthetic", "analgesic", 
	"inhalant", "cannabis") NOT NULL,
	storageTemp DECIMAL(4,2) NOT NULL,
	dangerousLevel ENUM("Schedule I", "Schedule II", "Schedule III", "Schedule IV", 
	"Schedule V") NOT NULL,
	quantity INT,
	manufacturerName VARCHAR(200) NOT NULL,
	unitPrice DECIMAL(13, 4) NOT NULL,
	storageLocation INT NOT NULL,
    CONSTRAINT drug_fk_manufacturer
		FOREIGN KEY (manufacturerName) REFERENCES manufacturer(manufacturerName)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES drug WRITE;
INSERT INTO drug VALUES
	('1', 'Drug 1', 'Scientific Name 1', 'depressant', '25.00', 'Schedule II', '100', 'Manufacturer 1', '10.00', '1'),
    ('2', 'Drug 2', 'Scientific Name 2', 'stimulant', '30.00', 'Schedule III', '200', 'Manufacturer 2', '15.00', '2');
UNLOCK TABLES;

DROP TABLE IF EXISTS stored_drug;
CREATE TABLE stored_drug(
	batchNO INT PRIMARY KEY AUTO_INCREMENT,
	drugID INT NOT NULL,
	drugName VARCHAR(100) NOT NULL,
	manufacturingDate DATE NOT NULL,
	expiryDate DATE NOT NULL,
	quantity INT NOT NULL,
	dateOfEntry DATE NOT NULL,
    CONSTRAINT stored_drug_fk_drug
		FOREIGN KEY (drugID) REFERENCES drug(drugID)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES stored_drug WRITE;
INSERT INTO stored_drug VALUES
	('1', '1', 'Drug 1', '2023-01-01', '2024-01-01', '50', '2023-01-01'),
    ('2', '2', 'Drug 2', '2023-02-02', '2024-02-02', '100', '2023-02-02');
UNLOCK TABLES;

DROP TABLE IF EXISTS supplier_company;
CREATE TABLE supplier_company(
    supplierID INT NOT NULL,
    companyName VARCHAR(100) NOT NULL,
    PRIMARY KEY(supplierID, companyName),
    CONSTRAINT company_fk_junc_supplier
		FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT supplier_fk_junc_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES supplier_company WRITE;
INSERT INTO supplier_company VALUES
	('1', 'ABC Company'),
    ('2', 'XYZ Corporation');
UNLOCK TABLES;

DROP TABLE IF EXISTS supplier_receipt_drug;
CREATE TABLE supplier_receipt_drug(
    supplierInvoiceID INT NOT NULL,
    batchNO INT NOT NULL,
    quantity INT NOT NULL,
    priceTotal DECIMAL(13, 4),
    PRIMARY KEY(supplierInvoiceID, batchNO),
    CONSTRAINT drug_fk_junc_supplier_receipt
		FOREIGN KEY (supplierInvoiceID) REFERENCES supplier_receipt(supplierInvoiceID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT supplier_receipt_fk_junc_drug
		FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES supplier_receipt_drug WRITE;
INSERT INTO supplier_receipt_drug VALUES
	(1, 1, 10, 100.00),
    (2, 2, 20, 200.00);
UNLOCK TABLES;

DROP TABLE IF EXISTS drug_manufacturer;
CREATE TABLE drug_manufacturer(
    drugID INT NOT NULL,
    manufacturerName VARCHAR(200) NOT NULL,
    PRIMARY KEY(drugID, manufacturerName),
    CONSTRAINT manufacturer_fk_junc_drug
		FOREIGN KEY (drugID) REFERENCES drug(drugID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT drug_fk_junc_manufacturer
		FOREIGN KEY (manufacturerName) REFERENCES manufacturer(manufacturerName)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES drug_manufacturer WRITE;
INSERT INTO drug_manufacturer VALUES
	(1, 'Manufacturer 1'),
    (2, 'Manufacturer 2');
UNLOCK TABLES;

DROP TABLE IF EXISTS customer_receipt_drug;
CREATE TABLE customer_receipt_drug(
    customerInvoiceID INT NOT NULL,
    batchNO INT NOT NULL,
	quantity INT NOT NULL,
    priceTotal DECIMAL(13, 4),
    PRIMARY KEY(customerInvoiceID, batchNO),
    CONSTRAINT drug_fk_junc_customer_receipt
		FOREIGN KEY (customerInvoiceID) REFERENCES customer_receipt(customerInvoiceID)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT customer_receipt_fk_drug
		FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

LOCK TABLES customer_receipt_drug WRITE;
INSERT INTO customer_receipt_drug VALUES
	(1, 1, 5, 50.00),
    (2, 2, 10, 100.00);
UNLOCK TABLES;
