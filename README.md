# 🧮 Freemium Conversion Funnel – SQL Analytics
*Building the Foundation for Data-Driven User Journey Insights*

### 🌟 Project Overview
This project forms the data-logic foundation of my Power BI dashboard, where I visualize how users move through a freemium product’s funnel — from signup → activation → conversion → retention.

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
- CASE WHEN for flag creation.
- Aggregates for KPIs.
- Joins between funnel and feedback tables.
- Conditional filtering for retention.
- Window functions for sequencing.

### 🧮 Key Queries & Logic
(Queries listed here — same as conversation above)

### 📈 KPIs Generated
| Metric | Formula | Description |
|---------|----------|--------------|
| Total Signups | COUNT(User_ID) | Users who signed up |
| Activated Users | SUM(Activated_Flag = TRUE) | Users activated |
| Converted Users | SUM(Converted_Flag = TRUE) | Users converted |
| Retention 30D Rate | AVG(Retained_30D = TRUE) | Retained 30+ days |
| Churn Rate | 1 – Retention Rate | Churn within 30 days |

### 🧹 Data Validation & Transition
20 → 300 rows in Power BI. 11 blank activation users found — realistic inactive users, retained for analysis.

### 🧭 Insights
1. 70% activated after signup.
2. Average rating >4.0 for top features.
3. Retention drop after 30 days.

### 🗂️ File Structure
/Freemium_Conversion_Funnel_SQL
├── SQL_Queries.sql
├── conversion_funnel.csv
├── feedback.csv
└── README.md

### 🧰 Tools
PostgreSQL, DBeaver, Excel/CSV, Power BI

### ✨ Author
**Created by:** Shreya (Coco)
**Linked Project:** [Power BI Dashboard](INSERT_POWERBI_REPO_LINK_HERE)
