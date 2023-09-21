/*import 'dart:async';
import 'package:fristapp/services/crud/crud_exceptions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;

class NotesServices {
  Database? _db;

  List<DatabaseNotes> _note = [];

  static final NotesServices _shared = NotesServices._sharedinstance();
  NotesServices._sharedinstance();

  factory NotesServices() => _shared;

  final _noteStreamController =
      StreamController<List<DatabaseNotes>>.broadcast();
  Stream<List<DatabaseNotes>> get allNote => _noteStreamController.stream;
  Future<DatabaseUser> getOrcreatUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNote();
    _note = allNotes.toList();
    _noteStreamController.add(_note);
  }

  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes notes, required String text}) async {
    final db = _getDatabaseOrThrow();

    await getnote(id: notes.id);

    final updatesCount = await db.update(noteTable, {
      textcolumn: text,
      isyncwithcloudcloumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getnote(id: notes.id);
      _note.retainWhere((note) => note.id == updatedNote.id);
      _note.add(updatedNote);
      _noteStreamController.add(_note);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNote({int? id}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );

    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getnote({required int id}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id =?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotDeleteNote();
    } else {
      final note = DatabaseNotes.fromRow(notes.first);
      _note.removeWhere((note) => note.id == id);
      _note.add(note);
      _noteStreamController.add(_note);
      return DatabaseNotes.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes({required int id}) async {
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _note = [];
    _noteStreamController.add(_note);
    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final deletedcount = await db.delete(
      noteTable,
      where: 'id =? ',
      whereArgs: [id],
    );

    if (deletedcount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _note.removeWhere((note) => note.id == id);
      _noteStreamController.add(_note);
    }
  }

  Future<DatabaseNotes> creatNote({required DatabaseUser owner}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = 'data';

    final noteid = await db.insert(noteTable, {
      useridcolumn: owner.id,
      textcolumn: text,
      isyncwithcloudcloumn: 1,
    });

    final note = DatabaseNotes(
      id: noteid,
      userid: owner.id,
      text: text,
      issyncwithcloud: true,
    );

    _note.add(note);
    _noteStreamController.add(_note);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTbale,
      limit: 1,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTbale,
      limit: 1,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userid = await db.insert(userTbale, {
      emailcolumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userid,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureopendb();
    final db = _getDatabaseOrThrow();
    final deletedcount = await db.delete(
      userTbale,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedcount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNoteOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNoteOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureopendb() async {
    try {
      await open();
    } on DatabaseAlreadyOpenExpection {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenExpection();
    }

    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbpath = join(docspath.path, dbName);

      final db = await openDatabase(dbpath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(creatNotesTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'Person, ID =$id , email =$email';
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userid;
  final String text;
  final bool issyncwithcloud;

  DatabaseNotes({
    required this.id,
    required this.userid,
    required this.text,
    required this.issyncwithcloud,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        text = map[textcolumn] as String,
        userid = map[useridcolumn] as int,
        //   issyncwithcloud = (map[issyncwithcloud] as int )  == 1 ? true : false;
        issyncwithcloud =
            (map[isyncwithcloudcloumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID =i$id, userid=$userid, isyncwithcloud= $issyncwithcloud text=$text';
  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const userTbale = 'user';
const noteTable = 'notes_2';
const dbName = 'notes.db';
const idcolumn = 'id';
const emailcolumn = 'email';
const useridcolumn = 'user_id';
const textcolumn = 'text';
const isyncwithcloudcloumn = 'issyncWithcloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "User" (
	"ID"	INTEGER NOT NULL,
	"Email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ID" AUTOINCREMENT)
);''';

const creatNotesTable = '''CREATE TABLE IF NOT EXISTS "Notes_2" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"Text"	TEXT,
	"is_sync_with cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "User"("ID")
);''';*/
