use steeldata;
-- SQL Challenge - 4
-- Dec 16th 2023:->  SQL - 4
-- Create the Customers_4 table
CREATE TABLE Customers_4 (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--
INSERT INTO Customers_4 VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
-- -- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--
INSERT INTO Branches 
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
-- 
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers_4(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);
--
-- Create the Transactions table
CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);
--
-- 1. What are the names of all the customers who live in New York?
select concat(firstname,' ',lastname)names from customers_4 where city like 'new%';

-- 2. What is the total number of accounts in the Accounts table?
select count(accountid)total from accounts;

-- 3. What is the total balance of all checking accounts?
select sum(balance)Total_Balance from accounts where accounttype like 'ch%';

-- 4. What is the total balance of all accounts associated with customers who live in Los Angeles?
select sum(balance)Total_Balance from accounts where customerid in(select customerid from customers_4 where city like 'Los%');

-- 5. Which branch has the highest average account balance?
with sb as(select branchid,avg(balance) from accounts group by branchid order by (1) desc limit 1)
select BranchName from branches join sb using(branchid);

-- 6. Which customer has the highest current balance in their accounts?
select concat(firstname,' ',lastname)Customer from customers_4 join accounts using (customerid)  group by (1) order by sum(balance) desc limit 1;

-- 7. Which customer has made the most transactions in the Transactions table?
with trs as(select a.customerid,count(t.TransactionDate) from Transactions t join accounts a using(accountid) 
join customers_4 c on c.customerid=a.Customerid group by (1) order by (2) desc limit 1 )
select concat(c1.firstname,' ',c1.lastname)Customer from customers_4 c1 join trs using(customerid);

-- 8.Which branch has the highest total balance across all of its accounts?
select branchname,sum(balance)Total_Balance from accounts join branches using(branchid) group by (1) order by (2) desc limit 1;

-- 9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
with bal as(select customerid,sum(balance) from accounts group by customerid order by (2) desc limit 1)
select concat(c1.firstname,' ',c1.lastname)Customer from customers_4 c1 join bal using(customerid);

-- 10. Which branch has the highest number of transactions in the Transactions table?
with bt as (select branchid,count(TransactionDate)tr from accounts join transactions using(accountid) group by (1) order by (2)desc)
select branchname from branches b join bt using(branchid) group by (1) order by (max(bt.tr)) desc limit 2;
--
select * from Customers_4;   
select * from Branches;
select * from Accounts;
select * from Transactions;