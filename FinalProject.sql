DROP DATABASE IF EXISTS medipharm; 
CREATE DATABASE medipharm;
USE medipharm; 

DROP TABLE IF EXISTS address;
CREATE TABLE address (
	addressID INT PRIMARY KEY AUTO_INCREMENT, 
    streetNum INT NOT NULL,
    streetName VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zipcode VARCHAR(10) NOT NULL
);

LOCK TABLES address WRITE;
INSERT INTO address VALUES
	(1, 480, 'S Bay Harbor Trail', 'Boston', 'MA', 02118),
	(2, 66, 'Chandler Street', 'Boston', 'MA', 02116),
    (3, 90, 'Warren Ave', 'Boston', 'MA', 02116),
    (4, 600, 'East Street', 'Boston', 'MA', 02127),
    (5, 85, 'Mt Vernon Street', 'Boston', 'MA', 02108),
    (6, 950, 'Dorchester Avenue', 'Boston', 'MA', 02125),
    (7, 77, 'Stratton Street', 'Boston', 'MA', 02124),
    (8, 34, 'Catherine Street', 'Boston', 'MA', 02131),
    (9, 101, 'Fernwood Road', 'Chestnut Hill', 'MA', 02467),
    (10, 20, 'Washington Street', 'Brighton', 'MA', 02135),
    (11, 24, 'Somerset Road', 'Brookline', 'MA', 02445),
    (12, 216, 'Summit Avenue', 'Brookline', 'MA', 02446),
    (13, 201, 'Pearl Street', 'Cambridge', 'MA', 02139),
    (14, 427, 'Commercial Street', 'Boston', 'MA', 02109),
    (15, 160, 'Federal Street', 'Boston', 'MA', 02110),
    (16, 27, 'Oxford Street', 'Boston', 'MA', 02111);
UNLOCK TABLES;

