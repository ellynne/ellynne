#!/bin/bash
# Number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate randomw number btw 1 and 1000
NUMBER=$(( RANDOM % 1000 + 1 ))

# ask for name
echo "Enter your username:"
read USERNAME

# check if name in database
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username = '$USERNAME'")

  # check if player exists
 if [[ -z $PLAYER_ID ]]
 then
  # if not insert new player record
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_PLAYER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username = '$USERNAME'")

else
  # if yes, greet returning user with welcome message
    GAMES_PLAYED=$($PSQL "SELECT count(*) FROM games LEFT JOIN players USING(player_id) WHERE username = '$USERNAME'")
    BEST_GAME=$($PSQL "SELECT min(guesses) FROM games LEFT JOIN players USING(player_id) WHERE username = '$USERNAME'")

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

fi
  
# ask to guess a number, read guess as input, set guess count = 1
# guess_menu
echo -e "\nGuess the secret number between 1 and 1000:"
GUESS_COUNT=0

GUESS_MENU() {
read GUESS
((GUESS_COUNT++))
# check if guess is an integer
if ! [[ "$GUESS" =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:"
        GUESS_MENU
fi
# if lower, print message, ask for new guess and set guess_count + 1
if (( GUESS < NUMBER ))
then
  echo "It's higher than that, guess again:"
  GUESS_MENU
else
  # if higher, print message , ask for new guess and set guess_count + 1
  if (( GUESS > NUMBER ))
  then
    echo "It's lower than that, guess again:"
    GUESS_MENU
  # if correct, go to end steps, return 
  else 
    echo "You guessed it in $GUESS_COUNT tries. The secret number was $NUMBER. Nice job!"
    SAVE_EXIT
  fi
fi
}

# end step 1 print correct and guess_count
# end step 2 add results to games database
SAVE_EXIT() {
  
  GAME_INFO=$($PSQL "INSERT INTO games(player_id, guesses) VALUES($PLAYER_ID, $GUESS_COUNT)")
}

GUESS_MENU

