import 'dart:convert';
import 'dart:indexed_db';

import 'package:grain_backend/grain_backend.dart' as grain_backend;
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
      databaseName: 'autoapp');
  await sql.connect(timeoutMs: 99999999999);
  Router router = Router();
  router.get('/teams', (Request request) async{
    List response = await getTeams(sql);
    return Response.ok(jsonEncode(response));
  });
  serve(router, '63.251.122.116', 2308);
}
