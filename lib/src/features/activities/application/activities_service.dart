import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/activities/domain/activities_list_tile_model.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import '../../subjects/domain/subject.dart';
import '../domain/activity_subject.dart';

// TODO: Clean up this code a bit more
class EntriesService {
  EntriesService({required this.database});
  final FirestoreRepository database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<ActivitySubject>> _allEntriesStream(UserID uid) =>
      rx.CombineLatestStream.combine2(
        database.watchActivity(uid: uid),
        database.watchSubjects(uid: uid),
        _entriesJobsCombiner,
      );

  static List<ActivitySubject> _entriesJobsCombiner(
      List<Activity> activities, List<Subject> subjects) {
    return activities.map((activity) {
      final subject =
          subjects.firstWhere((subject) => subject.id == activity.subjectId);
      return ActivitySubject(activity, subject);
    }).toList();
  }

  /// Output stream
  Stream<List<ActivitiesListTileModel>> entriesTileModelStream(UserID uid) =>
      _allEntriesStream(uid).map(_createModels);

  static List<ActivitiesListTileModel> _createModels(
      List<ActivitySubject> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    // final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    // final totalDuration = allDailyJobsDetails
    //     .map((dateJobsDuration) => dateJobsDuration.duration)
    //     .reduce((value, element) => value + element);

    // // total pay across all jobs
    // final totalPay = allDailyJobsDetails
    //     .map((dateJobsDuration) => dateJobsDuration.pay)
    //     .reduce((value, element) => value + element);

    return <ActivitiesListTileModel>[
      const ActivitiesListTileModel(
        leadingText: 'All Activities',
        trailingText: 'Trailing', //TODO: make this dynamic value
      ),
      // for (DailySubjectDetails dailyJobsDetails in allDailyJobsDetails) ...[
      //   ActivitiesListTileModel(
      //     isHeader: true,
      //     leadingText: Format.date(dailyJobsDetails.date),
      //     middleText: Format.currency(dailyJobsDetails.pay),
      //     trailingText: Format.hours(dailyJobsDetails.duration),
      //   ),
      //   for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
      //     ActivitiesListTileModel(
      //       leadingText: jobDuration.name,
      //       middleText: Format.currency(jobDuration.pay),
      //       trailingText: Format.hours(jobDuration.durationInHours),
      //     ),
      // ]
    ];
  }
}

final entriesServiceProvider = Provider<EntriesService>((ref) {
  return EntriesService(database: ref.watch(databaseProvider));
});

final entriesTileModelStreamProvider =
    StreamProvider.autoDispose<List<ActivitiesListTileModel>>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      throw AssertionError('User can\'t be null when fetching entries');
    }
    final entriesService = ref.watch(entriesServiceProvider);
    return entriesService.entriesTileModelStream(user.uid);
  },
);
