import 'dart:async';
import 'package:linux_crud_app/Data/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  //fungsi untuk get database jika database belum ada maka akan menjalankan fungsi initdb
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('form_data.db');
    return _database!;
  }

  //fungsi untuk mengecek jalur penyimpanan database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //fungsi membuat db baru
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE form_data (
      id $idType,
      name $textType,
      gender $textType,
      date $textType,
      address $textType,
      imagePath $textType
    )
    ''');
  }

  //fungsi input data
  Future<void> insertFormData(FormData formData) async {
    final db = await instance.database;
    await db.insert('form_data', formData.toMap());
  }

  //fungsi get data
  Future<List<FormData>> fetchAllFormData() async {
    final db = await instance.database;

    final result = await db.query('form_data');

    return result.map((json) => FormData.fromMap(json)).toList();
  }

  //fungsi delete data
  Future<int> deleteFormData(int id) async {
    final db = await instance.database;
    return await db.delete('form_data', where: 'id = ?', whereArgs: [id]);
  }
}
