#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointments ~~~~~\n"

MAIN_MENU() {
  echo -e "\nHere are the services we offer:"

  #formatted list of services
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  # go to book appointment  
  BOOKING_MENU
}

BOOKING_MENU() {
  #prompt for service type
  echo -e "\nWhat service number would you like to book?"
  read SERVICE_ID_SELECTED

  # check if service exists and get name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
  #if not return to main menu
  MAIN_MENU 
  #else go to customer info
  else
  CUSTOMER_MENU
  fi
}

CUSTOMER_MENU() {
  #prompt for phone number
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  # get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # check if customer exists
 if [[ -z $CUSTOMER_NAME ]]
 then
  # if not get name
  echo -e "\nWelcome, new customer! What is your name?"
  read CUSTOMER_NAME

  # insert new customer record
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi
  # get customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # go to appontment time menu
  APPOINTMENT_MENU

}

APPOINTMENT_MENU() {
  # get time
  echo -e "\nWhat time would you like to come in?"
  read SERVICE_TIME

  # insert appointment record
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")

  # message
  echo $SERVICE_NAME
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME) at $(echo $SERVICE_TIME), $(echo $CUSTOMER_NAME)."
}

MAIN_MENU
