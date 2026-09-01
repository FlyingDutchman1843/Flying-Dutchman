#!/bin/bash
PSQL="psql -U freecodecamp -d number_guess --no-align --tuples-only -c"
NUMBER=$(( $RANDOM % 1000 + 1 ))
echo Enter your username:
read USERNAME
read GAMES_PLAYED BEST_GAME <<< $(echo $($PSQL "SELECT games_played, best_game FROM players WHERE username='$USERNAME'") | sed 's/|/ /g')
if [[ -z $GAMES_PLAYED ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
  ADD_NEW_PLAYER=$($PSQL "INSERT INTO players(username, games_played) VALUES('$USERNAME', 0)")
else
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi
echo Guess the secret number between 1 and 1000:
GUESSES=0
GUESS(){
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
    GUESS
  else
    (( GUESSES++ ))
    if (( GUESS == NUMBER ))
    then
      echo You guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!
    elif (( GUESS < NUMBER ))
    then
      echo "It's higher than that, guess again:"
      GUESS
    else
      echo "It's lower than that, guess again:"
      GUESS
    fi
  fi
  }
GUESS
UPDATE_GAMES_PLAYED=$($PSQL "UPDATE players SET games_played=$(( GAMES_PLAYED + 1 )) WHERE username='$USERNAME'")
if [[ -z $BEST_GAME || $GUESSES -lt $BEST_GAME ]]
then
  UPDATE_BEST_GAME=$($PSQL "UPDATE players SET best_game=$GUESSES WHERE username='$USERNAME'")
fi