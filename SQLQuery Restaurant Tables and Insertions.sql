CREATE DATABASE RestaurantDB;
GO

USE RestaurantDB;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(200)
);

INSERT INTO Customers (Name, Phone, Email, Address)
VALUES 
('Ali Reza', '09121234567', 'ali@gmail.com', 'Tehran, Street 1'),
('Sara Ahmadi', '09123456789', 'sara@gmail.com', 'Tehran, Street 2'),
('Reza Moradi', '09127654321', 'reza@gmail.com', 'Tehran, Street 3');

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees (Name, Position, Salary, HireDate)
VALUES
('Hossein Karimi', 'Waiter', 5000, '2024-01-15'),
('Mina Shiri', 'Chef', 10000, '2023-06-10'),
('Ali Ahmadi', 'Manager', 12000, '2022-09-05');


CREATE TABLE Tables (
    TableID INT PRIMARY KEY IDENTITY(1,1),
    Seats INT NOT NULL,
    Location NVARCHAR(50)
);

INSERT INTO Tables (Seats, Location)
VALUES
(4, 'Main Hall'),
(2, 'Terrace'),
(6, 'VIP Room');

CREATE TABLE TableReservations (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    TableID INT NOT NULL FOREIGN KEY REFERENCES Tables(TableID),
    ReservationDate DATETIME NOT NULL,
    NumberOfGuests INT,
    Status NVARCHAR(20) DEFAULT 'Pending' -- Pending, Confirmed, Cancelled
);

INSERT INTO TableReservations (CustomerID, TableID, ReservationDate, NumberOfGuests, Status)
VALUES
(1, 1, '2025-10-27 19:00', 4, 'Confirmed'),
(2, 2, '2025-10-27 18:30', 2, 'Pending');

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200),
    Price DECIMAL(10,2) NOT NULL,
    Category NVARCHAR(50) 
);

INSERT INTO MenuItems (Name, Description, Price, Category)
VALUES
('Pizza Margherita', 'Classic pizza with cheese and tomato', 150000, 'Main Course'),
('Cheeseburger', 'Burger with cheese and lettuce', 120000, 'Main Course'),
('Coke', 'Soft drink 330ml', 20000, 'Beverage');


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
    TableID INT NULL FOREIGN KEY REFERENCES Tables(TableID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    OrderType NVARCHAR(20) NOT NULL CHECK (OrderType IN ('Dine-In','Online-Pickup','Online-Delivery')),
    DeliveryAddress NVARCHAR(200) NULL
);

INSERT INTO Orders (CustomerID, EmployeeID, TableID, OrderType, DeliveryAddress)
VALUES
(1, 1, 1, 'Dine-In', NULL),
(2, NULL, NULL, 'Online-Delivery', 'Tehran, Street 2');


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ItemID INT NOT NULL FOREIGN KEY REFERENCES MenuItems(ItemID),
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

INSERT INTO OrderDetails (OrderID, ItemID, Quantity, Price)
VALUES
(1, 1, 1, 150000),  -- سفارش داخل رستوران: Pizza
(1, 3, 2, 20000),   -- سفارش داخل رستوران: 2 Coke
(2, 2, 1, 120000);  -- سفارش بیرون بر: Cheeseburger


CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(200)
);

INSERT INTO Suppliers (Name, Phone, Address)
VALUES
('Supplier A', '02112345678', 'Tehran, Warehouse 1'),
('Supplier B', '02187654321', 'Tehran, Warehouse 2');

CREATE TABLE Ingredients (
    IngredientID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    QuantityInStock DECIMAL(10,2),
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID)
);

INSERT INTO Ingredients (Name, QuantityInStock, SupplierID)
VALUES
('Cheese', 50, 1),
('Tomato', 100, 1),
('Bread', 200, 2),
('Beef', 75, 2);

CREATE TABLE MenuIngredients (
    MenuIngredientID INT PRIMARY KEY IDENTITY(1,1),
    ItemID INT NOT NULL FOREIGN KEY REFERENCES MenuItems(ItemID),
    IngredientID INT NOT NULL FOREIGN KEY REFERENCES Ingredients(IngredientID),
    QuantityNeeded DECIMAL(10,2) NOT NULL
);

INSERT INTO MenuIngredients (ItemID, IngredientID, QuantityNeeded)
VALUES
(1, 1, 0.2), -- Pizza + Cheese
(1, 2, 0.3), -- Pizza + Tomato
(2, 3, 0.1), -- Burger + Bread
(2, 4, 0.2); -- Burger + Beef


