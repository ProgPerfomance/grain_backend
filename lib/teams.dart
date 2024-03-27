import 'package:mysql_client/mysql_client.dart';

Future<List> getTeams(MySQLConnection sql) async {
  List teams = [];
 final response = await sql.execute('select * from users where rules = 1');
  for(var item in response.rows) {
    var data = item.assoc();
    teams.add(
      {
        'name': data['name'],
        'id': data['id'],
        'score': data['score'],
        'wins': data['wins'],
        'games': data['games'],
      }
    );
  }

  return teams;
}