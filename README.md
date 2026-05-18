# Managing-Governing-Product-Data-in-Modern-Enterprises-Using-XDM

This project builds a full data pipeline around a US logistics dataset — taking raw, messy CSVs from multiple source systems, cleaning them up, and loading them into **Semarchy xDM** so the MDM engine can produce a single trusted version of every record.

---

## Overview

Real-world logistics data is messy. The same product might appear in both your CRM and your ERP with slightly different statuses. A customer might be linked to an address that's been duplicated across systems. Inventory IDs might not even be real primary keys.

This project tackles exactly that. It pulls data from three publishers — **CRM, ERP, and Web** — profiles it, finds the problems, fixes them, and runs the clean data through Semarchy's matching and survivorship engine to produce golden records you can actually trust.

## Dataset

Eight CSV files, roughly 10,000 rows each, covering the full order-to-warehouse lifecycle:

| Table | Rows | Key | Notes |
|---|---|---|---|
| `US_Address` | ~10,009 | `Address_ID` | Duplicate IDs exist across publishers |
| `US_Customer` | 10,000 | `Customer_ID` | Unique PK; links to Address |
| `US_Inventory` | 10,000 | `Inventory_ID` | Duplicate IDs; aggregated by Product+Warehouse |
| `US_Product` | ~10,201 | `Product_ID` | 401 duplicate IDs across Active/Discontinued records |
| `US_Sales_Order` | 10,000 | `Order_ID` | Multi-publisher |
| `US_Sales_Order_Line` | 10,000 | `Order_Line_ID` | Links Orders to Products |
| `US_Supplier` | 10,000 | `Supplier_ID` | Multi-publisher |
| `US_Warehouse` | 16 | `Warehouse_ID` | Reference table |

---

## Repository Structure

```
.
├── Logistics_Data.zip            # Raw source CSVs
│   ├── US_Address.csv
│   ├── US_Customer.csv
│   ├── US_Inventory.csv
│   ├── US_Product.csv
│   ├── US_Sales_Order.csv
│   ├── US_Sales_Order_Line.csv
│   ├── US_Supplier.csv
│   └── US_Warehouse.csv
│
├── analysis/
│   ├── analysis.ipynb            # Full EDA — schema inspection, FK checks, column profiling
│   ├── an1.ipynb                 # PK uniqueness and duplicate analysis
│   └── dataFixing.ipynb          # Inventory ID reformatting fix
│
└── sql/
    ├── 0_importRaw.sql           # Stage 0 — Create p_import schema & tables
    ├── 1_cleanTable.sql          # Stage 1 — Create p_cleansedData schema & bridge tables
    ├── 1_1_importETL.sql         # Stage 1.1 — ETL: trim, normalize, deduplicate into cleansed schema
    ├── 2_CreateLoad.sql          # Stage 2 — Create a Semarchy load batch
    ├── 2_1_insertLoad.sql        # Stage 2.1 — Insert cleansed data into Semarchy SD/SA tables
    ├── 3_dashboard.sql           # Stage 3 — Refresh casestudy.inventory for dashboards
    └── log.sql                   # Archived early load attempt (reference only)
```

---

## Architecture

Data flows through four stages. Each stage has its own SQL script so you can run, inspect, and re-run any step independently.

```
Raw CSVs
   │
   ▼
[0_importRaw.sql]
p_import schema
(raw staging tables)
   │
   ▼
[1_cleanTable.sql + 1_1_importETL.sql]
p_cleansedData schema
- TRIM whitespace
- INITCAP country names
- Deduplicate inventory (GROUP BY Product+Warehouse, SUM quantity)
- Resolve product duplicates (keep Active status)
- Build bridge tables: supplier_product, customer_address
   │
   ▼
[2_CreateLoad.sql + 2_1_insertLoad.sql]
Semarchy xDM (semarchy_db)
- SD_ tables: fuzzy/dedup entities (Address, Customer, Product, Supplier, Warehouse)
- SA_ tables: bridge relationships (SupplierProduct, CustomerAddress)
- MDM matching & survivorship runs automatically
   │
   ▼
[3_dashboard.sql]
casestudy.inventory
(Golden record inventory, dashboard-ready)
```

---

## Prerequisites

- **PostgreSQL** — tested locally at `127.0.0.1:5432`
- **Semarchy xDM** with two databases set up:
  - `semarchy_data` — where staging and cleansed schemas live
  - `semarchy_db` — the MDM engine (home of `casestudy.*`)
  - A `studyauth` user with appropriate permissions
- **Python 3** with `pandas` installed
- **Jupyter Notebook** or JupyterLab (for the EDA notebooks)

---

## Getting Started

### Step 1 — Stage the Raw Data

