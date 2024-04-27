import 'package:mysql_client/mysql_client.dart';

Future<int> endGame(
  MySQLConnection sql, {
  required team1Id,
  required team2Id,
  required team3Id,
  required team4Id,
  required team5Id,
  required team1Score,
  required team2Score,
  required team3Score,
  required team4Score,
  required team5Score,
  required masterId,
  required winner,
}) async {
  team1Score = int.parse(team1Score);
  team2Score = int.parse(team2Score);
  team3Score = int.parse(team3Score);
  team4Score = int.parse(team4Score);
  team5Score = int.parse(team5Score);

  int idInt;
  try {
    var resul = await sql.execute(
      "SELECT * FROM games",
    );
    String id = resul.rows.last.assoc()['id'] as String;
    idInt = int.parse(id);
  } catch (_) {
    idInt = 0;
  }

  var topTeam = team1Id;
  if (team1Score > team2Score &&
      team1Score > team3Score &&
      team1Score > team4Score &&
      team1Score > team5Score) {
    topTeam = team1Id;
  }
  if (team2Score > team1Score &&
      team2Score > team3Score &&
      team2Score > team4Score &&
      team2Score > team5Score) {
    topTeam = team1Id;
  }
  if (team3Score > team1Score &&
      team3Score > team2Score &&
      team3Score > team4Score &&
      team3Score > team5Score) {
    topTeam = team1Id;
  }
  if (team4Score > team1Score &&
      team4Score > team2Score &&
      team4Score > team3Score &&
      team4Score > team5Score) {
    topTeam = team1Id;
  }
  if (team5Score > team1Score &&
      team5Score > team2Score &&
      team5Score > team4Score &&
      team5Score > team3Score) {
    topTeam = team1Id;
  }
  int indexedInt;
  try {
    var gameIndexed = await sql.execute(
      "SELECT * FROM game_indexed",
    );
    String indexedId = gameIndexed.rows.last.assoc()['id'] as String;
    indexedInt = int.parse(indexedId);
  } catch (_) {
    indexedInt = 0;
  }
  for (int i = 0; i < 5; i++) {
    switch (i) {
      case 0:
        await sql.execute(
            'insert into game_indexed (id, team_id, game_id) values(${indexedInt + i + 1}, $team1Id, ${idInt + 1})');
        if (topTeam == team1Id) {
          await sql.execute(
              'update users set games=games+1, wins=wins+1 where id=$team1Id');
        } else  {
          await sql.execute('update users set games=games+1 where id=$team1Id');
        }
      case 1:
        await sql.execute(
            'insert into game_indexed (id, team_id, game_id) values(${indexedInt + i + 1}, $team2Id, ${idInt + 1})');
        if (topTeam == team2Id) {
          await sql.execute(
              'update users set games=games+1, wins=wins+1 where id=$team2Id');
        } else {
          await sql.execute('update users set games=games+1 where id=$team2Id');
        }
      case 2:
        if(team3Id != '-1') {
          await sql.execute(
              'insert into game_indexed (id, team_id, game_id) values(${indexedInt +
                  i + 1}, $team3Id, ${idInt + 1})');
          if (topTeam == team3Id && team3Id != '-1') {
            await sql.execute(
                'update users set games=games+1, wins=wins+1 where id=$team3Id');
          } else {
            await sql.execute(
                'update users set games=games+1 where id=$team3Id');
          }
        }
      case 3:
        if(team4Id != '-1') {
          await sql.execute(
              'insert into game_indexed (id, team_id, game_id) values(${indexedInt +
                  i + 1}, $team4Id, ${idInt + 1})');
          if (topTeam == team4Id && team4Id != '-1') {
            await sql.execute(
                'update users set games=games+1, wins=wins+1 where id=$team4Id');
          } else {
            await sql.execute(
                'update users set games=games+1 where id=$team4Id');
          }
        }
      case 4:
        if(team5Id != '-1') {
          await sql.execute(
              'insert into game_indexed (id, team_id, game_id) values(${indexedInt +
                  i + 1}, $team4Id, ${idInt + 1})');
          if (topTeam == team5Id && team5Id != '-1') {
            await sql.execute(
                'update users set games=games+1, wins=wins+1 where id=$team5Id');
          } else {
            await sql.execute(
                'update users set games=games+1 where id=$team5Id');
          }
        }
    }
  }
  await sql.execute(
      "insert into games (id, team1_id, team2_id,team3_id,team4_id,team5_id, team1_score, team2_score,team3_score,team4_score,team5_score, master_id, winner_id) values (${idInt + 1}, $team1Id,$team2Id,$team3Id,$team4Id,$team5Id,$team1Score,$team2Score,$team3Score,$team4Score,$team5Score,$masterId,$topTeam)");
  return idInt + 1;
}

Future<List> getTeamGames(MySQLConnection sql,id) async {
  List games = [];
 final response = await sql.execute("select * from game_indexed where team_id");
 for(var item in response.rows) {
   final gameRow = await sql.execute("select * from games where id = ${item.assoc()['game_id']}");
   var gameData = gameRow.rows.first.assoc();
   var team1Row = await sql.execute("select * from users where id = ${gameData['team1_id']}");
   var team2Row = await sql.execute("select * from users where id = ${gameData['team1_id']}");
   var team3;
   try{
     var team3Row = await sql.execute("select * from users where id = ${gameData['team1_id']}");
     team3 = team3Row.rows.first.assoc()['name'];
   } catch (e){
     team3 = 'Не играла';
   }
   games.add({
     'id':  gameData['id'],
     'date_start': gameData['date_start'],
     'winner_id': gameData['winner_id'],
     'team1_id': gameData['team1_id'],
     'team2_id': gameData['team1_id'],
     'team3_id': gameData['team1_id'],
     'team4_id': gameData['team1_id'],
     'team5_id': gameData['team1_id'],
     'team1_name': team1Row.rows.first.assoc()['name'],
     'team2_name': team2Row.rows.first.assoc()['name'],
     'team3_name': gameData['team1_id'],
     'team4_name': gameData['team1_id'],
     'team5_name': gameData['team1_id'],
     'team1_score': gameData['team1_score'],
     'team2_score': gameData['team2_score'],
     'team3_score': gameData['team3_score'],
     'team4_score': gameData['team4_score'],
     'team5_score': gameData['team5_score'],
     'master_id': gameData['master_id'],
   });
 }
  return games;
}




// master_id int