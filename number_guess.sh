#!/bin/bash
# Number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate randomw number btw 1 and 1000
NUMBER=$(( RANDOM % 1000 + 1 ))

# ask for name
echo "Enter your username:"
read USERNAME

# check if name in database
PLAYER_INFO=$($PSQL "SELECT player_id, count(*) AS games_played, min(guesses) AS best_game FROM games FULL JOIN players USING(player_id) WHERE username = '$USERNAME' GROUP BY player_id")

  # check if player exists
 if [[ -z $PLAYER_INFO ]]
 then
  # if not insert new player record
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_PLAYER=$($PSQL "INSERT INTO players(username) VALUES('$USERNAME')")

else
  # if yes, greet returning user with welcome message
          echo "$PLAYER_INFO" | while read PLAYER_ID BAR GAMES_PLAYED BAR BEST_GAME
          do
            echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
          done
  echo $PLAYER_INFO
  echo $GAMES_PLAYED
fi
  
# ask to guess a number, read guess as input, set guess count = 1
# guess_menu
echo -e "\nGuess the secret number between 1 and 1000:"

GUESS_MENU() {
read GUESS
# check if guess is an integer
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
    SAVE_EXIT
  fi
fi
}

# end step 1 print correct and guess_count
# end step 2 add results to games database
SAVE_EXIT() {
# tests
echo $NUMBER
echo $USERNAME
}

GUESS_MENU
