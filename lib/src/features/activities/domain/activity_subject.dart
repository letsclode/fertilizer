import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';

class ActivitySubject {
  ActivitySubject(this.activity, this.subject);

  final Activity activity;
  final Subject subject;
}
