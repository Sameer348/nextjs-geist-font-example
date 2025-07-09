import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_notes_app/models/note.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE notes (
      id $idType,
      title $textType,
      description $textType,
      createdAt $textType,
      updatedAt $textType,
      isPinned $boolType,
      color $intType
    )
    ''');
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;

    final orderBy = 'isPinned DESC, updatedAt DESC';
    final result = await db.query('notes', orderBy: orderBy);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
