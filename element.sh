#!/bin/bash

PSQL="psql -X -U freecodecamp -d periodic_table --tuples-only -c"

#argument
ELEMENT=$1

UNAVAILABLE_ELEMENT() {
  echo "I could not find that element in the database."
}

NO_ARGUMENT() {
  echo "Please provide an element as an argument."
}

if [[ $ELEMENT ]]
then
  # if argument is not a number
  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name LIKE '$ELEMENT%' ORDER BY atomic_number LIMIT 1")
    # echo "$ELEMENTS"
  else
    # if argument is a number
    ELEMENTS=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$ELEMENT")
    # echo "$ELEMENTS"

  fi

  # if elements is not available
  if [[ -z $ELEMENTS ]]
  then
    UNAVAILABLE_ELEMENT
  else
    echo $ELEMENTS | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MPC BAR BPC
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi

  else
    NO_ARGUMENT
    
fi

