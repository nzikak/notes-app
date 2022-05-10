import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/cloud/cloud_note_entity.dart';
import 'package:notes_app/services/cloud/cloud_storage_constants.dart';
import 'package:notes_app/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final _notesRef = FirebaseFirestore.instance.collection("notes");

  void createNewNote({required String ownerUserId}) async {
    await _notesRef.add({
      ownerFieldName: ownerUserId,
      contentFieldName: "",
    });
  }

  Future<void> updateNote({
    required String documentId,
    required String content,
  }) async {
    try {
      await _notesRef.doc(documentId).update({
        contentFieldName: content,
      });
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await _notesRef.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return _notesRef.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerUserId == ownerUserId));
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await _notesRef
          .where(
            ownerFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((querySnapshot) =>
              querySnapshot.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
