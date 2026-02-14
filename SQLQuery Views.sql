use RestaurantDB

--View 1: vw_OrderSummary

CREATE VIEW vw_OrderSummary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    o.OrderDate,
    SUM(od.Quantity * od.Price) AS TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.Name, o.OrderDate;

--output
SELECT * FROM vw_OrderSummary;

--View 2: vw_PopularMenuItems

CREATE VIEW vw_PopularMenuItems AS
SELECT 
    m.Name AS MenuItem,
    SUM(od.Quantity) AS TotalOrdered
FROM MenuItems m
JOIN OrderDetails od ON m.ItemID = od.ItemID
GROUP BY m.Name;

--output
SELECT * FROM vw_PopularMenuItems
ORDER BY TotalOrdered DESC;

--View 3: Customer Reservations

CREATE VIEW vw_CustomerReservations AS
SELECT 
    tr.ReservationID,
    c.Name AS CustomerName,
    t.TableID,
    t.Seats,
    tr.ReservationDate,
    tr.NumberOfGuests,
    tr.Status
FROM TableReservations tr
JOIN Customers c ON tr.CustomerID = c.CustomerID
JOIN Tables t ON tr.TableID = t.TableID;

--output
SELECT * FROM vw_CustomerReservations;

--View 4: Orders With Delivery Address

CREATE VIEW vw_OrdersWithDelivery AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    o.OrderType,
    o.DeliveryAddress,
    o.TotalAmount,
    o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

--output

SELECT * FROM vw_OrdersWithDelivery;

--View 5: vw_MenuWithCategory

CREATE VIEW vw_MenuWithCategory AS
SELECT 
    Name AS MenuItem,
    Category,
    Price
FROM MenuItems;

--output
SELECT * FROM vw_MenuWithCategory;

-- View 6(Final) : vw_FullReport

CREATE VIEW vw_FullReport AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    o.OrderType,
    o.DeliveryAddress,
    o.OrderDate,
    od.ItemID,
    m.Name AS MenuItem,
    m.Category AS MenuCategory,
    od.Quantity,
    od.Price AS ItemPrice,
    od.Quantity * od.Price AS TotalItemAmount,
    t.TableID,
    t.Seats AS TableSeats,
    tr.ReservationDate,
    tr.NumberOfGuests,
    tr.Status AS ReservationStatus,
    o.TotalAmount AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID
LEFT JOIN Tables t ON o.TableID = t.TableID
LEFT JOIN TableReservations tr 
       ON tr.CustomerID = o.CustomerID AND tr.TableID = o.TableID;

--output

SELECT * FROM vw_FullReport
ORDER BY OrderID, ItemID;
