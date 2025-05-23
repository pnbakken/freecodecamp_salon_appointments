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

  read SERVICE_ID_SELECTED
  
  BOOK_APPOINTMENT $SERVICE_ID_SELECTED


}

BOOK_APPOINTMENT() {

  echo -e "Booking appointment"
  echo -e "Chosen service: $1"

  SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $1")

  if [[ -z $SERVICE_ID_SELECTED ]]
  then 
    MAIN_MENU "That service does not exist"
  else
    # Do booking
    echo -e "\nPlease enter your phone number"
    read CUSTOMER_PHONE

    GET_CUSTOMER_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if [[ -z $GET_CUSTOMER_RESULT ]]
    then
      echo -e "\nPlease enter your name"
      read CUSTOMER_NAME

      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      echo $INSERT_CUSTOMER_RESULT

      if [[ $INSERT_CUSTOMER_RESULT == "INSERT 0 1" ]]
      then
        GET_CUSTOMER_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        echo $GET_CUSTOMER_RESULT
      fi

    fi

    echo -e "\nPlease enter your desired appointment time"
    read SERVICE_TIME

    BOOK_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $GET_CUSTOMER_RESULT, '$SERVICE_TIME') RETURNING appointment_id")
    echo $BOOK_APPOINTMENT_RESULT | while read APPOINTMENT_ID SPACE ACTION SPACE ERROR SPACE AMOUNT
    do
      echo -e "\nYour appointment: $APPOINTMENT_ID"

      COMPLETED_RESULT=$($PSQL "SELECT a.time, s.name AS sName, c.name AS cName FROM appointments a INNER JOIN services s ON a.service_id = s.service_id INNER JOIN customers c on a.customer_id = c.customer_id WHERE a.appointment_id = $APPOINTMENT_ID")
      echo -e "$COMPLETED_RESULT" | while read APPOINTMENT BAR SERVICE_NAME BAR CUST_NAME
      do
        echo -e "\nI have put you down for a $SERVICE_NAME at $APPOINTMENT, $CUST_NAME."
      done
    done
   
  fi
}


MAIN_MENU