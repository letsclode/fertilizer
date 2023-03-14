import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/jobs_screen/jobs_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

import '../../../../common_widgets/list_items_builder.dart';
import '../../data/firestore_repository.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.kclass),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.addJob.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            jobsScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          final jobsAsyncValue = ref.watch(jobsStreamProvider);
          final images = [
            "img_backtoschool",
            "img_code",
            "img_graduation",
            "img_reachout"
          ];
          final rnd = Random();
          final r = 1 + rnd.nextInt(4 - 1);
          final backImage = "${images[r]}.jpg";
          // return const ReorderView();

          return ListItemsBuilder<Job>(
              data: jobsAsyncValue,
              itemBuilder: (context, job) => Container(
                    key: Key(job.id),
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed(
                          AppRoute.job.name,
                          params: {'id': job.id},
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          "assets/images/$backImage",
                                        )),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job.name.toCapitalized(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black),
                                            )),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          jobsScreenControllerProvider
                                                              .notifier)
                                                      .deleteJob(job);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  )

              //  Dismissible(
              //   key: Key('job-${job.id}'),
              //   background: Container(color: Colors.red),
              //   direction: DismissDirection.endToStart,
              //   onDismissed: (direction) => ref
              //       .read(jobsScreenControllerProvider.notifier)
              //       .deleteJob(job),
              //   child: JobListTile(
              //     job: job,
              //     onTap: () => context.goNamed(
              //       AppRoute.job.name,
              //       params: {'id': job.id},
              //     ),
              //   ),
              // ),
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
    return Container(
      color: Colors.red,
      height: 200,
      width: 100,
      child: Card(
        child: ListTile(
          title: Text(job.name),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
