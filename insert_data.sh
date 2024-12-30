#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
CSV_FILE="games.csv"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $year == "year" ]]; then
    continue
  fi

  $PSQL "INSERT INTO teams (name) SELECT '$winner' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$winner');"

  $PSQL "INSERT INTO teams (name) SELECT '$opponent' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$opponent');"

  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';" | xargs)
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';" | xargs)

  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"

done < "$CSV_FILE"