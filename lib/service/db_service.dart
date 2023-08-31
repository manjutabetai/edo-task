import 'package:edo_task/model/task';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper db = DBHelper._();

  static Database? _database;

  static const int _version = 2;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_database != null) {
      print('db != null');
      return;
    }
    try {
      print('db create');
      String path = "${await getDatabasesPath()}tasks.db";
      _database =
          await openDatabase(path, version: _version, onCreate: (db, version) {
        print("db 作成");
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, memo TEXT, date STRING, "
          "remind INTEGER, repeat INTEGER, "
          "color INTEGER, "
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  /// tableを作成する

  static Future<int> insert(Task? task) async {
    print('インサート関数実行');
    return await _database?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _database!.query(_tableName);
  }

  static delete(Task task) async {
    await _database!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return _database!.rawUpdate('''
UPDATE tasks
SET isCompleted = ?
WHERE id =? 

''', [1, id]);
  }
}
