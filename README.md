# Freemium Conversion Funnel — SQL Analytics

A complete SQL-driven analysis of a freemium product’s user journey.
This project models the conversion funnel (Signup → Activation → Conversion → 30-Day Retention),
calculates performance KPIs, and uncovers insights that later power the companion Power BI dashboard.

**Companion Power BI Project:**  
https://github.com/SHREYA-TK/Freemium-Conversion-Funnel--Power-BI-Dashboard

**Note:**  
Feedback insights are **not** included in this SQL analysis because the SQL dataset does not contain rating or feedback fields.
Those insights are explored only in the Power BI project, which uses an additional feedback table imported directly into Power BI.

---

## 1. Project Overview

Freemium products rely on their ability to move users smoothly from initial signup to long-term retention.
This SQL project focuses on measuring funnel health, identifying drop-offs, comparing regional performance,
and producing a clean analytical dataset for BI tools.

SQL acts as the analytical truth layer; Power BI builds on top of these outputs to tell the visual story.

---

## 2. Funnel Diagram

![Freemium funnel overview](funnel.png)

---

## 3. Key KPIs (from SQL)

| Metric | Value |
| --- | ---: |
| Total signups | 289 |
| Activated users | 175 |
| Converted users | 59 |
| Retained 30 days | 2 |
| Activation rate | 60.6% |
| Conversion rate (activated → converted) | 33.7% |
| Overall conversion | 20.4% |
| 30-day retention | 0.69% |
| Churn | 99.7% |
| Avg days to convert | 7.90 |

---

## 4. Funnel Performance Breakdown

### 4.1 Signups → Activation (289 → 175)

A strong number of users sign up, but almost 40% never activate.
This indicates friction in onboarding or unclear early value.

### 4.2 Activation → Conversion (175 → 59)

Only one-third of activated users convert.
This suggests premium value is not being communicated strongly enough during the free experience.

### 4.3 Conversion → 30-Day Retention (59 → 2)

The steepest drop occurs after conversion.
Even paying users do not remain engaged long-term, highlighting weak habit formation.

---

## 5. SQL Analysis

### 5.1 Funnel Metrics

```sql
SELECT
    COUNT(*) AS signups,
    COUNT(CASE WHEN activated_flag = 1 THEN 1 END) AS activated,
    COUNT(CASE WHEN converted_flag = 1 THEN 1 END) AS converted,
    COUNT(CASE WHEN retained_30d_flag = 1 THEN 1 END) AS retained_30d
FROM conversion_funnel_enriched;
```

---

### 5.2 Region-wise Funnel Performance (SQL)

```sql
SELECT
    region,
    COUNT(*) AS signups,
    COUNT(CASE WHEN activated_flag = 1 THEN 1 END) AS activated,
    COUNT(CASE WHEN converted_flag = 1 THEN 1 END) AS converted
FROM conversion_funnel_enriched
GROUP BY region
ORDER BY signups DESC;
```

---

## 6. Region Insights

**United Kingdom**  
Largest user base with strong acquisition but clear drop-offs later in the funnel.

**Germany**  
Lower volume but higher conversion efficiency, indicating strong product–market fit.

**Spain**  
Weak activation and conversion, suggesting localisation or onboarding issues.

---

## 7. Recommendations

- Simplify onboarding.
- Highlight premium value earlier.
- Build habit-forming features.
- Investigate Spain for UX/localisation gaps.
- Scale acquisition in Germany.

---

## 8. Conclusion

This SQL analysis builds a clear, measurable view of a freemium product’s funnel.
While acquisition is strong, meaningful challenges exist in activation, conversion, and long-term retention.
Regional analysis highlights where the product performs well and where targeted improvements are needed.

These SQL-driven insights form the foundation for the companion Power BI dashboard,
where they are visualised and enriched with additional feedback data.

---

## 9. What I Learned

- Designing funnel KPIs in SQL.
- Analysing user behaviour stage by stage.
- Applying regional segmentation.
- Preparing SQL outputs for BI tools.

---

## 10. Repository Structure

```text
.
├── README.md
├── sql/
│   └── SQL_Queries.sql
├── funnel.png
└── assets/
```

---

## 11. How to Run

1. Load the dataset into PostgreSQL.
2. Query the `conversion_funnel_enriched` table.
3. Run the SQL analysis queries.
4. Export results to Power BI.
