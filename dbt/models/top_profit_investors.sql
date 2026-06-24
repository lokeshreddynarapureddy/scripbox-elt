
SELECT
    u.user_id,
    u.name,
    u.email,
    u.phone,
    u.kyc_status,
    SUM(p.invested_amount) AS total_invested,
    SUM(p.current_value) AS current_value,
    SUM(p.current_value) -
    SUM(p.invested_amount) AS total_profit,
    ROUND(
        ((SUM(p.current_value) -
          SUM(p.invested_amount)) /
        SUM(p.invested_amount)) * 100, 2
    ) AS profit_percentage,
    COUNT(p.fund_id) AS total_funds
FROM users u
JOIN portfolios p
ON u.user_id = p.user_id
GROUP BY
    u.user_id,
    u.name,
    u.email,
    u.phone,
    u.kyc_status
HAVING
    SUM(p.current_value) >
    SUM(p.invested_amount)
ORDER BY total_profit DESC
LIMIT 5





