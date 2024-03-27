import 'package:mysql_client/mysql_client.dart';

Future<void> createAccount(MySQLConnection sql,{
  required name,
  required email,
  required password,
  required type,

}) async{
 await sql.execute("insert into users (id, name, email, password, rules,games,wins,score) values (0, '$name', '$email', '$password', $type, 0,0,0)");
}