import 'dart:convert';
import 'package:grain_backend/auth.dart';
import 'package:grain_backend/game.dart';
import 'package:grain_backend/questions.dart';
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
  router.post('/questions', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await createQuestion(sql: sql, qText: data['q_text'], qAnswer: data['q_answer'], qDelay: data['q_delay'], qComment: data['q_comment'], masterID: data['uid'], price: data['price'], tip: data['tip']);
    return Response.ok('created');
  });
  router.post('/category', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await createCollection(sql: sql, name: data['name']);
    return Response.ok('created');
  });
  router.post('/endGame', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await endGame(sql, team1Id: data['team1_id'], team2Id: data['team2_id'], team3Id: data['team3_id'], team4Id: data['team4_id'], team5Id: data['team5_id'], team1Score: data['team1_score'], team2Score: data['team2_score'], team3Score: data['team3_score'], team4Score: data['team4_score'], team5Score: data['team5_score'], masterId: data['master_id'], winner: data['winner']);
    return Response.ok('created');
  });
  router.post('/auth', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
   Map response = await auth(sql, data['email'], data['password']);
    return Response.ok(jsonEncode(response));
  });
  router.get('/questions', (Request request) async {
    List response = await getQuestions(sql);
    return Response.ok(jsonEncode(response));
  });
  router.post('/useQuest', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    Map response = await auth(sql, data['email'], data['password']);
    return Response.ok(jsonEncode(response));
  });
  router.get('/categories', (Request request) async {
  List response = await  getCategories(sql);
  return Response.ok(jsonEncode(response));
  });
  serve(router, '63.251.122.116', 2314);
}
