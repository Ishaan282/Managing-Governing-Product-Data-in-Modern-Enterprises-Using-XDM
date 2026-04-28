-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
--! run in semarchy_data!
CREATE SCHEMA IF NOT EXISTS p_import;

--! address table 
CREATE TABLE p_import.address (
    Address_ID      VARCHAR(100),
    Address_Line1   VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Postal_Code     VARCHAR(20),
    Publisher       VARCHAR(255)
);


--! customer table
CREATE TABLE p_import.customer (
    Customer_ID     VARCHAR(50),
    Customer_Name   VARCHAR(255),
    Customer_Type   VARCHAR(50),
    Mobile          VARCHAR(20),
    Email           VARCHAR(255),
    Address_ID      VARCHAR(50),
    Publisher       VARCHAR(100)
);
SELECT * FROM customer

--! Inventory table
CREATE TABLE p_import.inventory (
    Inventory_ID    VARCHAR(50),
    Product_ID      VARCHAR(50),
    Warehouse_ID    VARCHAR(50),
    Quantity        FLOAT
);

--! Product table 
CREATE TABLE p_import.product (
    Product_ID       VARCHAR(126),
    Category         VARCHAR(126),
    Sub_Category     VARCHAR(126),
    Brand            VARCHAR(126),
    Product_Name     VARCHAR(255),
    Supplier_ID      VARCHAR(126),
    Status           VARCHAR(126),
    Hazard_Class     VARCHAR(126),
    Publisher        VARCHAR(100)
);


--! sales_order_line
CREATE TABLE p_import.sales_order_line (
    Order_Line_ID   VARCHAR(50),
    Order_ID        VARCHAR(50),
    Product_ID      VARCHAR(50),
    Quantity        FLOAT
);

--! Sales_order
CREATE TABLE p_import.sales_order (
    Order_ID        VARCHAR(50),
    Customer_ID     VARCHAR(50),
    Order_Date      VARCHAR(50),
    Warehouse_ID    VARCHAR(50),
    Publisher       VARCHAR(100)
);

--! supplier
CREATE TABLE p_import.supplier (
    Supplier_ID     VARCHAR(50),
    Supplier_Name   VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Publisher       VARCHAR(100)
);

--! warehouse
CREATE TABLE p_import.warehouse (
    Warehouse_ID    VARCHAR(50),
    Warehouse_Name  VARCHAR(255),
    City            VARCHAR(100),
    State           VARCHAR(100),
    Country         VARCHAR(100),
    Publisher       VARCHAR(100)
);


--! confiring the data 
SELECT * FROM p_import.address;

SELECT * FROM p_import.customer;

SELECT * FROM p_import.inventory;

SELECT * FROM p_import.product;

SELECT * FROM p_import.sales_order_line;

SELECT * FROM p_import.sales_order;

SELECT * FROM p_import.supplier;

SELECT * FROM p_import.warehouse;