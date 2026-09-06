# Enterprise Data Analytics: HR & Sales Performance Overview

An end-to-end business intelligence and data analytics solution bridging the gap between talent management and commercial performance. This project integrates workforce human capital metrics with multi-year transactional sales data to evaluate corporate productivity, regional market efficiency, and employee Return on Investment (Salary ROI).

---

## 📌 Executive Summary & Key Metrics

* **Total Headcount:** 100 Employees across 5 functional departments and 6 corporate hubs
* **Gross Revenue (2020–2024):** ₹5.17M across 1,000 transactions
* **Realized Net Profit:** ₹790.02K (~15.27% net margin)
* **Average Base Salary:** ₹79,883 (Range: ₹40,200 – ₹119,000)
* **Average Appraisal Score:** 3.99 / 5.00

---

## 🛠️ Technology Stack

| Tool / Technology | Role in Project | Core Capabilities |
| :--- | :--- | :--- |
| **Microsoft Excel** | Data Ingestion & Auditing | Data hygiene, type standardization (`DD-MM-YYYY`), exploratory pivot modeling |
| **PostgreSQL / SQL** | Analytical Engine & ETL | 26 production queries, window functions (`RANK()`), CTEs, multi-table joins |
| **Microsoft Power BI** | Semantic Modeling & BI | Star/relational schema, custom DAX measures, dynamic cross-filtering dashboard |

---

## 🏗️ Relational Data Model

The analytical warehouse consists of two primary normalized entities:

* **`employees` (100 records):** Employee master table containing `EmployeeID` (PK), `Name`, `Department`, `Role`, `City`, `Gender`, `Salary`, `HireDate`, `PerformanceScore`, `ManagerID` (Self-FK), and `Experience`.
* **`sales` (1,000 records):** Commercial order transactions containing `OrderID` (PK), `EmployeeID` (FK), `CustomerName`, `Region`, `Category`, `Sales`, `Profit`, `Discount`, and `Date`[cite: 1].

**Relationship:** 1-to-Many (`employees.EmployeeID` → `sales.EmployeeID`)[cite: 1].

---

## 🔍 Analytical Modules & SQL Highlights

The analysis script (`Company Overview Analysis.sql`) comprises 26 production queries categorized across 5 strategic modules[cite: 1]:

1. **Workforce & HR Capacity:** Departmental staffing, compensation benchmarking, appraisal ratings, and geographic hub distribution (Bangalore leads with 23% headcount)[cite: 1].
2. **Territorial Commercial Performance:** Regional revenue and margin analysis (South generated ₹1.37M volume; West delivered peak margin efficiency at 15.86%)[cite: 1].
3. **Product Category Intelligence:** Segment profit classification (Software generated ₹1.21M sales and ₹185.59K profit; Software & Services combined account for 44.1% revenue)[cite: 1].
4. **Cross-Functional Employee Attribution & ROI:** Joining sales orders with employee compensation to compute commercial Return on Salary (e.g., Amit achieved 2.02x ROI; Manav generated ₹111.36K in sales)[cite: 1].
5. **Customer Accounts & Time Trends:** Key corporate client spending (Top client: Sneha Patel with ₹566.59K) and longitudinal tracking across 2020–2024 (peak growth in 2023 at +9.45% YoY)[cite: 1].

---

## 📊 Power BI Dashboard & DAX Measures
<img width="1527" height="858" alt="Screenshot 2026-09-06 120106" src="https://github.com/user-attachments/assets/45e486fb-3b39-44b1-b24b-ec4e1721340b" />

