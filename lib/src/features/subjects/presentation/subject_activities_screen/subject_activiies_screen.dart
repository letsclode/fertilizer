import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/async_value_widget.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/subject_activities_screen/subject_activities_list.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

import '../../data/firestore_repository.dart';

class SubjectActivitiesScreen extends ConsumerWidget {
  const SubjectActivitiesScreen({super.key, required this.subjectID});
  final SubjectID subjectID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(subjectStreamProvider(subjectID));
    return ScaffoldAsyncValueWidget<Subject>(
      value: jobAsync,
      data: (subject) => SubjectActivitiesScreen(subjectID: subjectID),
    );
  }
}

class SubjectActivitiesPageContents extends StatelessWidget {
  const SubjectActivitiesPageContents({super.key, required this.subject});
  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.goNamed(
              AppRoute.editSubject.name,
              params: {'id': subject.id},
              extra: subject,
            ),
          ),
        ],
      ),
      body: SubjectActivitiesList(subject: subject),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.goNamed(
          AppRoute.addEntry.name,
          params: {'id': subject.id},
          extra: subject,
        ),
      ),
    );
  }
}
