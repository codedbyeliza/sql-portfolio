# SQL VAT Analysis Project

This project demonstrates basic SQL data analysis using a simple VAT dataset (taxpayers, VAT returns, and transactions).  
The goal is to show practical skills in data modelling, data cleaning, JOINs, aggregations, anomaly detection and business logic understanding.

---

## 📂 Dataset Description

The project includes three CSV files:

- **taxpayers.csv** – anonymized list of taxpayers (region, type)
- **returns.csv** – VAT return data (VAT due, VAT credit, submission date)
- **transactions.csv** – sales/export transactions linked to returns

All data is simulated for training purposes.

---

## 🛠 SQL Files

- **01_create_tables.sql** – table definitions  
- **run_all.sql** – full script: DROP + CREATE + INSERT + 3 analyses  
- **10_analysis.sql** – analytical queries only  

You can run the entire project here (no installation needed):  
https://sqliteonline.com/

---

## 📊 Key Analyses

### 1️⃣ VAT by region  
Checks total VAT due and VAT credit per region.

### 2️⃣ Identifying potential habitual exporters  
Filters taxpayers with 2+ VAT returns and higher export activity.

### 3️⃣ Sales anomaly detection  
Finds cases where **sales are high but VAT due is unusually low**.

This is a common real-world audit scenario.

---

## 🖼 Results Preview

A screenshot of the query results is included in the repository  
(`results_screenshot.png`).

---

## 🚀 How to run (simple)

1. Open https://sqliteonline.com/  
2. Copy contents of `run_all.sql`  
3. Click **Run**  
4. Scroll down to see results of all SELECT queries

---

##
