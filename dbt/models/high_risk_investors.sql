SELECT
    u.user_id,
    u.name,
    u.email,
    f.risk_level,
    COUNT(p.fund_id) AS high_risk_funds,
    SUM(p.invested_amount) AS total_invested,
    SUM(p.current_value) AS current_value,
    SUM(p.current_value) -
    SUM(p.invested_amount) AS total_returns,
    CASE
        WHEN SUM(p.current_value) >
             SUM(p.invested_amount)
        THEN 'Profit'
        ELSE 'Loss'
    END AS status
FROM users u
JOIN portfolios p ON u.user_id = p.user_id
JOIN mutual_funds f ON p.fund_id = f.fund_id
WHERE f.risk_level = 'High'
GROUP BY u.user_id, u.name,
         u.email, f.risk_level
ORDER BY total_invested DESC
LIMIT 10








