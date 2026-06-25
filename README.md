# Scripbox ELT Pipeline

# Project Overview
Automated data pipeline for Scripbox investor data using Python, dbt, Airflow and Docker.

# Tech Stack
- Python
- PostgreSQL
- dbt
- Apache Airflow
- Docker

# Prerequisites
- Docker Desktop installed (download from docker.com)
- Git installed

# How to Run

1. Clone the repo :
   git clone https://github.com/lokeshreddynarapureddy/scripbox-elt.git
2. Go into the folder:
   cd scripbox-elt

3. Run Docker :
   docker-compose up -d(Wait 3-5 minutes)

4. Check all containers are running:
   docker ps

5. Check Airflow logs :
   docker logs scripbox-elt-airflow-1 -f

6. Open Airflow :
   http://localhost:8080
   Username: admin
   Password: admin

6. Trigger DAG :
   Click play button on scripbox_elt_pipeline

# Pipeline Flow
Source PostgreSQL → ELT Script → Destination PostgreSQL → dbt Models
