-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
--! sql for semarchy_data
CREATE SCHEMA IF NOT EXISTS p_cleansedData;


--! create tables 
--# address table 
CREATE TABLE p_cleansedData.address (
    Address_ID      VARCHAR(100),
    Address_Line1   VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Postal_Code     VARCHAR(20),
    Publisher       VARCHAR(255)
);

--# customer table
CREATE TABLE p_cleansedData.customer (
    Customer_ID     VARCHAR(50),
    Customer_Name   VARCHAR(255),
    Customer_Type   VARCHAR(50),
    Mobile          VARCHAR(20),
    Email           VARCHAR(255),
    -- Address_ID      VARCHAR(50),
    Publisher       VARCHAR(100)
);

SELECT * FROM p_cleansedData.customer;

--# inventory table
CREATE TABLE p_cleansedData.inventory (
    Inventory_ID    VARCHAR(50),
    Product_ID      VARCHAR(50),
    Warehouse_ID    VARCHAR(50),
    Quantity        FLOAT
); --transaction
TRUNCATE TABLE p_cleansedData.inventory;

--# product table 
CREATE TABLE p_cleansedData.product (
    Product_ID       VARCHAR(126),
    Category         VARCHAR(126),
    Sub_Category     VARCHAR(126),
    Brand            VARCHAR(126),
    Product_Name     VARCHAR(255),
    -- Supplier_ID      VARCHAR(126),
    Status           VARCHAR(126),
    Hazard_Class     VARCHAR(126),
    Publisher        VARCHAR(100)
);

--# sales_order_line
CREATE TABLE p_cleansedData.sales_order_line (
    Order_Line_ID   VARCHAR(50),
    Order_ID        VARCHAR(50),
    Product_ID      VARCHAR(50),
    Quantity        FLOAT
); --transaction

--# sales_order
CREATE TABLE p_cleansedData.sales_order (
    Order_ID        VARCHAR(50),
    Customer_ID     VARCHAR(50),
    Order_Date      VARCHAR(50),
    Warehouse_ID    VARCHAR(50),
    Publisher       VARCHAR(100)
);  --transaction

--# supplier
CREATE TABLE p_cleansedData.supplier (
    Supplier_ID     VARCHAR(50),
    Supplier_Name   VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Publisher       VARCHAR(100)
);

--# warehouse
CREATE TABLE p_cleansedData.warehouse (
    Warehouse_ID    VARCHAR(50),
    Warehouse_Name  VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Publisher       VARCHAR(100)
); 

--! creating bridge tables 
CREATE TABLE p_cleansedData.supplier_product (
    ID              SERIAL          PRIMARY KEY,
    Supplier_ID     VARCHAR(126),
    Supplier_PUB    VARCHAR(30),    -- publisher code for supplier FK
    Product_ID      VARCHAR(126),
    Product_PUB     VARCHAR(30)    -- publisher code for product FK
);
DROP TABLE p_cleanseddata.supplier_product;
SELECT * FROM p_cleanseddata.supplier_product ORDER BY product_id;

CREATE TABLE p_cleansedData.customer_address (
    ID              SERIAL          PRIMARY KEY,
    Address_ID      VARCHAR(50),
    Address_PUB     VARCHAR(30),    -- publisher code for address FK
    Customer_ID     VARCHAR(50),
    Customer_PUB    VARCHAR(30)    -- publisher code for customer FK
);

DROP TABLE p_cleanseddata.customer_address;