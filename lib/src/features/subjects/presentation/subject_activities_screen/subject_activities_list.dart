import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/subject_activities_screen/subject_activities_list_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

import 'activity_list_item.dart';

class SubjectActivitiesList extends ConsumerWidget {
  const SubjectActivitiesList({super.key, required this.subject});
  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      subjectActivitiesListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final activitiesStream =
        ref.watch(subjectActivitiesStreamProvider(subject));
    return ListItemsBuilder<Activity>(
      data: activitiesStream,
      itemBuilder: (context, activity) {
        return DismissibleActivityListItem(
          dismissibleKey: Key('activity-${activity.id}'),
          activity: activity,
          subject: subject,
          onDismissed: () => ref
              .read(subjectActivitiesListControllerProvider.notifier)
              .deleteEntry(activity),
          onTap: () => context.goNamed(
            AppRoute.activity.name,
            params: {'id': subject.id, 'eid': activity.id},
            extra: activity,
          ),
        );
      },
    );
  }
}
