#!/bin/bash
PSQL="psql -U freecodecamp -d salon --no-align --tuples-only -c"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nWelcome to the Pelon Salon! What can we help you with today?\n"
  echo "$($PSQL "SELECT * FROM services")" | while IFS="|" read SERVICE_ID SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  if [[ -z $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") ]]
  then
    MAIN_MENU "Please select a valid option."
  else
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    GET_INFO
  fi
  }
GET_INFO() {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    ENTER_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
  SCHEDULE_APPOINTMENT
  }
SCHEDULE_APPOINTMENT() {
  echo -e "\nWhat time will you be coming in?"
  read SERVICE_TIME
  ENTER_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  }

MAIN_MENU
