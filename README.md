#  Freemium Conversion Funnel – SQL Analytics
*Building the Foundation for Data-Driven User Journey Insights*

### 🌟 Project Overview
This project forms the data-logic foundation of my Power BI dashboard, where I visualize how users move through a freemium product’s funnel — from signup → activation → conversion → retention.

The purpose of this SQL project was to design and validate the data model, perform key analyses on user behavior, and generate clean tables that later powered the Power BI Dashboard.

👉 **Companion visualization:** [Freemium Conversion Funnel – Power BI Dashboard](INSERT_POWERBI_REPO_LINK_HERE)

### 🎯 Objectives
1. Create an activation-conversion funnel using SQL.
2. Calculate key engagement and retention metrics.
3. Identify user drop-off points.
4. Build clean, reusable datasets for Power BI visualization.

### 🧩 Dataset
- **Tables used:**
  - `conversion_funnel` – contains user signup, activation, conversion timestamps, region, and retention data.
  - `feedback` – stores user ratings and textual feedback on product features.
- **Rows:** 20 sample rows (logic validation only).
- **Columns (key fields):**
  `User_ID`, `Region`, `Signup_Date`, `Activated_Flag`, `Conversion_Date`, `Retention_Days`, `Feature_Name`, `Rating`, `Feedback_Comment`.

### 🧠 SQL Concepts Applied
- CTEs for step-by-step funnel logic.
- CASE WHEN for flag creation ( activation, conversion, churn )
- Aggregate functions ( COUNT, SUM, AVG ) for KPIs.
- Joins between funnel and feedback tables.
- Conditional filtering for 30-day retention calculation
- Window functions(ROW_NUMBER, LAG) for user-level sequencing.


### 📈 KPIs Generated
| Metric | Formula | Description |
|---------|----------|--------------|
| Total Signups | COUNT(User_ID) | Users who signed up |
| Activated Users | SUM(Activated_Flag = TRUE) | Users activated |
| Converted Users | SUM(Converted_Flag = TRUE) | Users converted |
| Retention 30D Rate | AVG(Retained_30D = TRUE) | Retained 30+ days |
| Churn Rate | 1 – Retention Rate | Churn within 30 days |

### 🧹 Data Validation & Transition to Power BI
After confirming that all logic worked correctly on 20 rows, the tables are exported to CSV. When scaling to 300 rows in Power BI, 11 blank activation users appeared - new users who signed up but never activated.
✅These blanks were kept intentionally to simulate real-world user drop-off behavior.


### 🧭 Business Insights from SQL Phase
1. Roughly 70 % of users activated after signup — but only a fraction converted, showing friction in the post-activation stage.
2. Average rating > 4.0 for key features indicates good satisfaction levels.
3. Retention drop after 30 days suggests users lose motivation quickly post-activation.


### 🧰 Tools and Tech Stack
- PostgreSQL 15 – query design & data processing
- DBeaver – IDE for query execution and export
- Excel/CSV – lightweight validation
- Power BI Desktop – next-phase visualization


### ✨ **Linked Project:** [Power BI Dashboard](INSERT_POWERBI_REPO_LINK_HERE)
