import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

String tableName = 'College';
String columnID = 'id';
String collegecode = 'collegecode';
String username = 'username';
String password = 'password';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db!;
  }

  static Future<Database> initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'local');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName($columnID INTEGER PRIMARY KEY AUTOINCREMENT, $collegecode TEXT, $username TEXT, $password TEXT)',
        );
      },
    );
    return _db!;
  }

  Future<int> insertNote(Person person) async {
    Database db = await this.db;
    return await db.insert(tableName, person.toMap());
  }

  Future<List<Person>> getAllDetails() async {
    Database db = await this.db;
    List<Map<String, dynamic>> maps =
        await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<Person> getDetailsById(id) async {
    Database db = await this.db;
    List<Map<String, dynamic>> maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Person.fromMap(maps.first);
    } else {
      throw Exception('Person not found with id $id');
    }
  }

  Future<int> updateDetails(Person person) async {
    Database db = await this.db;
    return await db.update(
      tableName,
      person.toMap(),
      where: '$columnID = ?',
      whereArgs: [person.id],
    );
  }

  Future<int> deleteDetails(int id) async {
    Database db = await this.db;
    return await db.delete(
      tableName,
      where: '$columnID = ?',
      whereArgs: [id],
    );
  }

  Future closeDb() async {
    Database db = await this.db;
    db.close();
  }
}

class Person {
  int? id;
  String? collegecode;
  String? username;
  String? password;

  Person({this.id, this.collegecode, this.username, this.password});

  Map<String, dynamic> toMap() {
    return {'id': id, 'collegecode': collegecode, 'username': username, 'password': password};
  }

  static Person fromMap(Map<String, dynamic> map) {
    return Person(
        id: map['id'],
        collegecode: map['collegecode'],
        username: map['username'],
        password: map['password'],
    );
  }
}
