import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/jobs_screen/jobs_screen_controller.dart';
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
          final jobsAsyncValue = ref.watch(jobsStreamProvider);
          return ListItemsBuilder<Job>(
            data: jobsAsyncValue,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => ref
                  .read(jobsScreenControllerProvider.notifier)
                  .deleteSubject(job),
              child: JobListTile(
                job: job,
                onTap: () => context.goNamed(
                  AppRoute.job.name,
                  params: {'id': job.id},
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class JobListTile extends StatelessWidget {
  const JobListTile({Key? key, required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
