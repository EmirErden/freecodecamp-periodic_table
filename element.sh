#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^-?[0-9]+$ ]]
then
  CHECK_DATABASE=$($PSQL "Select * From elements Where atomic_number=$1")
  if [[ -z $CHECK_DATABASE ]]
  then
    echo I could not find that element in the database.
  else
    echo "$($PSQL "Select * From properties Where atomic_number = '$1'")" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING TYPE_ID
    do
    TYPE=$($PSQL "Select type From types Where type_id=$TYPE_ID")
    NAME=$($PSQL "Select name From elements Where atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "Select symbol From elements Where atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
elif [[ ${#1} -eq 1 && $1 =~ ^[a-zA-Z]$ ]]
then
  CHECK_DATABASE=$($PSQL "Select * From elements Where symbol='$1'")
  if [[ -z $CHECK_DATABASE ]]
  then
    echo I could not find that element in the database.
  else
    echo "$($PSQL "Select * From elements Where symbol='$1'")" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      echo "$($PSQL "Select * From Properties Where atomic_number=$ATOMIC_NUMBER")" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING TYPE_ID
      do
        TYPE=$($PSQL "Select type From types Where type_id=$TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done 
    done
  fi
elif [[ $1 =~ ^[a-zA-Z\ ]+$ ]]
then 
  CHECK_DATABASE=$($PSQL "Select * From elements Where name='$1'")
  if [[ -z $CHECK_DATABASE ]]
  then
    echo I could not find that element in the database.
  else
    echo "$($PSQL "Select * From elements Where name='$1'")" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      echo "$($PSQL "Select * From Properties Where atomic_number=$ATOMIC_NUMBER")" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING TYPE_ID
      do
        TYPE=$($PSQL "Select type From types Where type_id=$TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done 
    done
  fi
else
echo I could not find that element in the database.
fi
