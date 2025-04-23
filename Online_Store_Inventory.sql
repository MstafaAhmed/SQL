-- create database
create database Online_Store_Inventory

-- Database Design
--Entities:
--Categories
--Suppliers
--Products
--Inventory
--Sales

-- Drop tables if they already exist
DROP TABLE IF EXISTS Sales, Inventory, Products, Categories, Suppliers;

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    SupplierID INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Inventory Table
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    QuantityInStock INT,
    ReorderLevel INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sample Data
-- Insert Categories
INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen');

-- Insert Suppliers
INSERT INTO Suppliers VALUES
(1, 'Tech World', 'contact@techworld.com'),
(2, 'Fashion Hub', 'sales@fashionhub.com'),
(3, 'HomeSmart', 'info@homesmart.com');

-- Insert Products
INSERT INTO Products VALUES
(1, 'Smartphone', 1, 1, 499.99),
(2, 'Jeans', 2, 2, 39.99),
(3, 'Blender', 3, 3, 59.99),
(4, 'Laptop', 1, 1, 899.99),
(5, 'T-Shirt', 2, 2, 19.99);

-- Insert Inventory
INSERT INTO Inventory VALUES
(1, 15, 10),
(2, 50, 20),
(3, 5, 10),
(4, 2, 5),
(5, 60, 30);

-- Insert Sales
INSERT INTO Sales VALUES
(1, 1, 10, '2024-04-01'),
(2, 2, 20, '2024-04-05'),
(3, 3, 4, '2024-04-10'),
(4, 1, 5, '2024-04-15'),
(5, 4, 6, '2024-04-18'),
(6, 5, 25, '2024-04-20');


--Useful Queries
--Low Stock Alerts

SELECT 
    p.ProductName,
    i.QuantityInStock,
    i.ReorderLevel
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
WHERE i.QuantityInStock < i.ReorderLevel;

--Best-Selling Products
SELECT 
    p.ProductName,
    SUM(s.QuantitySold) AS TotalSold
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC

--Supplier Performance
SELECT 
    s.SupplierName,
    COUNT(DISTINCT p.ProductID) AS ProductsSupplied,
    SUM(sa.QuantitySold) AS TotalUnitsSold
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Sales sa ON p.ProductID = sa.ProductID
GROUP BY s.SupplierName
ORDER BY TotalUnitsSold DESC;