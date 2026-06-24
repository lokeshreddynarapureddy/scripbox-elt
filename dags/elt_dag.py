from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.utils.email import send_email
from datetime import datetime, timedelta
import subprocess

def success_email(context):
    send_email(
        to=['lokeshreddynarapureddy3@gmail.com'],
        subject='Scripbox ELT Pipeline Succeeded!',
        html_content=f"""
        <h3>Pipeline ran successfully!</h3>
        <p>DAG: {context['dag'].dag_id}</p>
        <p>Run ID: {context['run_id']}</p>
        <p>Execution Date: {context['execution_date']}</p>
        """
    )

default_args = {
    'owner': 'Lokesh',
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': True,
    'email_on_retry': False,
    'email': ['lokeshreddynarapureddy3@gmail.com']
}

def run_elt():
    subprocess.run(['python', '/app/elt_script.py'], check=True)

with DAG(
    'scripbox_elt_pipeline',
    default_args=default_args,
    description='Scripbox ELT Pipeline with dbt and Airflow',
    schedule_interval='0 3 * * *',
    start_date=datetime(2026, 1, 1),
    catchup=False,
    on_success_callback=success_email   
) as dag:

    task_elt = PythonOperator(
        task_id='run_elt_script',
        python_callable=run_elt
    )

    task_dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='/home/airflow/.local/bin/dbt run --project-dir /dbt --profiles-dir /dbt'
    )

    task_dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='/home/airflow/.local/bin/dbt test --project-dir /dbt --profiles-dir /dbt'
    )

    task_elt >> task_dbt_run >> task_dbt_test