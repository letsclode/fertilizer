import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/subject.dart';

class ActivitySubject {
  ActivitySubject(this.entry, this.job);

  final Entry entry;
  final Subject job;
}
