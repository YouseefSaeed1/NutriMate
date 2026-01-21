import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();

  return await sql.openDatabase(
    path.join(dbPath, 'daily.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE meals(id TEXT PRIMARY KEY, name TEXT, calories TEXT, time TEXT)',
      );
    },
  );
}
