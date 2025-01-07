import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scoreboard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE scores(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      result INTEGER,
      date TEXT,
      level TEXT
    )
    ''');
  }

  Future<int> insertScore(Map<String, dynamic> score) async {
    final db = await instance.database;
    return await db.insert('scores', score);
  }

  Future<List<Map<String, dynamic>>> getScores() async {
    final db = await instance.database;
    return await db.query('scores');
  }

  Future<int> updateScore(Map<String, dynamic> score) async {
    final db = await instance.database;
    return await db.update(
      'scores',
      score,
      where: 'id = ?',
      whereArgs: [score['id']],
    );
  }

  Future<int> deleteScore(int id) async {
    final db = await instance.database;
    return await db.delete(
      'scores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
