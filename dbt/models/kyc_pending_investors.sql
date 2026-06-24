SELECT
    u.user_id,
    u.name,
    u.email,
    u.phone,
    u.joining_date,
    u.kyc_status,
    SUM(p.invested_amount) AS total_invested,
    CASE
        WHEN SUM(p.invested_amount) > 50000
        THEN 'High Priority'
        WHEN SUM(p.invested_amount) > 20000
        THEN 'Medium Priority'
        ELSE 'Low Priority'
    END AS follow_up_priority
FROM users u
JOIN portfolios p ON u.user_id = p.user_id
WHERE u.kyc_status = 'Pending'
GROUP BY u.user_id, u.name,
         u.email, u.phone,
         u.joining_date, u.kyc_status
ORDER BY total_invested DESC









