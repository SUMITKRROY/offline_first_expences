

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String _databaseName = 'expense_app.db';
  static const int _databaseVersion = 1;
  //table name
  static const String expenseTable = 'expenses';

  Database? _database;

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
_database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async{
    final databasepath =  await getDatabasesPath();
final path = join(
  databasepath,
  _databaseName
);
return openDatabase(
  path,
  version: _databaseVersion,
  onCreate: _onCreate
);
  }
  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE $expenseTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        amount REAL NOT NULL,
        categoryId TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        syncStatus TEXT NOT NULL,
        version INTEGER NOT NULL,
        isDeleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
  CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entityId TEXT NOT NULL,
    operation TEXT NOT NULL,
    payload TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    retryCount INTEGER NOT NULL DEFAULT 0
  )
''');
  }
}