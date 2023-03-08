import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef JobID = String;

@immutable
class Job extends Equatable {
  const Job(
      {required this.id,
      required this.name,
      required this.details,
      required this.code});
  final JobID id;
  final String name;
  final String details;
  final String code;

  @override
  List<Object> get props => [id, name, details, code];

  @override
  bool get stringify => true;

  factory Job.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for jobId: $documentId');
    }
    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for jobId: $documentId');
    }
    final details = data['details'] as String?;
    if (details == null) {
      throw StateError('missing details for jobId: $documentId');
    }
    final code = data['code'] as String?;
    if (code == null) {
      throw StateError('missing code for jobId: $documentId');
    }
    return Job(id: documentId, name: name, details: details, code: code);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'details': details, 'code': code};
  }
}
