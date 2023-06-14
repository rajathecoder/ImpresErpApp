import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tododatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, Date TEXT, URL TEXT)',
        );
      },
      version: 1,
    );
  }
  Future<void> inserttodo(todo todo) async {
    final db = await initializeDB();
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<todo>> todos() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('todos');
    return queryResult.map((e) => todo.fromMap(e)).toList();
  }

  Future<void> deletetodo(int id) async {
    final db = await initializeDB();
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int?> getCount() async {
    //database connection
    Database db = await initializeDB();
    var x = await db.rawQuery('SELECT count(*) from todos');
    int? tod = Sqflite.firstIntValue(x);
    return tod;
  }

}


class todo {
  final int id;
  final String title;
  final String description;
  final String Date;
  final String URL;

  todo({
    required this.id,
    required this.title,
    required this.description,
    required this.Date,
    required this.URL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'Date':Date,
      'URL' : URL,
    };
  }

  todo.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        Date = res["Date"],
        URL = res["URL"];

  @override
  String toString() {
    return 'todo{id: $id, title: $title, description: $description, Date: $Date, URL: $URL}';
  }
}