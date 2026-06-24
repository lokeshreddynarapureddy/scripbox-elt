
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    joining_date DATE,
    kyc_status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS mutual_funds (
    fund_id SERIAL PRIMARY KEY,
    fund_name VARCHAR(100),
    fund_type VARCHAR(50),
    risk_level VARCHAR(20),
    nav DECIMAL(10,2),
    returns_1yr DECIMAL(5,2),
    returns_3yr DECIMAL(5,2)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT,
    fund_id INT,
    amount DECIMAL(10,2),
    transaction_type VARCHAR(10),
    transaction_date DATE
);

CREATE TABLE IF NOT EXISTS portfolios (
    portfolio_id SERIAL PRIMARY KEY,
    user_id INT,
    fund_id INT,
    units DECIMAL(10,4),
    invested_amount DECIMAL(10,2),
    current_value DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS fund_categories (
    category_id SERIAL PRIMARY KEY,
    fund_id INT,
    category VARCHAR(50)
);


INSERT INTO users (name, email, phone, joining_date, kyc_status)
SELECT
    CASE (i % 20)
        WHEN 0 THEN 'Rahul Kumar ' || i
        WHEN 1 THEN 'Priya Sharma ' || i
        WHEN 2 THEN 'Lokesh Reddy ' || i
        WHEN 3 THEN 'Anjali Singh ' || i
        WHEN 4 THEN 'Vikram Patel ' || i
        WHEN 5 THEN 'Sneha Nair ' || i
        WHEN 6 THEN 'Arjun Mehta ' || i
        WHEN 7 THEN 'Pooja Iyer ' || i
        WHEN 8 THEN 'Rajesh Gupta ' || i
        WHEN 9 THEN 'Deepika Rao ' || i
        WHEN 10 THEN 'Suresh Joshi ' || i
        WHEN 11 THEN 'Kavitha Pillai ' || i
        WHEN 12 THEN 'Arun Verma ' || i
        WHEN 13 THEN 'Meena Nair ' || i
        WHEN 14 THEN 'Kiran Kumar ' || i
        WHEN 15 THEN 'Divya Menon ' || i
        WHEN 16 THEN 'Sanjay Shah ' || i
        WHEN 17 THEN 'Rekha Jain ' || i
        WHEN 18 THEN 'Amit Tiwari ' || i
        ELSE 'Sunita Bose ' || i
    END,
    'user' || i || '@gmail.com',
    '98765' || LPAD(i::text, 5, '0'),
    CURRENT_DATE - (random() * 365 * 3)::int,
    CASE
        WHEN random() > 0.3 THEN 'Verified'
        ELSE 'Pending'
    END
FROM generate_series(1, 1000) AS i;


INSERT INTO mutual_funds (fund_name, fund_type, risk_level, nav, returns_1yr, returns_3yr)
SELECT
    CASE (i % 10)
        WHEN 0 THEN 'SBI Fund ' || i
        WHEN 1 THEN 'HDFC Fund ' || i
        WHEN 2 THEN 'ICICI Fund ' || i
        WHEN 3 THEN 'Axis Fund ' || i
        WHEN 4 THEN 'Kotak Fund ' || i
        WHEN 5 THEN 'Nippon Fund ' || i
        WHEN 6 THEN 'Mirae Fund ' || i
        WHEN 7 THEN 'DSP Fund ' || i
        WHEN 8 THEN 'Tata Fund ' || i
        ELSE 'Franklin Fund ' || i
    END, 
    CASE (i % 3)
        WHEN 0 THEN 'Equity'
        WHEN 1 THEN 'Debt'
        ELSE 'Hybrid'
    END,
    CASE (i % 3)
        WHEN 0 THEN 'High'
        WHEN 1 THEN 'Low'
        ELSE 'Medium'
    END,
    ROUND((random() * 200 + 10)::numeric, 2),
    ROUND((random() * 20 - 2)::numeric, 2),
    ROUND((random() * 25 - 2)::numeric, 2)
FROM generate_series(1, 500) AS i;


INSERT INTO fund_categories (fund_id, category)
SELECT
    i,
    CASE (i % 5)
        WHEN 0 THEN 'Large Cap'
        WHEN 1 THEN 'Mid Cap'
        WHEN 2 THEN 'Small Cap'
        WHEN 3 THEN 'Short Duration'
        ELSE 'Aggressive Hybrid'
    END
FROM generate_series(1, 500) AS i;


INSERT INTO portfolios (user_id, fund_id, units, invested_amount, current_value)
SELECT
    u.user_id,
    (random() * 499 + 1)::int,
    ROUND((random() * 500 + 10)::numeric, 4),
    ROUND((random() * 100000 + 5000)::numeric, 2),
    ROUND((random() * 120000 + 5000)::numeric, 2)
FROM users u,
     generate_series(1, 2) AS s;


INSERT INTO transactions (user_id, fund_id, amount, transaction_type, transaction_date)
SELECT
    u.user_id,
    (random() * 499 + 1)::int,
    ROUND((random() * 50000 + 1000)::numeric, 2),
    CASE WHEN random() > 0.3 THEN 'BUY' ELSE 'SELL' END,
    CURRENT_DATE - (random() * 365)::int
FROM users u,
     generate_series(1, 3) AS s;






