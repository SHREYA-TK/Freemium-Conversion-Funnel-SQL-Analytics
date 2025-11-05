-- ============================================================
-- Freemium Conversion Funnel – SQL Analytics
-- Master query file (PostgreSQL)
-- ============================================================

/*
This file contains the logic used in the project.
It avoids destructive schema changes by computing flags in views/CTEs.
Run sections independently in DBeaver (PostgreSQL connection).
*/

-- ------------------------------------------------------------
-- 0) Quick Check
-- ------------------------------------------------------------
-- Preview base tables
SELECT * FROM conversion_funnel LIMIT 10;
SELECT * FROM feedback LIMIT 10;

-- Row counts
SELECT 'conversion_funnel' AS table_name, COUNT(*) AS rows FROM conversion_funnel
UNION ALL
SELECT 'feedback', COUNT(*) FROM feedback;


-- ------------------------------------------------------------
-- 1) Enriched view with computed flags (non-destructive)
--    If the table already has these columns, we still recompute
--    so the logic is explicit and reproducible.
-- ------------------------------------------------------------
DROP VIEW IF EXISTS conversion_funnel_enriched;

CREATE VIEW conversion_funnel_enriched AS
SELECT
    cf.user_id,
    cf.region,
    cf.signup_date,
    cf.first_event_date,
    cf.conversion_date,
    cf.last_event_date,
    cf.events_14d,
    cf.days_to_convert,
    cf.retention_days,

    -- Activated if any first_event_date or events within 14 days
    (CASE 
        WHEN cf.first_event_date IS NOT NULL OR COALESCE(cf.events_14d,0) > 0 
        THEN TRUE ELSE FALSE 
     END) AS activated_flag,

    -- Converted if we have a conversion_date
    (CASE 
        WHEN cf.conversion_date IS NOT NULL 
        THEN TRUE ELSE FALSE 
     END) AS converted_flag,

    -- Retained 30+ days
    (CASE 
        WHEN COALESCE(cf.retention_days,0) >= 30 
        THEN TRUE ELSE FALSE 
     END) AS retained_30d,

    -- Churned if NOT retained 30+ days
    (CASE 
        WHEN COALESCE(cf.retention_days,0) >= 30 THEN FALSE ELSE TRUE 
     END) AS churn_flag
FROM conversion_funnel cf;


-- ------------------------------------------------------------
-- 2) Core KPIs
-- ------------------------------------------------------------
-- 2.1 Total signups
SELECT COUNT(*) AS total_signups
FROM conversion_funnel_enriched;

-- 2.2 Activated users
SELECT COUNT(*) AS activated_users
FROM conversion_funnel_enriched
WHERE activated_flag = TRUE;

-- 2.3 Converted users
SELECT COUNT(*) AS converted_users
FROM conversion_funnel_enriched
WHERE converted_flag = TRUE;

-- 2.4 Retained 30+ days
SELECT COUNT(*) AS retained_30d_users
FROM conversion_funnel_enriched
WHERE retained_30d = TRUE;

-- 2.5 Churn rate (1 - retention among activated)
SELECT 
    1 - (
        SUM( (retained_30d)::int )::numeric 
        / NULLIF(SUM( (activated_flag)::int ), 0)
    ) AS churn_rate_after_30d
FROM conversion_funnel_enriched;


-- ------------------------------------------------------------
-- 3) Region-wise performance
-- ------------------------------------------------------------
SELECT 
    region,
    COUNT(*) AS total_users,
    SUM( (activated_flag)::int ) AS activated_users,
    SUM( (converted_flag)::int ) AS converted_users,
    ROUND( SUM( (activated_flag)::int )::numeric / NULLIF(COUNT(*),0), 3) AS activation_rate,
    ROUND( SUM( (converted_flag)::int )::numeric / NULLIF(COUNT(*),0), 3) AS conversion_rate_overall,
    ROUND( SUM( (converted_flag)::int )::numeric / NULLIF(SUM( (activated_flag)::int ),0), 3) AS conversion_rate_from_activated
FROM conversion_funnel_enriched
GROUP BY region
ORDER BY region;


-- ------------------------------------------------------------
-- 4) Activation drives conversion (lift)
-- ------------------------------------------------------------
WITH cohort AS (
    SELECT 
        activated_flag,
        COUNT(*) AS users,
        SUM( (converted_flag)::int ) AS converted
    FROM conversion_funnel_enriched
    GROUP BY activated_flag
)
SELECT 
    activated_flag,
    users,
    converted,
    ROUND(converted::numeric / NULLIF(users,0), 3) AS conversion_rate
FROM cohort
ORDER BY activated_flag DESC;


-- ------------------------------------------------------------
-- 5) Days to Convert distribution (for conversion speed chart)
--    Only consider users who actually converted (have days_to_convert)
-- ------------------------------------------------------------
SELECT 
    CASE 
        WHEN days_to_convert IS NULL THEN 'not_converted'
        WHEN days_to_convert BETWEEN 0 AND 3 THEN '0-3'
        WHEN days_to_convert BETWEEN 4 AND 7 THEN '4-7'
        WHEN days_to_convert BETWEEN 8 AND 14 THEN '8-14'
        WHEN days_to_convert BETWEEN 15 AND 30 THEN '15-30'
        ELSE '30+'
    END AS convert_band,
    COUNT(*) AS users
FROM conversion_funnel_enriched
WHERE converted_flag = TRUE
GROUP BY 1
ORDER BY 
    CASE convert_band
        WHEN '0-3' THEN 1
        WHEN '4-7' THEN 2
        WHEN '8-14' THEN 3
        WHEN '15-30' THEN 4
        WHEN '30+' THEN 5
        ELSE 6
    END;


-- ------------------------------------------------------------
-- 6) Feature ratings summary (for scatter + donut)
-- ------------------------------------------------------------
SELECT 
    f.feature_name,
    ROUND(AVG(f.rating), 2) AS avg_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM feedback f
GROUP BY f.feature_name
ORDER BY feedback_count DESC, avg_rating DESC;


-- ------------------------------------------------------------
-- 7) Join funnel + feedback (for user-level analysis)
-- ------------------------------------------------------------
SELECT 
    c.user_id,
    c.region,
    c.activated_flag,
    c.converted_flag,
    c.retained_30d,
    c.churn_flag,
    c.retention_days,
    c.days_to_convert,
    f.feature_name,
    f.rating,
    f.comment
FROM conversion_funnel_enriched c
LEFT JOIN feedback f
  ON c.user_id = f.user_id;


-- ------------------------------------------------------------
-- 8) (Optional) Export helpers
--    If you have server filesystem access, you can export with COPY.
--    In DBeaver, you likely used the Export wizard instead.
-- ------------------------------------------------------------
-- COPY (SELECT * FROM conversion_funnel_enriched) TO '/tmp/conversion_funnel.csv' WITH CSV HEADER;
-- COPY (SELECT feature_name, rating, comment FROM feedback) TO '/tmp/feedback.csv' WITH CSV HEADER;

-- End of file
