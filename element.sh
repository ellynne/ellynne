#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

LOOKUP=$1

MAIN_MENU() {
  if [[ -z $LOOKUP ]]
  then
    echo -e "Please provide an element as an argument."

  else
    #lookup element based on numeric entry
    if [[ $LOOKUP =~ ^[0-9]+$ ]]
    then
    ATOMIC_NUMBER_SELECTED=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE (atomic_number=$LOOKUP)")
    else
    # do text lookup
    ATOMIC_NUMBER_SELECTED=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE (symbol = '$LOOKUP' OR name = '$LOOKUP')")
    fi

    # check if empty
      if [[ -z $ATOMIC_NUMBER_SELECTED ]]
      then
      echo "I could not find that element in the database."
     else
    # else print stuff
        echo "$ATOMIC_NUMBER_SELECTED" | while read ENTRY BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
          done
        
    fi
  fi

}

MAIN_MENU
