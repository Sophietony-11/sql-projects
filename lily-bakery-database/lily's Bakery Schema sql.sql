-- ============================================================
-- Lily's Bakery Database Project (Part 1 & Part 2)
-- Complete SQL Script
-- ============================================================

-- ✅ Reset the database safely
DROP DATABASE IF EXISTS LilysBakery;
CREATE DATABASE LilysBakery;
USE LilysBakery;

-- ============================================================
-- PART 1: TABLE CREATION
-- ============================================================

-- CUSTOMER TABLE
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

-- ORDER TABLE
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE,
    TotalCost DECIMAL(8,2),
    PickupDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- MENU ITEM TABLE
CREATE TABLE MenuItem (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(6,2),
    Status VARCHAR(20)
);

-- INVENTORY TABLE
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    IngredientName VARCHAR(100),
    Quantity DECIMAL(10,2),
    Unit VARCHAR(20)
);

-- RESERVATION TABLE
CREATE TABLE Reservation (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    EventDate DATE,
    EventTime TIME,
    Notes VARCHAR(255),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- ORDER_MENUITEM (Many-to-Many)
CREATE TABLE Order_MenuItem (
    OrderID INT,
    MenuItemID INT,
    PRIMARY KEY (OrderID, MenuItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID)
);

-- MENUITEM_INVENTORY (Many-to-Many)
CREATE TABLE MenuItem_Inventory (
    MenuItemID INT,
    InventoryID INT,
    PRIMARY KEY (MenuItemID, InventoryID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID),
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID)
);

-- RESERVATION_MENUITEM (Many-to-Many)
CREATE TABLE Reservation_MenuItem (
    ReservationID INT,
    MenuItemID INT,
    PRIMARY KEY (ReservationID, MenuItemID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID)
);

-- ============================================================
-- PART 1: INSERT SAMPLE DATA
-- ============================================================

-- CUSTOMERS
INSERT INTO Customer (FirstName, LastName, Phone, Email) VALUES
('Lily', 'Brown', '555-1234', 'lily.brown@example.com'),
('Ethan', 'Clark', '555-5678', 'ethan.clark@example.com'),
('Mia', 'Jones', '555-8765', 'mia.jones@example.com'),
('Olivia', 'Green', '555-3456', 'olivia.green@example.com'),
('Liam', 'White', '555-7890', 'liam.white@example.com');

-- MENU ITEMS
INSERT INTO MenuItem (ItemName, Category, Price, Status) VALUES
('Chocolate Cake', 'Dessert', 25.00, 'Available'),
('Vanilla Cupcake', 'Dessert', 3.50, 'Available'),
('Strawberry Tart', 'Dessert', 6.00, 'Available'),
('Cheese Croissant', 'Pastry', 4.50, 'Available'),
('Blueberry Muffin', 'Pastry', 3.00, 'Out of Stock');

-- INVENTORY
INSERT INTO Inventory (IngredientName, Quantity, Unit) VALUES
('Flour', 50, 'kg'),
('Sugar', 30, 'kg'),
('Eggs', 200, 'pcs'),
('Butter', 20, 'kg'),
('Chocolate', 15, 'kg'),
('Strawberries', 10, 'kg');

-- ORDERS
INSERT INTO Orders (OrderDate, TotalCost, PickupDate, CustomerID) VALUES
('2025-11-01', 50.00, '2025-11-03', 1),
('2025-11-02', 12.00, '2025-11-03', 2),
('2025-11-03', 30.00, '2025-11-05', 3),
('2025-11-04', 45.00, '2025-11-06', 4),
('2025-11-05', 9.00, '2025-11-07', 5);

-- ORDER_MENUITEM
INSERT INTO Order_MenuItem VALUES
(1, 1), (1, 2),
(2, 3),
(3, 4),
(4, 1), (4, 3),
(5, 2);

-- MENUITEM_INVENTORY
INSERT INTO MenuItem_Inventory VALUES
(1, 1), (1, 2), (1, 3), (1, 5),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 6),
(4, 1), (4, 4),
(5, 1), (5, 2), (5, 3), (5, 6);

-- RESERVATIONS
INSERT INTO Reservation (EventDate, EventTime, Notes, CustomerID) VALUES
('2025-12-01', '15:00:00', 'Birthday Cake', 1),
('2025-12-02', '14:00:00', 'Baby Shower', 2),
('2025-12-05', '18:00:00', 'Wedding Dessert', 3),
('2025-12-10', '10:00:00', 'Corporate Breakfast', 4),
('2025-12-12', '19:00:00', 'Anniversary', 5);

-- RESERVATION_MENUITEM
INSERT INTO Reservation_MenuItem VALUES
(1, 1), (1, 2),
(2, 3),
(3, 1), (3, 4),
(4, 5),
(5, 2), (5, 3);

-- ============================================================
-- PART 2: QUERY SCENARIOS (10 QUERIES)
-- ============================================================

-- 1️⃣ Find all customers and their orders
SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalCost
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;

-- 2️⃣ List menu items used in each order
SELECT o.OrderID, m.ItemName, m.Price
FROM Orders o
JOIN Order_MenuItem om ON o.OrderID = om.OrderID
JOIN MenuItem m ON om.MenuItemID = m.MenuItemID
ORDER BY o.OrderID;

-- 3️⃣ Count how many orders each customer has placed
SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY OrderCount DESC;

-- 4️⃣ Find the total value of all orders per day
SELECT OrderDate, SUM(TotalCost) AS DailySales
FROM Orders
GROUP BY OrderDate
ORDER BY OrderDate;

-- 5️⃣ List menu items that are currently available
SELECT ItemName, Category, Price
FROM MenuItem
WHERE Status = 'Available'
ORDER BY Category, ItemName;

-- 6️⃣ Find which ingredients are used for each menu item
SELECT m.ItemName, i.IngredientName
FROM MenuItem m
JOIN MenuItem_Inventory mi ON m.MenuItemID = mi.MenuItemID
JOIN Inventory i ON mi.InventoryID = i.InventoryID
ORDER BY m.ItemName, i.IngredientName;

-- 7️⃣ Total number of menu items associated with each reservation
SELECT r.ReservationID, c.FirstName, c.LastName, COUNT(rm.MenuItemID) AS ItemsCount
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID
JOIN Reservation_MenuItem rm ON r.ReservationID = rm.ReservationID
GROUP BY r.ReservationID, c.FirstName, c.LastName
ORDER BY ItemsCount DESC;

-- 8️⃣ Find customers who have both placed an order and made a reservation
SELECT DISTINCT c.FirstName, c.LastName
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Reservation r ON c.CustomerID = r.CustomerID
ORDER BY c.LastName;

-- 9️⃣ Create a view for reservation details and query it
CREATE VIEW ReservationDetails AS
SELECT r.ReservationID, c.FirstName, c.LastName, r.EventDate, r.EventTime, r.Notes
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID;

-- Query using the view
SELECT * 
FROM ReservationDetails
WHERE EventDate >= '2025-12-01'
ORDER BY EventDate;

-- 🔟 Find ingredients that are running low (less than 15 units)
SELECT IngredientName, Quantity, Unit
FROM Inventory
WHERE Quantity < 15
ORDER BY Quantity ASC;
