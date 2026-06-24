
SELECT
    u.user_id,
    u.name,
    u.email,
    u.kyc_status,
    SUM(p.invested_amount) AS total_invested,
    SUM(p.current_value) AS current_value,
    SUM(p.current_value) - 
    SUM(p.invested_amount) AS total_returns,
    CASE
        WHEN SUM(p.current_value) > 
             SUM(p.invested_amount) THEN 'Profit'
        ELSE 'Loss'
    END AS portfolio_status
FROM users u
JOIN portfolios p 
ON u.user_id = p.user_id
GROUP BY u.user_id, u.name, 
         u.email, u.kyc_status