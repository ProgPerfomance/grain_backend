import 'dart:convert';
import 'package:grain_backend/auth.dart';
import 'package:grain_backend/teams.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments)async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'grade');
  await sql.connect(timeoutMs: 99999999999);
  Router router = Router();
  router.get('/teams', (Request request) async{
    List response = await getTeams(sql);
    return Response.ok(jsonEncode(response));
  });
  router.post('/registration', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createAccount(sql, name: data['name'], email: data['email'], password: data['password'], type: data['type']);
    return Response.ok('created');
  });
  serve(router, '63.251.122.116', 2308);
}
