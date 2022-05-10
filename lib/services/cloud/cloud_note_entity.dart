import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String ownerUserId;
  final String documentId;
  final String content;

  const CloudNote._({
    required this.ownerUserId,
    required this.documentId,
    required this.content,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerFieldName] as String,
        content = snapshot.data()[contentFieldName] as String;

}
