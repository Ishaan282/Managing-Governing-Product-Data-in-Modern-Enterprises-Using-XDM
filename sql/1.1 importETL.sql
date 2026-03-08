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

--# inventory 
INSERT INTO p_cleansedData.inventory
SELECT
    TRIM(Inventory_ID),
    TRIM(Product_ID),
    TRIM(Warehouse_ID),
    Quantity
FROM p_import.inventory;

--# sales order 
INSERT INTO p_cleansedData.sales_order
SELECT
    TRIM(Order_ID),
    TRIM(Customer_ID),
    TRIM(Order_Date),
    TRIM(Warehouse_ID),
    TRIM(Publisher)
FROM p_import.sales_order;

--# sales order line 
INSERT INTO p_cleansedData.sales_order_line
SELECT
    TRIM(Order_Line_ID),
    TRIM(Order_ID),
    TRIM(Product_ID),
    Quantity
FROM p_import.sales_order_line;

--# product bridge 
INSERT INTO p_cleansedData.supplierToProduct
SELECT
    TRIM(Supplier_ID),
    TRIM(Product_ID)
FROM p_import.product;

--# customer bridge
INSERT INTO p_cleansedData.CustomerToAddress
SELECT
    TRIM(Address_ID),
    TRIM(Customer_ID)
FROM p_import.customer
WHERE Address_ID IS NOT NULL;