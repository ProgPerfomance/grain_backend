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

  return List.from(teams.reversed);
}

Future<Map> getTeamInfo(MySQLConnection sql, id) async {
  final responseRow = await sql.execute('select * from users where id=$id');
  Map team = {};
  var response = responseRow.rows.first.assoc();
  team  =  {
    'name': response['name'],
    'wins': response['wins'],
    'score': response['score'],
  'games': response['games'],
    'email': response['email'],
  };
  return team;
}