Run `0_importRaw.sql` against `semarchy_data`. It creates the `p_import` schema and all eight staging tables.

Then load the CSVs in — pgAdmin, DBeaver, or plain psql all work:

```sql
\COPY p_import.address FROM 'US_Address.csv' CSV HEADER;
\COPY p_import.customer FROM 'US_Customer.csv' CSV HEADER;
-- repeat for the remaining 6 tables
```

### Step 2 — Cleanse and Deduplicate

Run `1_cleanTable.sql` first (creates `p_cleansedData` schema), then `1_1_importETL.sql` to move and transform the data. Here's what it does:

- Trims leading/trailing whitespace from every string field
- Title-cases country names with `INITCAP` so "united states" and "United States" don't end up as separate values
- Collapses inventory rows by `(Product_ID, Warehouse_ID)`, summing quantities
- Builds two bridge tables — `customer_address` and `supplier_product` — with deduplicated, publisher-aware pairs

### Step 3 — Fix Inventory IDs (if needed)

The raw `Inventory_ID` field doesn't follow a consistent format. If you hit issues, `dataFixing.ipynb` reformats everything to the `IUS0001` pattern before you proceed.

### Step 4 — Load into Semarchy MDM

Run `2_CreateLoad.sql` against `semarchy_db` to get a Load ID, then `2_1_insertLoad.sql` to push all cleansed records into Semarchy's staging layer. Semarchy takes it from there — matching, merging, and producing golden records automatically.

```sql
-- Get a load ID first
SELECT public.get_new_loadid('case', 'manual_etl_script', 'address_load_test', 'studyauth');

-- Then kick off the batch
SELECT public.submit_load(<your_load_id>, 'INTEGRATE_ADD', 'studyauth');
```

### Step 5 — Refresh the Dashboard Inventory

Run `3_dashboard.sql` against `semarchy_db`. It wipes and repopulates `casestudy.inventory` by joining cleansed inventory records with the golden product IDs from `md_product` — ready for any BI tool to query directly.

```sql
TRUNCATE TABLE casestudy.inventory;
-- Then run the INSERT block in 3_dashboard.sql
```

---

## Exploratory Analysis

Before writing a single line of ETL, the notebooks were used to understand what the data actually looked like. It's worth reading through them if you want to understand *why* certain decisions were made in the SQL.

| Notebook | What it covers |
|---|---|
| `analysis.ipynb` | Schema inspection for all 8 tables — data types, nulls, FK relationships, column length profiling |
| `an1.ipynb` | PK uniqueness checks; this is where the 401 duplicate Product IDs and 18 duplicate Address IDs were first found |
| `dataFixing.ipynb` | Digs into the Inventory ID problem and reformats them consistently |

### Data Quality Findings

**Products** were the biggest surprise — 401 rows share a `Product_ID`, because the same product was recorded as both `Active` and `Discontinued` in different source systems, sometimes with conflicting `Hazard_Class` values. The fix is publisher-aware deduplication in Semarchy rather than blindly picking one row.

**Addresses** had 18 duplicate IDs, but after checking, every single one turned out to be an exact copy — same address, same everything. Safe to deduplicate with `DISTINCT ON`.

**Inventory IDs** aren't really primary keys. The meaningful grain is `(Product_ID, Warehouse_ID)`, so the ETL groups on that and sums the quantities.

---

## Contributors

| Name | GitHub |
|---|---|
| Harshit Sharma | [@harshit17xd](https://github.com/harshit17xd) |
| Shreyashi Singh | [@shreyashi1323](https://github.com/shreyashi1323) |
| Lakshmesh Kumar Sahu | [@lakshmeshRepo](https://github.com/lakshmeshRepo) |
| Aditya Sharma | [@AdityaSharma7777](https://github.com/AdityaSharma7777) |
| Ishaan Singla | [@Ishaan282](https://github.com/Ishaan282) |

---

## Screenshots

**Golden Records — Product Master View**
![Golden Records Product View](image__3_.png)

**Entity Relationship Diagram — MDM Model**
![MDM Entity Relationship Diagram](imagehjk.png)

**Staged Records — Product Source Data**
![Staged Product Source Data](Screenshot_2026-05-18_at_11_55_20.png)

---

## Known Issues

- **`log.sql`** is an old load script from an earlier attempt. It's kept here for reference but `2_1_insertLoad.sql` is the one you actually want to use.
- **Load IDs are hardcoded** in a couple of scripts (`v_load_id := 158`). Make sure to update that to the ID you get back from `get_new_loadid()` before running — otherwise you'll be loading into the wrong batch.
- **The `sa_supplier_product` bridge** uses `Supplier_PUB` for the product publisher FK too. Double-check this lines up with your Semarchy model before running in a new environment.
