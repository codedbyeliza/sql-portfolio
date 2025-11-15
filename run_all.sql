-- run_all.sql
-- 1) Tworzenie tabel
DROP TABLE IF EXISTS taxpayers;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS transactions;

CREATE TABLE taxpayers (
  taxpayer_id INTEGER PRIMARY KEY,
  name_hash TEXT,
  region TEXT,
  taxpayer_type TEXT
);

CREATE TABLE returns (
  return_id INTEGER PRIMARY KEY,
  taxpayer_id INTEGER,
  tax_year INTEGER,
  declared_vat_due NUMERIC,
  declared_vat_credit NUMERIC,
  submitted_date TEXT
);

CREATE TABLE transactions (
  txn_id INTEGER PRIMARY KEY,
  return_id INTEGER,
  amount NUMERIC,
  txn_date TEXT,
  txn_type TEXT
);

-- 2) Wstawianie danych (INSERT) — dane pochodzą z CSV
INSERT INTO taxpayers VALUES (1,'hash_1','Lazio','exporter');
INSERT INTO taxpayers VALUES (2,'hash_2','Lombardia','regular');
INSERT INTO taxpayers VALUES (3,'hash_3','Campania','exporter');
INSERT INTO taxpayers VALUES (4,'hash_4','Sicilia','regular');
INSERT INTO taxpayers VALUES (5,'hash_5','Veneto','regular');
INSERT INTO taxpayers VALUES (6,'hash_6','Emilia-Romagna','exporter');
INSERT INTO taxpayers VALUES (7,'hash_7','Puglia','regular');
INSERT INTO taxpayers VALUES (8,'hash_8','Piemonte','exporter');
INSERT INTO taxpayers VALUES (9,'hash_9','Toscana','regular');
INSERT INTO taxpayers VALUES (10,'hash_10','Marche','regular');

INSERT INTO returns VALUES (1,1,2024,1200.50,200.00,'2024-03-20');
INSERT INTO returns VALUES (2,2,2024,50.00,0.00,'2024-04-15');
INSERT INTO returns VALUES (3,3,2023,0.00,150.00,'2023-02-10');
INSERT INTO returns VALUES (4,1,2023,900.00,100.00,'2023-03-22');
INSERT INTO returns VALUES (5,4,2024,300.00,0.00,'2024-05-10');
INSERT INTO returns VALUES (6,5,2024,0.00,0.00,'2024-06-01');
INSERT INTO returns VALUES (7,6,2022,2000.00,100.00,'2022-03-15');
INSERT INTO returns VALUES (8,7,2024,75.00,0.00,'2024-04-20');
INSERT INTO returns VALUES (9,8,2024,2500.00,300.00,'2024-03-05');
INSERT INTO returns VALUES (10,9,2023,400.00,50.00,'2023-04-10');

INSERT INTO transactions VALUES (1,1,10000.00,'2024-02-10','sale');
INSERT INTO transactions VALUES (2,1,5000.00,'2024-02-12','sale');
INSERT INTO transactions VALUES (3,2,200.00,'2024-03-01','sale');
INSERT INTO transactions VALUES (4,3,1500.00,'2023-01-20','export');
INSERT INTO transactions VALUES (5,7,12000.00,'2022-02-25','sale');
INSERT INTO transactions VALUES (6,9,30000.00,'2024-02-28','export');
INSERT INTO transactions VALUES (7,4,8000.00,'2023-02-15','sale');
INSERT INTO transactions VALUES (8,10,2500.00,'2023-03-20','sale');
INSERT INTO transactions VALUES (9,5,1000.00,'2024-04-01','sale');
INSERT INTO transactions VALUES (10,8,600.00,'2024-03-30','sale');

-- 3) ANALIZY — trzy zapytania do uruchomienia

-- A) Suma VAT należnego i VAT naliczonego wg regionu
SELECT t.region,
       SUM(r.declared_vat_due) AS total_vat_due,
       SUM(r.declared_vat_credit) AS total_vat_credit
FROM returns r
JOIN taxpayers t ON r.taxpayer_id = t.taxpayer_id
GROUP BY t.region
ORDER BY total_vat_due DESC;

-- B) Potencjalni habitual exporters (tu: podatnicy z >=2 deklaracjami)
SELECT r.taxpayer_id, t.name_hash, t.taxpayer_type, COUNT(*) AS returns_count, SUM(r.declared_vat_due) AS sum_vat
FROM returns r
JOIN taxpayers t ON r.taxpayer_id = t.taxpayer_id
GROUP BY r.taxpayer_id, t.name_hash, t.taxpayer_type
HAVING COUNT(*) >= 2
ORDER BY sum_vat DESC;

-- C) Sprawdzenie potencjalnej niezgodności: duże sprzedaże a niski VAT należny
SELECT r.return_id, r.taxpayer_id, r.declared_vat_due, COALESCE(SUM(tx.amount),0) AS sum_sales
FROM returns r
LEFT JOIN transactions tx ON tx.return_id = r.return_id AND tx.txn_type = 'sale'
GROUP BY r.return_id, r.declared_vat_due
HAVING COALESCE(SUM(tx.amount),0) > 10000 AND r.declared_vat_due < 100;
