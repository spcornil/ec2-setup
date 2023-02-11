#!/bin/bash

### Run each time a new EC2 instance is spun up
### Installs python, spark, postgres, airflow, and required dependencies.

### Update the shell
sudo apt update

### Install pip
sudo apt install python3-pip

### install python3 + virtual env
sudo apt-get install python3.10-venv

### Install some basic python packages
pip install numpy
pip install pandas
pip install jupyter

### Apache Spark Install & Setup
sudo apt-get install default-jdk
pip install pyspark
pip install pyarrow
pip install py4j

### Install Amazon AWS Console & Boto3
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

pip install boto3

### Add bin to PATH
echo >> .bashrc
echo "### User-added Variables" >> .bashrc
echo "export PATH=\$PATH:~/.local/bin" >> .bashrc

### Airflow Install & Setup (https://airflow.apache.org/docs/apache-airflow/stable/start.html)
### Updated install from (https://robust-dinosaur-2ef.notion.site/Running-Airflow-on-a-small-AWS-EC2-Instance-8e2a42d2ce7946c3a3d753abc13f2e57)

# When installing airflow for the first time, airflow needs a sqlite instance
sudo apt install sqlite3

# Optional but this toolkit can prevent some common errors observed when running airflow
sudo apt-get install libpq-dev

# Will use python virtual env to install airflow
python3 -m venv venv
source venv/bin/activate

# Can now see that we are within a virtual env. Can deactivate with command below
#deactivate

# Set airflow home
mkdir airflow
#export AIRFLOW_HOME=~/airflow

# Install Airflow using the constraints file
AIRFLOW_VERSION=2.5.1
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Next step is to initialize airflow
airflow db init

# Now we will install postgres
sudo apt-get install postgresql postgresql-contrib

# Connect to db and create user & database so airflow can connect and store data in it
sudo -i -u postgres
psql

CREATE DATABASE airflow;
CREATE USER airflow WITH PASSWORD 'airflow';
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;

# ctrl-D twice to escape and logout of postgres
# navigate to airflow/ folder
# Specify connection to postgres with sed (replacing sqlite) within airflow.cfg file
sed -i 's#sqlite:////home/ubuntu/airflow/airflow.db#postgresql+psycopg2://airflow:airflow@localhost/airflow#g' airflow.cfg

# Now we want to change the executor so we can execute multiple tasks at the same time.
# With local we can execute as many tasks as we want as long as we have enough resources.
sed -i 's#SequentialExecutor#LocalExecutor#g' airflow.cfg

# Now initialize airflow again (this time will use postgres)
airflow db init

# Create users
airflow users create -u airflow -f airflow -l airflow -r Admin -e airflow@gmail.com

# Will need to enter a password at some point before continuing. Just use 'airflow'
# Navigate to EC2 console --> security --> security group
# Edit inbound rules --> add rule: Custom TCP, Port 8080, optional: Description airflow
# Save. Now we can access web ui.

# Now ready to run airflow. & to run in background. May need to open up another terminal (in venv) to run scheduler separately.
airflow webserver &
airflow scheduler
