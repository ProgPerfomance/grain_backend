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
            'price':question.rows.toList()[index].assoc()['price'],
            'time':question.rows.toList()[index].assoc()['qdv'],
            'answer':question.rows.toList()[index].assoc()['q_answer'],
            'comment':question.rows.toList()[index].assoc()['q_comment'],
              }),
    });
  }

  return List.from(questions);
}
