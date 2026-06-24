SELECT
    u.user_id,
    u.name,
    u.email,
    u.kyc_status,
    SUM(p.invested_amount) AS total_invested,
    SUM(p.current_value) AS current_value,
    SUM(p.current_value) - SUM(p.invested_amount) AS total_returns,
    ROUND(
        ((SUM(p.current_value) - SUM(p.invested_amount)) /
        SUM(p.invested_amount)) * 100, 2
    ) AS returns_percentage,
    CASE
        WHEN SUM(p.current_value) > SUM(p.invested_amount)
        THEN 'Profit'
        ELSE 'Loss'
    END AS portfolio_status
FROM users u
JOIN portfolios p ON u.user_id = p.user_id
GROUP BY u.user_id, u.name, u.email, u.kyc_status
ORDER BY total_invested DESC
LIMIT 10





-- 
 
