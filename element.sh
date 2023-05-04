#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no inputted argument 
if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else

  # if $1 is a number like 1 or 2
  if [[ $1 =~ ^[0-9]+$ ]] 
  then
    # get the element_info using atomic_number
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  # if $1 is a text like He or Helium
  else
    # get the element_info using name or symbol
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi

  # if no data is fetched from the database using $1
  if [[ -z $ELEMENT_INFO ]]
  then
    # print error 
    echo "I could not find that element in the database."
  else
    # get the designated variable needed
    echo "$ELEMENT_INFO" | while  IFS="|" read  NAME SYMBOL ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      # print the information
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
