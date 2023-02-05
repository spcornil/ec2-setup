#!/bin/bash

### Update the shell
sudo apt update

### install python3 & pip
sudo apt-get install python3.7
sudo apt install python3-pip

### Install some basic python packages
pip install numpy
pip install pandas
pip install jupyter

### Add bin to PATH
echo >> .bashrc
echo "### User-added Variables" >> .bashrc
echo "export PATH=\$PATH:~/.local/bin" >> .bashrc

### Install postgres
sudo apt install postgresql postgresql-contrib

### Connect to postgres
#sudo -u postgres psql

### Apache Spark Install & Setup
pip install pyspark
pip install pyarrow
pip install py4j

sudo apt-get install default-jdk


### Airflow Install & Setup (pulled from https://airflow.apache.org/docs/apache-airflow/stable/start.html)

# Airflow needs a home. `~/airflow` is the default, but you can put it
# somewhere else if you prefer (optional)
export AIRFLOW_HOME=~/airflow

# Install Airflow using the constraints file
AIRFLOW_VERSION=2.5.1
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
# For example: 3.7
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
# For example: https://raw.githubusercontent.com/apache/airflow/constraints-2.5.1/constraints-3.7.txt
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# The Standalone command will initialise the database, make a user,
# and start all components for you.
#airflow standalone

# Visit localhost:8080 in the browser and use the admin account details
# shown on the terminal to login.
# Enable the example_bash_operator dag in the home page
