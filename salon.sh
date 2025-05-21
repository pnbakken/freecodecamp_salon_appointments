#!/bin/bash
# Salon appointment booker

PSQL="psql --username=freecodecamp --dbname=salon -t -c "

TEST_RESULT=$($PSQL "SELECT * FROM SERVICES")
echo $TEST_RESULT

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then 
    echo "$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?\n"

  GET_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$GET_SERVICES" | while read ID BAR SERVICE
  do
    echo "$ID) $SERVICE" 
  done

  read SERVICE_CHOICE
  
  BOOK_APPOINTMENT $SERVICE_CHOICE


}

BOOK_APPOINTMENT() {

  echo -e "Booking appointment"
  echo -e "Chosen service: $1"

  CHECK_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $1")

  if [[ -z $CHECK_SERVICE ]]
  then 
    MAIN_MENU "That service does not exist"
  else
    # Do booking
    echo -e "\n"
  fi
}


MAIN_MENU