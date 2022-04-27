import 'package:flutter/foundation.dart';

const idColumn = "id";
const emailColumn = "email";

@immutable
class UserEntity {
  final int? id;
  final String email;

  const UserEntity({this.id, required this.email});

  UserEntity.fromRow(Map<String, Object?> row)
      : id = row[idColumn] as int,
        email = row[emailColumn] as String;

  @override
  String toString() => "UserEntity {id: $id, email: $email}";

  @override
  bool operator ==(covariant UserEntity other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
