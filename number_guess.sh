#!/bin/bash

# Database connection variable
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt for username
echo "Enter your username:"
read USERNAME

# Check if the user exists
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]; then
    # If the user doesn't exist, insert them into the database
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
    # If the user exists, greet them and show statistics
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random number between 1 and 1000
RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))

# Prompt for the guessing game
echo "Guess the secret number between 1 and 1000:"

NUMBER_OF_GUESSES=0
while true; do
    read GUESS
    ((NUMBER_OF_GUESSES++))

    # Check if the guess is an integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        ((NUMBER_OF_GUESSES--))  # Don't count invalid guesses
        continue
    fi

    # Compare guess to the random number
    if [[ $GUESS -lt $RANDOM_NUMBER ]]; then
        echo "It's higher than that, guess again:"
    elif [[ $GUESS -gt $RANDOM_NUMBER ]]; then
        echo "It's lower than that, guess again:"
    else
        # User guessed correctly
        echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
        break
    fi
done

# Record the game in the database
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
