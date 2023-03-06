import 'package:equatable/equatable.dart';

typedef ActivityID = String;

class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.subjectId,
    required this.title,
  });

  final ActivityID id;
  final String subjectId;
  final String title;

  @override
  List<Object> get props => [
        id,
        subjectId,
        title,
      ];

  @override
  bool get stringify => true;

  factory Activity.fromMap(Map<dynamic, dynamic>? value, String id) {
    if (value == null) {
      throw StateError('missing data for entryId: $id');
    }

    return Activity(
        id: id, subjectId: value['subjectId'] as String, title: value['title']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'subjectId': subjectId, 'title': title};
  }
}
