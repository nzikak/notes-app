import 'dart:async';

import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/local/db_exceptions.dart';
import 'package:notes_app/services/local/note_entity.dart';
import 'package:notes_app/services/local/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

const notesTable = "notes";
const usersTable = "users";
const dbName = "notes.db";
const dbVersion = 1;
const createNoteTable = '''
            CREATE TABLE "notes" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "content"	TEXT NOT NULL,
        "is_synced_with_backend"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
const createUserTable = '''CREATE TABLE IF NOT EXIST "users" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
          ); ''';

class NoteService {
  Database? _db;

  List<Note> _notes = List.empty();
  final _notesStreamController = StreamController<List<Note>>.broadcast();

  Future<UserEntity> getOrCreateUser({required String email}) async {
    try {
      final fetchedUser = await getUser(email: email);
      return fetchedUser;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final notes = await getAllNotes();
    _notes = notes;
    _notesStreamController.add(_notes);
  }

  Future<void> openDb() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath, version: dbVersion);
      _db = db;

      //Create User table
      await db.execute(createUserTable);

      //Create Notes table
      await db.execute(createNoteTable);

      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> closeDb() async {
    if (_db == null) {
      throw DatabaseNotOpenException();
    }
    _db?.close();
    _db = null;
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseNotOpenException();
    }
    return _db!;
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedRowsCount = await db.delete(usersTable,
        where: '$emailColumn = ?', whereArgs: [email.toLowerCase()]);
    if (deletedRowsCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<UserEntity> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      usersTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId =
        await db.insert(usersTable, {emailColumn: email.toLowerCase()});

    return UserEntity(id: userId, email: email);
  }

  Future<UserEntity> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      usersTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw CouldNotFindUserException();
    }

    return UserEntity.fromRow(result.first);
  }

  Future<Note> createNote({required UserEntity owner}) async {
    final db = _getDatabaseOrThrow();

    final user = await getUser(email: owner.email);
    if (user != owner) {
      throw CouldNotFindUserException();
    }

    const content = '';

    final noteId = await db.insert(
      notesTable,
      {
        userIdColumn: owner.id,
        contentColumn: content,
        isSyncedColumn: 1,
      },
    );

    final note = Note(true, id: noteId, content: content, userId: owner.id!);

    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int noteId}) async {
    final db = _getDatabaseOrThrow();

    final deletedNoteCount = await db
        .delete(notesTable, where: '$noteIdColumn = ?', whereArgs: [noteId]);
    if (deletedNoteCount == 0) {
      throw CouldNotDeleteNoteException();
    }
    _notes.removeWhere((note) => note.id == noteId);
    _notesStreamController.add(_notes);
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    final deletedNotesCount = await db.delete(notesTable);

    _notes.clear();
    _notesStreamController.add(_notes);
    return deletedNotesCount;
  }

  Future<Note> getNote({required int noteId}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      notesTable,
      limit: 1,
      where: "$noteIdColumn = ?",
      whereArgs: [noteId],
    );

    if (result.isEmpty) {
      throw CouldNotFindNoteException();
    }

    final note = Note.fromRow(result.first);
    _notes.removeWhere((note) => note.id == noteId);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<List<Note>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(notesTable);

    final notes = result.map((item) => Note.fromRow(item)).toList();

    return notes;
  }

  Future<Note> updateNote({
    required Note note,
    required String content,
  }) async {
    final db = _getDatabaseOrThrow();

    await getNote(noteId: note.id!);

    final count = await db.update(
        notesTable, {contentColumn: content, isSyncedColumn: 0},
        where: "$noteIdColumn = ?", whereArgs: [note.id]);

    if (count == 0) {
      throw CouldNotUpdateNoteException();
    }

    return await getNote(noteId: note.id!);
  }
}