import psycopg2
import random
from datetime import date, timedelta
import time

def connect_db(retries=10):
    for i in range(retries):
        try:
            conn = psycopg2.connect(
                host='source_postgres',
                port=5432,
                dbname='source_db',
                user='postgres',
                password='postgres'
            )
            print("Connected to source_postgres!")
            return conn
        except psycopg2.OperationalError:
            print(f"Waiting... attempt {i+1}/{retries}")
            time.sleep(5)
    raise Exception("Could not connect")

conn = connect_db()
cursor = conn.cursor()

# Indian first and last names
first_names = [
    'Lokesh', 'Priya', 'Rahul', 'Sneha', 'Amit',
    'Pooja', 'Vikram', 'Neha', 'Suresh', 'Kavya',
    'Arjun', 'Divya', 'Kiran', 'Anjali', 'Rajesh',
    'Meena', 'Sanjay', 'Lakshmi', 'Vijay', 'Sunita',
    'Arun', 'Deepa', 'Manoj', 'Rekha', 'Ganesh',
    'Uma', 'Prakash', 'Geeta', 'Ramesh', 'Sita',
    'Ravi', 'Padma', 'Krishna', 'Savitha', 'Mohan',
    'Radha', 'Harish', 'Suma', 'Naveen', 'Bindhu',
    'Sunil', 'Asha', 'Girish', 'Hema', 'Praveen',
    'Sudha', 'Vinod', 'Usha', 'Ashok', 'Nirmala'
]

last_names = [
    'Reddy', 'Sharma', 'Kumar', 'Singh', 'Patel',
    'Gupta', 'Verma', 'Shah', 'Mehta', 'Joshi',
    'Nair', 'Pillai', 'Iyer', 'Rao', 'Mishra',
    'Pandey', 'Chauhan', 'Malhotra', 'Kapoor', 'Bose',
    'Chatterjee', 'Mukherjee', 'Banerjee', 'Das', 'Sen',
    'Tiwari', 'Dubey', 'Shukla', 'Tripathi', 'Yadav',
    'Hegde', 'Kamath', 'Shetty', 'Naik', 'Gowda',
    'Patil', 'Desai', 'Jain', 'Agarwal', 'Khanna'
]

kyc_statuses = [
    'Verified', 'Verified', 'Verified',
    'Verified', 'Pending'
]


print("Generating 5000 users...")
users = []
for i in range(1, 5001):
    first = random.choice(first_names)
    last = random.choice(last_names)
    name = f"{first} {last}"
    email = f"{first.lower()}.{last.lower()}{i}@gmail.com"
    phone = f"9{random.randint(100000000, 999999999)}"
    joining_date = date(2019, 1, 1) + timedelta(
        days=random.randint(0, 2000)
    )
    kyc = random.choice(kyc_statuses)
    users.append((i, name, email, phone, joining_date, kyc))

cursor.executemany(
    "INSERT INTO users VALUES (%s,%s,%s,%s,%s,%s)",
    users
)
conn.commit()
print("5000 users created!")

# Generate 50000+ transactions
print("Generating transactions...")
transactions = []
tid = 1
amounts = [
    500, 1000, 2000, 3000, 5000,
    10000, 15000, 25000, 50000, 100000
]
for user_id in range(1, 5001):
    num_transactions = random.randint(5, 20)
    for _ in range(num_transactions):
        fund_id = random.randint(1, 50)
        amount = random.choice(amounts)
        t_type = random.choice(
            ['BUY', 'BUY', 'BUY', 'BUY', 'SELL']
        )
        t_date = date(2020, 1, 1) + timedelta(
            days=random.randint(0, 1500)
        )
        transactions.append((
            tid, user_id, fund_id,
            amount, t_type, t_date
        ))
        tid += 1

cursor.executemany(
    "INSERT INTO transactions VALUES (%s,%s,%s,%s,%s,%s)",
    transactions
)
conn.commit()
print(f"{len(transactions)} transactions created!")


print("Generating portfolios...")
portfolios = []
pid = 1
for user_id in range(1, 5001):
    num_funds = random.randint(1, 8)
    fund_ids = random.sample(range(1, 51), num_funds)
    for fund_id in fund_ids:
        units = round(random.uniform(10, 1000), 2)
        invested = round(random.uniform(500, 500000), 2)
        growth = random.uniform(0.80, 1.50)
        current = round(invested * growth, 2)
        portfolios.append((
            pid, user_id, fund_id,
            units, invested, current
        ))
        pid += 1

cursor.executemany(
    "INSERT INTO portfolios VALUES (%s,%s,%s,%s,%s,%s)",
    portfolios
)
conn.commit()
print(f"{len(portfolios)} portfolio records created!")

cursor.close()
conn.close()
print("Data generation complete!")
print(f"Total: 5000 users, {len(transactions)} transactions, {len(portfolios)} portfolios")