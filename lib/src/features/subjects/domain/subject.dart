import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef SubjectID = String;

@immutable
class Subject extends Equatable {
  const Subject({required this.id, required this.name});
  final SubjectID id;
  final String name;

  @override
  List<Object> get props => [
        id,
        name,
      ];

  @override
  bool get stringify => true;

  factory Subject.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for subjectId: $documentId');
    }
    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for subjectId: $documentId');
    }
    return Subject(id: documentId, name: name);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
