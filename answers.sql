-- Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

------------------------------------------------
-- 1. Offices Table
------------------------------------------------
CREATE TABLE Offices (
    officeCode INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(15)
);

------------------------------------------------
-- 2. Employees Table
------------------------------------------------
CREATE TABLE Employees (
    employeeNumber INT PRIMARY KEY,
    lastName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    officeCode INT NOT NULL,
    FOREIGN KEY (officeCode) REFERENCES Offices(officeCode)
);

------------------------------------------------
-- 3. Customers Table
------------------------------------------------
CREATE TABLE Customers (
    customerNumber INT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    contactLastName VARCHAR(50),
    contactFirstName VARCHAR(50),
    phone VARCHAR(20) UNIQUE,
    city VARCHAR(50),
    country VARCHAR(50),
    salesRepEmployeeNumber INT,
    creditLimit DECIMAL(10,2),
    FOREIGN KEY (salesRepEmployeeNumber) REFERENCES Employees(employeeNumber)
);

------------------------------------------------
-- 4. Payments Table
------------------------------------------------
CREATE TABLE Payments (
    paymentID INT AUTO_INCREMENT PRIMARY KEY,
    customerNumber INT NOT NULL,
    checkNumber VARCHAR(50),
    paymentDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customerNumber) REFERENCES Customers(customerNumber)
);

------------------------------------------------
-- 5. ProductLines Table
------------------------------------------------
CREATE TABLE ProductLines (
    productLine VARCHAR(50) PRIMARY KEY,
    textDescription TEXT
);

------------------------------------------------
-- 6. Products Table
------------------------------------------------
CREATE TABLE Products (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productLine VARCHAR(50) NOT NULL,
    productVendor VARCHAR(100),
    buyPrice DECIMAL(10,2),
    quantityInStock INT NOT NULL,
    FOREIGN KEY (productLine) REFERENCES ProductLines(productLine)
);

------------------------------------------------
-- 7. Orders Table
------------------------------------------------
CREATE TABLE Orders (
    orderID INT PRIMARY KEY,
    customerNumber INT NOT NULL,
    orderDate DATE NOT NULL,
    requiredDate DATE NOT NULL,
    shippedDate DATE,
    status VARCHAR(20) NOT NULL,
    comments TEXT,
    FOREIGN KEY (customerNumber) REFERENCES Customers(customerNumber)
);

------------------------------------------------
-- 8. OrderDetails Table (junction for Many-to-Many Orders↔Products)
------------------------------------------------
CREATE TABLE OrderDetails (
    orderID INT,
    productCode VARCHAR(20),
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (orderID, productCode),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productCode) REFERENCES Products(productCode)
);

------------------------------------------------
-- Sample Data Inserts
------------------------------------------------

-- Offices
INSERT INTO Offices VALUES
(1, 'Copperbelt', 'Kitwe', '+260 975180088', 'Kantanta', NULL, '10101'),
(2, 'Lusaka', 'Matero', '+260 976981023', 'Matero', NULL, '10101');

-- Employees
INSERT INTO Employees VALUES
(1001, 'Smith', 'John', 'john.smith@estore.com', 'Sales Rep', 1),
(1002, 'Brown', 'Emily', 'emily.brown@estore.com', 'Sales Rep', 2);

-- Customers
INSERT INTO Customers VALUES
(2001, 'Alice Johnson', 'Johnson', 'Alice', '+1-212-888-4567', 'Copperbelt', 'Kitwe', 1001, 5000.00),
(2002, 'Bob Williams', 'Williams', 'Bob', '+44-20-2222-7890', 'Lusaka', 'Matero', 1002, 3000.00);

-- Payments
INSERT INTO Payments (customerNumber, checkNumber, paymentDate, amount) VALUES
(2001, 'CHK1001', '2025-09-20', 1200.50),
(2002, 'CHK1002', '2025-09-22', 750.00);

-- ProductLines
INSERT INTO ProductLines VALUES
('Electronics', 'Electronic gadgets and devices'),
('Accessories', 'Computer and phone accessories');

-- Products
INSERT INTO Products VALUES
('P001', 'Laptop', 'Electronics', 'Dell', 800.00, 20),
('P002', 'Mouse', 'Accessories', 'Logitech', 20.00, 200),
('P003', 'Phone', 'Electronics', 'Samsung', 500.00, 50);

-- Orders
INSERT INTO Orders VALUES
(3001, 2001, '2025-09-18', '2025-09-25', '2025-09-21', 'Shipped', 'Delivered on time'),
(3002, 2002, '2025-09-19', '2025-09-28', NULL, 'In Process', 'Pending shipment');

-- OrderDetails
INSERT INTO OrderDetails VALUES
(3001, 'P001', 1, 800.00),
(3001, 'P002', 2, 20.00),
(3002, 'P003', 1, 500.00);
