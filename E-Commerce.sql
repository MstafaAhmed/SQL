create database E_Commerce
-- Create Tables
-- Customers

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT
);

-- Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(50)
);

-- Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

--insert sample data


-- Categories
INSERT INTO Categories (category_name) VALUES 
('Electronics'), 
('Books'), 
('Clothing');

-- Customers
INSERT INTO Customers (name, email, phone, address) VALUES 
('Alice Johnson', 'alice@email.com', '1234567890', '123 Main St'),
('Bob Smith', 'bob@email.com', '0987654321', '456 Oak Ave');

-- Products
INSERT INTO Products (name, price, stock_quantity, category_id) VALUES
('Smartphone', 699.99, 50, 1),
('Laptop', 1099.99, 30, 1),
('T-shirt', 19.99, 200, 3),
('Novel', 12.49, 100, 2);

-- Orders
INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-04-01', 'Shipped'),
(2, '2024-04-05', 'Processing');

-- Order Items
INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 699.99),
(1, 4, 2, 12.49),
(2, 3, 3, 19.99);

-- Payments
INSERT INTO Payments (order_id, amount, payment_method, payment_date) VALUES
(1, 724.97, 'Credit Card', '2024-04-01'),
(2, 59.97, 'PayPal', '2024-04-05');

--some queries

-- Total revenue
SELECT SUM(amount) AS total_revenue FROM Payments;

-- Top 5 best-selling products
SELECT P.name, SUM(OI.quantity) AS total_sold
FROM Order_Items OI
JOIN Products P ON OI.product_id = P.product_id
GROUP BY P.name
ORDER BY total_sold DESC


-- Customers with more than 1 order
SELECT C.name, COUNT(O.order_id) AS order_count
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.name
HAVING COUNT(O.order_id) > 1;

-- Low stock products (threshold < 50)
SELECT name, stock_quantity
FROM Products
WHERE stock_quantity < 50;

-- Average order value
SELECT AVG(amount) AS avg_order_value FROM Payments;

--Ranking funcation

SELECT C.name, COUNT(O.order_id) AS order_count,
       RANK() OVER (ORDER BY COUNT(O.order_id) DESC) AS rank
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.name
HAVING COUNT(O.order_id) = 1;---- filters out customers who have placed only 1 order.


