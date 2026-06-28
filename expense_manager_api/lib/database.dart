import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  late Database db;

  void initDb() {
    db = sqlite3.open('expenses.db');

    // Create the table if it doesn't exist
    db.execute('''
      CREATE TABLE IF NOT EXISTS expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  Database get database => db;
}