DROP TABLE IF EXISTS company;
CREATE TABLE company(
	name VARCHAR(100) PRIMARY KEY, 
    addressID INT UNIQUE NOT NULL,
    CONSTRAINT company_fk_address
		FOREIGN KEY(addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES company WRITE;
INSERT INTO company VALUES
	('HealthGuard Solutions', '1'),
	('VitalRx Pharmacy', '2'),
	('PrimeHealthMD', '3');
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
		ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT customer_fk_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES customer WRITE;
INSERT INTO customer VALUES
	(1, 'Samantha', 'Miller', '6171234567', 'samantham@gmail.com', 4, 'HealthGuard Solutions'),
	(2, 'Michael', 'Johnson', '6179876543', 'michaelj@gmail.com', 5, 'VitalRx Pharmacy'),
	(3, 'Emily', 'Anderson', '3394567890', 'emily.anderson@yahoo.com', 6, 'PrimeHealthMD');
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT employee_fk_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES employee WRITE;
INSERT INTO employee VALUES
	(1, 'Manager', 'David', 'Johnson', '1980-01-01', '6177124567', 'david@healthguard.com', 7, 'HealthGuard Solutions'),
	(2, 'Regular', 'Sarah', 'Davis', '1990-02-15', '2897476543', 'sarah@healthguard.com', 8, 'HealthGuard Solutions'),
	(3, 'Manager', 'Olivia', 'Wilson', '1985-09-03', '6177472674', 'olivia@vitalrx.com', 9, 'VitalRx Pharmacy'),
	(4, 'Regular', 'Liam', 'Walker', '1992-09-22', '6174563267', 'liam@vitalrx.com', 10, 'VitalRx Pharmacy'),
	(5, 'Manager', 'Harper', 'Scott', '1988-05-03', '3397891234', 'harper@primehealth.com', 11, 'PrimeHealthMD'),
	(6, 'Regular', 'Emma', 'Murphy', '1996-12-12', '6172560125', 'harper@primehealth.com', 12, 'PrimeHealthMD');
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
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES supplier WRITE;
INSERT INTO supplier VALUES
	(1, 'MedSupply Direct', '6171112345', 'help@medsupplydirect.com', 13),
	(2, 'PrimeSource Supplies', '6172220987', 'info@primesource.com', 14);
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT supplier_receipt_fk_supplier
		FOREIGN KEY (supplierID) REFERENCES supplier (supplierID)
		ON UPDATE CASCADE ON DELETE CASCADE
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT customer_receipt_fk_customer
		FOREIGN KEY (customerID) REFERENCES customer (customerID)
		ON UPDATE CASCADE ON DELETE CASCADE
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
	addressID INT UNIQUE NOT NULL,
    CONSTRAINT manufacturer_fk_address
		FOREIGN KEY (addressID) REFERENCES address(addressID)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES manufacturer WRITE;
INSERT INTO manufacturer VALUES
	('HealthPro Manufacturing', 'OTC', 15),
	('Apex Solutions', 'BTC', 16);
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
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES drug WRITE;
INSERT INTO drug VALUES
	(1, 'Amphetamine', '(RS)-1-phenylpropan-2-amine', 'stimulant', '25.00', 'Schedule II', '100', 'HealthPro Manufacturing', '10.00', 1),
	(2, 'Acetaminophen', 'N-(4-hydroxyphenyl)ethanamide', 'analgesic', '20.00', 'Schedule I', '150', 'HealthPro Manufacturing', '12.50', 1),
	(3, 'Ibuprofen', '2-(4-isobutylphenyl)propanoic acid', 'analgesic', '30.00', 'Schedule I', '200', 'Apex Solutions', '15.00', 2);
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
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES stored_drug WRITE;
INSERT INTO stored_drug VALUES
	('1', '1', 'Amphetamine', '2023-01-01', '2024-01-01', '50', '2023-01-01'),
	('2', '2', 'Ibuprofen', '2023-02-02', '2024-02-02', '100', '2023-02-02');
UNLOCK TABLES;

DROP TABLE IF EXISTS supplier_company;
CREATE TABLE supplier_company(
    supplierID INT NOT NULL,
    companyName VARCHAR(100) NOT NULL,
    PRIMARY KEY(supplierID, companyName),
    CONSTRAINT company_fk_junc_supplier
		FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT supplier_fk_junc_company
		FOREIGN KEY (companyName) REFERENCES company(name)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES supplier_company WRITE;
INSERT INTO supplier_company VALUES
	(1, 'HealthGuard Solutions'),
	(1, 'VitalRx Pharmacy'),
	(2, 'PrimeHealthMD');
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT supplier_receipt_fk_junc_drug
		FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
		ON UPDATE CASCADE ON DELETE CASCADE
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT drug_fk_junc_manufacturer
		FOREIGN KEY (manufacturerName) REFERENCES manufacturer(manufacturerName)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES drug_manufacturer WRITE;
INSERT INTO drug_manufacturer VALUES
	(1, 'HealthPro Manufacturing'),
	(2, 'Apex Solutions');
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
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT customer_receipt_fk_drug
		FOREIGN KEY (batchNO) REFERENCES stored_drug(batchNO)
		ON UPDATE CASCADE ON DELETE CASCADE
);

LOCK TABLES customer_receipt_drug WRITE;
INSERT INTO customer_receipt_drug VALUES
	(1, 1, 5, 50.00),
	(2, 2, 10, 100.00);
UNLOCK TABLES;

------------------------------------------------------------------------------------------------------------------------------------

-- Function to insert a new tuple into drug table
DROP PROCEDURE IF EXISTS NewTupleDrug;
DELIMITER $$
CREATE PROCEDURE NewTupleDrug (
	IN drugID INT,
	IN drugName VARCHAR(100),
	IN scientificName VARCHAR(200),
	IN drugCategory ENUM("depressant", "stimulant", "hallucinogen", "anesthetic", "analgesic", 
	"inhalant", "cannabis"),
	IN storageTemp DECIMAL(4,2),
	IN dangerousLevel ENUM("Schedule I", "Schedule II", "Schedule III", "Schedule IV", 
	"Schedule V"),
	IN quantity INT,
	IN manufacturerName VARCHAR(200),
	IN unitPrice DECIMAL(13, 4),
	IN storageLocation INT
)
BEGIN
	DECLARE invalid_manufacturer_name TINYINT DEFAULT FALSE;
	BEGIN 
		DECLARE EXIT HANDLER FOR 1452
			SET invalid_manufacturer_name = TRUE;
  
		INSERT INTO drug (drugID, drugName, scientificName, drugCategory, storageTemp, dangerousLevel, quantity, manufacturerName, unitPrice, storageLocation)
		VALUES (drugID, drugName, scientificName, drugCategory, storageTemp, dangerousLevel, quantity, manufacturerName, unitPrice, storageLocation);
        SELECT "1 row was inserted to the drug table" AS message;
	END;
    
	IF invalid_manufacturer_name = TRUE THEN
		SELECT 'Row was not inserted. Manufacturer name is invalid!' AS message;
	END IF;
END$$

DELIMITER ;

-- NewTupleDrug(...) tests
-- CALL NewTupleDrug(4, 'Amphetamine', '(RS)-2-phenylpropan-2-amine', 'stimulant', '25.00', 'Schedule III', '100', 'Apexx Solutions', '10.00', 1);
-- CALL NewTupleDrug(4, 'Amphetamine', '(RS)-2-phenylpropan-2-amine', 'stimulant', '25.00', 'Schedule III', '100', 'Apex Solutions', '10.00', 1);
-- SELECT * FROM drug;

-- Function to delete an existing drug tuple
DROP PROCEDURE IF EXISTS DelTupleDrug;
DELIMITER $$
CREATE PROCEDURE DelTupleDrug (IN id INT)
BEGIN
	DECLARE rows_affected INT;
	DELETE FROM drug WHERE drugID = id;

	SET rows_affected = ROW_COUNT();
	IF rows_affected = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'No matching row found for deletion.';
	ELSE SELECT '1 row was deleted from table.';
	END IF;
END$$

DELIMITER ;
-- DelTupleDrug tests
-- CALL DelTupleDrug(4);
-- SELECT * FROM drug;


-- returns table of all drugs and their stock 
DELIMITER $$
CREATE PROCEDURE returnDrugStock()
BEGIN
    SELECT drugName, quantity FROM drug;
END $$
DELIMITER ;
-- Tests 
-- CALL returnDrugStock(); 

-- HELPER METHODS 
-- Procedure to get customer receipt details
DELIMITER $$
CREATE PROCEDURE getCustomerReceipt(IN receiptID INT)
BEGIN
    DECLARE receiptExists INT;

    SELECT COUNT(*) INTO receiptExists 
    FROM customer_receipt
    WHERE customerInvoiceID = receiptID;

    IF receiptExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No customer receipt found with the provided ID.';
    ELSE
        SELECT *
        FROM customer_receipt
        WHERE customerInvoiceID = receiptID;
    END IF;
END$$
DELIMITER ;
-- Tests
-- CALL getCustomerReceipt(1); 
-- CALL getCustomerReceipt(100); 

-- Procedure to get supplier receipt details
DELIMITER $$
CREATE PROCEDURE getSupplierReceipt(IN receiptID INT)
BEGIN
    DECLARE receiptExists INT;

    SELECT COUNT(*) INTO receiptExists 
    FROM supplier_receipt
    WHERE supplierInvoiceID = receiptID;

    IF receiptExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No supplier receipt found with the provided ID.';
    ELSE
        SELECT *
        FROM supplier_receipt
        WHERE supplierInvoiceID = receiptID;
    END IF;
END$$
DELIMITER ;
-- Tests
-- CALL getSupplierReceipt(1); 
-- CALL getSupplierReceipt(100); 

-- Returns invoice of chosen type and ID
DELIMITER $$
CREATE PROCEDURE getInvoice(IN invoiceType VARCHAR(10), IN receiptID INT)
BEGIN
    IF invoiceType = 'customer' THEN
        SELECT 'Customer Invoice Selected' AS message;
        CALL getCustomerReceipt(receiptID); 
    ELSEIF invoiceType = 'supplier' THEN
		SELECT 'Supplier Invoice Selected' AS message;
        CALL getSupplierReceipt(receiptID);
    ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invalid invoice type. Please enter either "customer" or "supplier".';
    END IF;
END$$
DELIMITER ;
-- Tests
-- CALL getInvoice('customer', 1);
-- CALL getInvoice('customer', 200); 
-- CALL getInvoice('supplier', 2);
-- CALL getInvoice('supplier', 200);
-- CALL getInvoice('employee', 1);


-- update customer contact information (email or mobile phone number) 
DELIMITER $$
CREATE PROCEDURE updateCustomerInfo(IN custID INT, IN in_field VARCHAR(255), IN new_info VARCHAR(255))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM customer WHERE customerID = custID) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: ID does not exist';
	ELSE
		CASE 
			WHEN in_field = 'mobile' THEN
				UPDATE customer SET mobilePhone = new_info WHERE customerID = custID;
			WHEN in_field = 'email' THEN
				UPDATE customer SET emailAddress = new_info WHERE customerID = custID;
			ELSE
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid field';
		END CASE;
	END IF;
END$$

DELIMITER ;
-- Test
-- CALL updateCustomerInfo(1, 'address', '123 Park Street');
-- CALL updateCustomerInfo(10, 'email', 'bob@gmail.com');
-- CALL updateCustomerInfo(1, 'email', 'bob@gmail.com');
-- CALL updateCustomerInfo(1, 'mobile', '9086738912');


## SHANNEN addAddress & addEmployee BELOW ###############

DROP PROCEDURE IF EXISTS AddAddress;
DELIMITER $$
CREATE PROCEDURE AddAddress(
    IN streetNum INT,
    IN streetName VARCHAR(255),
    IN city VARCHAR(50),
    IN state VARCHAR(50),
    IN zipcode VARCHAR(10)
)
BEGIN
	-- Insert the address into the address table
	INSERT INTO address(streetNum, streetName, city, state, zipcode)	
		VALUES (streetNum, streetName, city, state, zipcode);
END $$

DELIMITER ;

CALL AddAddress(40, 'Tuttle Street', 'Boston', 'MA', 02125);

-- add address prereq that you can call in addemployee and addcustomer
## Manager can add an employee
DROP PROCEDURE IF EXISTS AddEmployee;
DELIMITER $$
CREATE PROCEDURE AddEmployee (
  IN managerID INT, -- manager puts in their ID to put in new employee
  IN employeeType ENUM("Manager", "Regular"),
  IN firstName VARCHAR(100),
  IN lastName VARCHAR(100),
  IN DOB DATE,
  IN mobilePhone VARCHAR(10),
  IN emailAddress VARCHAR(225)
)
BEGIN
	DECLARE isManager INT;
    DECLARE addressID INT;
    DECLARE companyName VARCHAR(100);
	
    SELECT address.addressID INTO addressID  FROM address ORDER BY address.addressID DESC LIMIT 1;
    SELECT employee.companyName INTO companyName FROM employee WHERE managerID = employee.employeeID;
    
	-- SELECT COUNT(*) INTO isManager WHERE managerID IN (SELECT employeeID FROM employee WHERE employeeType = 'Manager');
    SELECT COUNT(*) INTO isManager FROM employee WHERE managerID IN (SELECT employeeID FROM employee WHERE employeeType = 'Manager');
    
    IF isManager = 1 THEN
		INSERT INTO employee(employeeType, firstName, lastName, DOB, mobilePhone, emailAddress, addressID, companyName)
			VALUES (employeeType, firstName, lastName, DOB, mobilePhone, emailAddress, addressID, companyName);
		SELECT 'Successfully added employee.' AS Message;
	ELSE
		SELECT 'Invalid manager ID. Not authorized to add employee.' AS Message;
  END IF;
END $$

DELIMITER ;

CALL AddEmployee (1, 'Regular', 'Shannen', 'Espinosa', '2002-11-06', '6176377190', 'espinosa.s@northeastern.edu');
