# Pokemon SQL init project

## Guide

1. Make sure to have docker engine running
2. at the repository level run docker-compose up -d
3. You can then connect to the database using:

Host: localhost
Port: 5432
Database: pokemon_db
Username: pokemon_user
Password: pokemon123

4. Create the schemas by running the init.sql 

5. Run the script python import.py that will import the data from the excel to the tables: python .\import.py

6. Enjoy your pokemon db by running the example sql provided



