const noteIdColumn = "id";
const contentColumn = "content";
const userIdColumn = "user_id";
const isSyncedColumn = "is_synced_with_backend";

class LocalNote {
  final String content;
  final int? id;
  final bool isSyncedWithBackend;
  final int userId;

  const LocalNote(
    this.isSyncedWithBackend, {
    this.id,
    required this.content,
    required this.userId,
  });

  LocalNote.fromRow(Map<String, Object?> row)
      : id = row[noteIdColumn] as int,
        userId = row[userIdColumn] as int,
        isSyncedWithBackend = (row[isSyncedColumn] as int) == 1 ? true : false,
        content = row[contentColumn] as String;


  @override
  String toString() =>
      "Note {id: $id, content: $content, "
          "userId: $userId, isSynced: $isSyncedWithBackend}";

  @override
  bool operator ==(covariant LocalNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
