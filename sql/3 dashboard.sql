CREATE SCHEMA p_dashboard;
--! inventory for dashboard 

    -- 1. Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS casestudy.inventory (
    Inventory_ID    VARCHAR(50), 
    Product_ID      VARCHAR(50),
    Warehouse_ID    VARCHAR(50), 
    Quantity        FLOAT
);

DO $$ 
BEGIN
    -- 2. Clear the old data
    TRUNCATE TABLE casestudy.inventory;

    -- 3. Transform, Join, and Insert
    INSERT INTO casestudy.inventory (Inventory_ID, Product_ID, Warehouse_ID, Quantity)
    WITH aggregated_data AS (
        SELECT
            MIN(i.Inventory_ID) AS inv_id,
            m.product_id::VARCHAR(50) AS prod_id, --ID swap 
            TRIM(i.Warehouse_ID) AS wh_id, SUM(i.Quantity) AS total_qty
        FROM p_cleansedData.inventory i
        INNER JOIN casestudy.md_product m ON TRIM(i.Product_ID) = m.b_sourceid
        GROUP BY m.product_id, TRIM(i.Warehouse_ID)
    )
    SELECT inv_id, prod_id, wh_id, total_qty FROM aggregated_data;

    -- 4. Final log message
    RAISE NOTICE 'Inventory refresh complete.';
END $$;

SELECT * FROM casestudy.inventory ORDER BY inventory_id;

--# brand , stock
SELECT 
    g.brand, SUM(d.quantity)::INT AS total_quantity
        FROM casestudy.gd_product g JOIN casestudy.inventory d 
    ON g.product_id::VARCHAR = d.product_id 
GROUP BY g.brand;
    --@ in semarchy 
    SELECT
        casestudy.gd_product.brand,
        CAST(SUM(casestudy.inventory.quantity) AS INTEGER)
    FROM
        casestudy.gd_product
    JOIN
        casestudy.inventory
    ON
        CAST(casestudy.gd_product.product_id AS VARCHAR(50)) =
        casestudy.inventory.product_id
    GROUP BY
        casestudy.gd_product.brand

