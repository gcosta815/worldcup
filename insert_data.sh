#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games");

file='games.csv'

while IFS=',' read -a line
do
  year=${line[0]}
  round=${line[1]}
  team1=${line[2]}
  team2=${line[3]}
  t1goal=${line[4]}
  t2goal=${line[5]}

  q1=$($PSQL "SELECT COUNT(team_id) FROM teams WHERE name='$team1'");
  q2=$($PSQL "SELECT COUNT(team_id) FROM teams WHERE name='$team2'");

  if [ $q1 == 0 ] && [ "$team1" != "winner" ]
  then
    echo $($PSQL "INSERT INTO teams (name) VALUES ('$team1')")
  fi

  if [ $q2 == 0 ] && [ "$team2" != "opponent" ]
  then
    echo $($PSQL "INSERT INTO teams (name) VALUES ('$team2')")
  fi

  if [ "$year" != "year" ]
  then
    t1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$team1'");
    t2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$team2'");
    echo $($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $t1_ID, $t2_ID, $t1goal, $t2goal)")
  fi

done < $file
