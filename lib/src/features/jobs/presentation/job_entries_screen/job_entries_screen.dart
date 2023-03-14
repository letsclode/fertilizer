import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/async_value_widget.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

import 'classpage/grades.dart';
import 'classpage/lessons.dart';
import 'classpage/news.dart';
import 'classpage/student/studentsPage.dart';

class JobEntriesScreen extends ConsumerWidget {
  const JobEntriesScreen({super.key, required this.jobId});
  final JobID jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobStreamProvider(jobId));
    return ScaffoldAsyncValueWidget<Job>(
      value: jobAsync,
      data: (job) => JobEntriesPageContents(job: job),
    );
  }
}

class JobEntriesPageContents extends StatelessWidget {
  const JobEntriesPageContents({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("News"),
              ),
              Tab(
                child: Text("Lessons"),
              ),
              Tab(
                child: Text("Students"),
              ),
              Tab(
                child: Text("Grades"),
              ),
            ],
          ),
          title: Text(job.name),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => context.goNamed(
                AppRoute.editJob.name,
                params: {'id': job.id},
                extra: job,
              ),
            ),
          ],
        ),
        body: Container(
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Class Code"),
                                    Center(
                                        child: Text(
                                      job.code,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.blue),
                                    ))
                                  ],
                                ),
                              )),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.copy))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              Expanded(
                flex: 3,
                child: Container(
                  child: const TabBarView(
                    children: [
                      Card(child: NewsPage()),
                      Card(child: LessonsPage()),
                      Card(child: StudentPage()),
                      Card(child: GradesPage())
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
