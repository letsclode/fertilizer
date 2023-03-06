import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/subjects_screen/subjects_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.subject),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.addSubject.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            jobsScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          // * TODO: investigate why we get a dismissible error if we call
          // * ref.watch(jobsScreenControllerProvider) here
          final jobsAsyncValue = ref.watch(subjectsStreamProvider);
          return ListItemsBuilder<Subject>(
            data: jobsAsyncValue,
            itemBuilder: (context, subject) => Dismissible(
              key: Key('subject-${subject.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => ref
                  .read(jobsScreenControllerProvider.notifier)
                  .deleteSubject(subject),
              child: SubjectListTile(
                subject: subject,
                onTap: () => context.goNamed(
                  AppRoute.job.name,
                  params: {'id': subject.id},
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubjectListTile extends StatelessWidget {
  const SubjectListTile({Key? key, required this.subject, this.onTap})
      : super(key: key);
  final Subject subject;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subject.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
