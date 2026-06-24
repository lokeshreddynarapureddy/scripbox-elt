import psycopg2
import time

def wait_for_db(host, dbname, user, password, retries=10):
    for i in range(retries):
        try:
            conn = psycopg2.connect(
                host=host,
                port=5432,
                dbname=dbname,
                user=user,
                password=password
            )
            print(f"Successfully connected to PostgreSQL on {host}!")
            return conn
        except psycopg2.OperationalError:
            print(f"Waiting for {host}... attempt {i+1}/{retries}")
            time.sleep(5)
    raise Exception(f"Could not connect to {host}")

def run_elt():
    print("Running ELT script...")

    src = wait_for_db(
        'source_postgres',
        'source_db',
        'postgres',
        'postgres'
    )
    dst = wait_for_db(
        'destination_postgres',
        'destination_db',
        'postgres',
        'postgres'
    )

    src_cursor = src.cursor()
    dst_cursor = dst.cursor()

    tables = [
        'users',
        'mutual_funds',
        'transactions',
        'portfolios',
        'fund_categories'
    ]

    for table in tables:
        print(f"Copying table: {table}")

        src_cursor.execute(f"SELECT * FROM {table}")
        rows = src_cursor.fetchall()
        col_names = [
            desc[0] for desc in src_cursor.description
        ]

        dst_cursor.execute(
            f"DROP TABLE IF EXISTS {table} CASCADE"
        )

        src_cursor.execute(f"""
            SELECT column_name, data_type,
                   character_maximum_length
            FROM information_schema.columns
            WHERE table_name = '{table}'
            ORDER BY ordinal_position
        """)
        columns = src_cursor.fetchall()

        col_defs = []
        for col in columns:
            if col[2]:
                col_defs.append(
                    f"{col[0]} VARCHAR({col[2]})"
                )
            else:
                col_defs.append(f"{col[0]} {col[1]}")

        dst_cursor.execute(
            f"CREATE TABLE {table} "
            f"({', '.join(col_defs)})"
        )

        if rows:
            placeholders = ', '.join(
                ['%s'] * len(col_names)
            )
            cols = ', '.join(col_names)
            dst_cursor.executemany(
                f"INSERT INTO {table} ({cols}) "
                f"VALUES ({placeholders})",
                rows
            )

        dst.commit()
        print(f"Table {table} copied successfully!")

    print("Ending ELT Script..")
    src_cursor.close()
    dst_cursor.close()
    src.close()
    dst.close()

if __name__ == "__main__":
    print("Starting ELT pipeline...")
    run_elt()
    print("ELT Script completed successfully!")