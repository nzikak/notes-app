import 'dart:async';
import 'package:notes_app/extensions/list/filter.dart';
import 'package:notes_app/services/local/db_exceptions.dart';
import 'package:notes_app/services/local/local_note_entity.dart';
import 'package:notes_app/services/local/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

const notesTable = "notes";
const usersTable = "users";
const dbName = "notes.db";
const dbVersion = 1;
const createNoteTable = '''
            CREATE TABLE IF NOT EXISTS "notes" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "content"	TEXT NOT NULL,
        "is_synced_with_backend"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "users" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
          ); ''';

class NoteService {
  Database? _db;

  List<LocalNote> _notes = List.empty();
  late final StreamController<List<LocalNote>> _notesStreamController;

  UserEntity? _currentUser;

  static final NoteService _shared = NoteService._sharedInstance();

  NoteService._sharedInstance() {
    _notesStreamController =
        StreamController<List<LocalNote>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }

  factory NoteService() => _shared;

  Stream<List<LocalNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final user = _currentUser;
        if (user == null) {
          throw SetUserBeforeReadingNotesException();
        }
        return note.userId == user.id;
      });

  Future<UserEntity> getOrCreateUser(
      {required String email, bool setAsCurrentUser = true}) async {
    try {
      final fetchedUser = await getUser(email: email);

      if (setAsCurrentUser) {
        _currentUser = fetchedUser;
      }
      return fetchedUser;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);

      if (setAsCurrentUser) {
        _currentUser = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _ensureDbIsOpened() async {
    try {
      await openDb();
    } on DatabaseAlreadyOpenException {
      //Do nothing
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
    await _db?.close();
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
    await _ensureDbIsOpened();
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
    await _ensureDbIsOpened();
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

  Future<LocalNote> createNote({required UserEntity owner}) async {
    await _ensureDbIsOpened();
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

    final note = LocalNote(true, id: noteId, content: content, userId: owner.id!);

    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int noteId}) async {
    await _ensureDbIsOpened();
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
    await _ensureDbIsOpened();
    final db = _getDatabaseOrThrow();
    final deletedNotesCount = await db.delete(notesTable);

    _notes.clear();
    _notesStreamController.add(_notes);
    return deletedNotesCount;
  }

  Future<LocalNote> getNote({required int noteId}) async {
    await _ensureDbIsOpened();
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

    final note = LocalNote.fromRow(result.first);
    _notes.removeWhere((note) => note.id == noteId);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<List<LocalNote>> getAllNotes() async {
    await _ensureDbIsOpened();
    final db = _getDatabaseOrThrow();
    final result = await db.query(notesTable);

    final notes = result.map((item) => LocalNote.fromRow(item)).toList();

    return notes;
  }

  Future<LocalNote> updateNote({
    required LocalNote note,
    required String content,
  }) async {
    await _ensureDbIsOpened();
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
