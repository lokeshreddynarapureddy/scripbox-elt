SELECT
    f.fund_id,
    f.fund_name,
    f.fund_type,
    f.risk_level,
    f.nav,
    f.returns_1yr,
    f.returns_3yr,
    fc.category,
    CASE
        WHEN f.returns_3yr >= 15 THEN 'Excellent'
        WHEN f.returns_3yr >= 10 THEN 'Good'
        WHEN f.returns_3yr >= 5  THEN 'Average'
        ELSE 'Poor'
    END AS performance_category
FROM mutual_funds f
JOIN fund_categories fc
ON f.fund_id = fc.fund_id
WHERE f.fund_name LIKE '%ICICI Fund %'
LIMIT 1




-- 


