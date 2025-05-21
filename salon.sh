#!/bin/bash
# Salon appointment booker

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c "

TEST_RESULT=$($PSQL "SELECT * FROM SERVICES")
echo $TEST_RESULT