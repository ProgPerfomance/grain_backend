import 'package:mysql_client/mysql_client.dart';

Future<void> createAccount(MySQLConnection sql,{
  required name,
  required email,
  required password,
  required type,

}) async{
  int id_int;
  try {
    var resul = await sql.execute(
      "SELECT * FROM users",
    );
    String id = resul.rows.last.assoc()['id'] as String;
   id_int = int.parse(id);
  }
  catch(_) {
id_int = 0;
  }
 await sql.execute("insert into users (id, name, email, password, rules,games,wins,score) values (${id_int+1}, '$name', '$email', '$password', $type, 0,0,0)");
}

Future<Map> auth(MySQLConnection sql, email, password) async {
  try {
  final response =  await sql.execute("select * from users where email='$email' and password ='$password'");
    return {
      'success': true,
      'uid': response.rows.first.assoc()['id'],
      'name': response.rows.first.assoc()['name'],
      'rules': response.rows.first.assoc()['rules'],
    };
  }
  catch(_) {
    return {
      'success': false,
    };
  }

}