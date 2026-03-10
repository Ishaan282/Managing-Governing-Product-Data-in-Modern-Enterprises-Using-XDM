-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
--! DB = semarchy_data

--! importing the data from p_import to p_cleansedData (Trim back & forth spaces , Initcap on country)

--# address import 
INSERT INTO p_cleansedData.address
SELECT
    TRIM(Address_ID),
    TRIM(Address_Line1),
    TRIM(City),
    TRIM(State),
    INITCAP(TRIM(Country)),
    TRIM(Postal_Code),
    TRIM(Publisher)
FROM p_import.address;

--# customer import 
INSERT INTO p_cleansedData.customer
SELECT
    TRIM(Customer_ID),
    TRIM(Customer_Name),
    TRIM(Customer_Type),
    TRIM(Mobile),
    TRIM(Email),
    TRIM(Publisher)
FROM p_import.customer;

--# product import 
INSERT INTO p_cleansedData.product
SELECT
    TRIM(Product_ID),
    TRIM(Category),
    TRIM(Sub_Category),
    TRIM(Brand),
    TRIM(Product_Name),
    TRIM(Status),
    TRIM(Hazard_Class),
    TRIM(Publisher)
FROM p_import.product;

--# supplier
INSERT INTO p_cleansedData.supplier
SELECT
    TRIM(Supplier_ID),
    TRIM(Supplier_Name),
    TRIM(City),
    TRIM(State),
    INITCAP(TRIM(Country)),
    TRIM(Publisher)
FROM p_import.supplier;
SELECT * FROM p_cleansedData.supplier;

--# warehouse
INSERT INTO p_cleansedData.warehouse
SELECT
    TRIM(Warehouse_ID),
    TRIM(Warehouse_Name),
    TRIM(City),
    TRIM(State),
    INITCAP(TRIM(Country)),
    TRIM(Publisher)
FROM p_import.warehouse;
SELECT * FROM p_cleansedData.warehouse;

--# inventory 
INSERT INTO p_cleansedData.inventory
SELECT
    TRIM(Inventory_ID),
    TRIM(Product_ID),
    TRIM(Warehouse_ID),
    Quantity
FROM p_import.inventory;
SELECT * FROM p_cleansedData.inventory;

--# sales order 
INSERT INTO p_cleansedData.sales_order
SELECT
    TRIM(Order_ID),
    TRIM(Customer_ID),
    TRIM(Order_Date),
    TRIM(Warehouse_ID),
    TRIM(Publisher)
FROM p_import.sales_order;
SELECT * FROM p_cleansedData.sales_order;

--# sales order line 
INSERT INTO p_cleansedData.sales_order_line
SELECT
    TRIM(Order_Line_ID),
    TRIM(Order_ID),
    TRIM(Product_ID),
    Quantity
FROM p_import.sales_order_line;
SELECT * FROM p_cleansedData.sales_order_line;

--! since pair exists 
--# Insert unique supplier-product pairs
-- Insert unique customer-address pairs with accurate publishers
INSERT INTO p_cleansedData.customer_address 
    (Address_ID, Address_PUB, Customer_ID, Customer_PUB)
SELECT DISTINCT 
    TRIM(c.Address_ID),
    TRIM(a.Publisher),
    TRIM(c.Customer_ID),
    TRIM(c.Publisher)
FROM p_import.customer c
LEFT JOIN p_import.address a 
    ON TRIM(c.Address_ID) = TRIM(a.Address_ID)
WHERE c.Address_ID IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM p_cleansedData.customer_address ca
    WHERE ca.Address_ID = TRIM(c.Address_ID)
      AND ca.Address_PUB = TRIM(a.Publisher)
      AND ca.Customer_ID = TRIM(c.Customer_ID)
      AND ca.Customer_PUB = TRIM(c.Publisher)
);

SELECT * FROM p_cleansedData.customer_address; 


-- Insert unique supplier-product pairs with accurate publishers
INSERT INTO p_cleansedData.supplier_product 
    (Supplier_ID, Supplier_PUB, Product_ID, Product_PUB)
SELECT DISTINCT 
    TRIM(p.Supplier_ID),
    TRIM(s.Publisher),
    TRIM(p.Product_ID),
    TRIM(p.Publisher)
FROM p_import.product p
LEFT JOIN p_import.supplier s 
    ON TRIM(p.Supplier_ID) = TRIM(s.Supplier_ID)
WHERE p.Supplier_ID IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM p_cleansedData.supplier_product sp
    WHERE sp.Supplier_ID = TRIM(p.Supplier_ID)
      AND sp.Supplier_PUB = TRIM(s.Publisher)
      AND sp.Product_ID = TRIM(p.Product_ID)
      AND sp.Product_PUB = TRIM(p.Publisher)
);

SELECT * FROM p_cleansedData.supplier_product WHERE supplier_id = 'SUS00005';
SELECT * FROM p_cleanseddata.supplier ORDER BY supplier_id;