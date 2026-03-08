-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
INSERT INTO casestudy.sd_address (
   b_loadid,       /* System field */
   b_classname,    /* System field: 'Address' */
   b_pubid,     /* Try b_sourceid if b_pubid failed */
   b_sourceid,             /* Your Source ID: AUS00001 */
   address_line1,
   city,
   state,
   country
)
VALUES 
   (121, 'Address', 'CRM', 'AUS000011', '3383', 'New York', 'New York', 'United States');



COMMIT;