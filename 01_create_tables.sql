-- 01_create_tables.sql
CREATE TABLE taxpayers (
  taxpayer_id INT PRIMARY KEY,
  name_hash TEXT,
  region TEXT,
  taxpayer_type TEXT
);

CREATE TABLE returns (
  return_id INT PRIMARY KEY,
  taxpayer_id INT,
  tax_year INT,
  declared_vat_due NUMERIC,
  declared_vat_credit NUMERIC,
  submitted_date DATE
);

CREATE TABLE transactions (
  txn_id INT PRIMARY KEY,
  return_id INT,
  amount NUMERIC,
  txn_date DATE,
  txn_type TEXT
);
