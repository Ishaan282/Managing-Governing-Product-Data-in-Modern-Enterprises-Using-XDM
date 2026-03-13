-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
CREATE OR REPLACE FUNCTION casestudy.customer_type_name(
    p_customer_type text, p_customer_name text)
RETURNS text LANGUAGE sql IMMUTABLE
AS $$
    SELECT BTRIM(CONCAT_WS(' - ', p_customer_type, p_customer_name));
$$;
``

-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
INSERT INTO casestudy.sd_address (
    b_loadid,       /* System field */
    b_classname,    /* entity name: 'Address' */
    b_pubid,     /* publisher*/
    b_sourceid,  /*Source ID <primary key from CSV> */
    address_line1, city, state, country
)
VALUES 
    (119, 'Address', 'CRM', 'AUS000011', '3383', 'New York', 'New York', 'United States');
