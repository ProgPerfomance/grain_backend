import 'package:mysql_client/mysql_client.dart';

Future<int> endGame(MySQLConnection sql, {
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
  sql.execute("insert into games (id, team1_id, team2_id,team3_id,team4_id,team5_id, team1_score, team2_score,team3_score,team4_score,team5_score, master_id, winner) values (${idInt+1}, $team1Id,$team2Id,$team3Id,$team4Id,$team5Id,$team1Score,$team2Score,$team3Score,$team4Score,$team5Score,$masterId,$winner)");
  return idInt+1;
}