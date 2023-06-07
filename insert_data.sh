#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Empty the games and teams tables in the database
echo $($PSQL "TRUNCATE TABLE games, teams")

# Read the games.csv file and insert team data into the teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert team data into the teams table

    # Get the winner's team name

      # Exclude the column names row
      if [[ $WINNER != "winner" ]]
        then
          # Check if the team name already exists in the teams table
          TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
            # If the team name is not found, insert it into the teams table
            if [[ -z $TEAM_NAME ]]
              then
              INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                # Print a message to indicate that the team was inserted
                if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $WINNER
                fi
            fi
      fi

    # Get the opponent's team name

      # Exclude the column names row
      if [[ $OPPONENT != "opponent" ]]
        then
          # Check if the team name already exists in the teams table
          TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            # If the team name is not found, insert it into the teams table
            if [[ -z $TEAM2_NAME ]]
              then
              INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                # Print a message to indicate that the team was inserted
                if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $OPPONENT
                fi
            fi
      fi

  # Insert game data into the games table

    # Exclude the column names row
    if [[ YEAR != "year" ]]
      then
        # Get the winner's team ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        # Get the opponent's team ID
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        # Insert a new row into the games table
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
          # Print a message to indicate that a new game was added
          if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
          fi
    fi
    
done
