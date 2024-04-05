import 'package:mysql_client/mysql_client.dart';

Future<List> getQuestions(MySQLConnection sql) async {
  List questions = [];
  final response = await sql.execute('select * from categories');
  for (var item in response.rows) {
    var data = item.assoc();
    var question =
        await sql.execute("select * from questions where tip = ${data['id']}");
    questions.add({
      'type_id': data['id'],
      'type_name': data['name'],
      'questions': List.generate(
          question.rows.length,
          (index) => {
                'id': question.rows.toList()[index].assoc()['id'],
                'q_text': question.rows.toList()[index].assoc()['q_text'],
                'price': question.rows.toList()[index].assoc()['price'],
                'time': question.rows.toList()[index].assoc()['qdv'],
                'answer': question.rows.toList()[index].assoc()['q_answer'],
                'comment': question.rows.toList()[index].assoc()['q_comment'],
              }),
    });
  }

  return List.from(questions);
}

Future<void> createQuestion({
  required MySQLConnection sql,
  required qText,
  required qAnswer,
  required qDelay,
  required qComment,
  required masterID,
  required price,
  required tip,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM questions",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  sql.execute(
      "insert into questions (id, q_text, price, qdv, q_answer, q_comment, masterd, tip) values (${id_int + 1}, '$qText', $price, $qDelay, '$qAnswer', '$qComment', $masterID, $tip)");
}

Future<void> createCollection({
  required MySQLConnection sql,
  required name,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM categories",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  sql.execute(
      "insert into categories (id, name) values (${id_int + 1}, '$name')");
}
