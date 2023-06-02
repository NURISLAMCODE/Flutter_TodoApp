import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/model.dart';

class databaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    final documentDirectory = await getDatabasesPath();

    String path = join(documentDirectory, 'Todo.database');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  _createDatabase(Database database, int version) async {
    await database.execute(
      "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL)",
    );
  }
  //data insert

  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await database;
    await dbClient?.insert('mytodo', todoModel.toMap());
    return todoModel;
  }

  Future<List<TodoModel>> getDataList() async {
    await database;
    final List<Map<String, Object?>> QueryResult =
        await _database!.rawQuery('SELECT * FROM mytodo');
    return QueryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('mytodo', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await database;
    return await dbClient!.update('mytodo', todoModel.toMap(),
        where: 'id = ?', whereArgs: [todoModel.id]);
  }
}
