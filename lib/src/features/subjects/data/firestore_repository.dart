import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_data_source.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';

String documentIdFromCurrentDate() {
  final iso = DateTime.now().toIso8601String();
  return iso.replaceAll(':', '-').replaceAll('.', '-');
}

class FirestorePath {
  static String subject(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String subjects(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}

class FirestoreRepository {
  const FirestoreRepository(this._dataSource);
  final FirestoreDataSource _dataSource;

  Future<void> setSubject({required UserID uid, required Subject subject}) =>
      _dataSource.setData(
        path: FirestorePath.subject(uid, subject.id),
        data: subject.toMap(),
      );

  Future<void> deleteSubject(
      {required UserID uid, required Subject subject}) async {
    // delete where entry.jobId == job.jobId
    final allActivities = await watchActivity(uid: uid, subject: subject).first;
    for (final activity in allActivities) {
      if (activity.subjectId == subject.id) {
        await deleteActivity(uid: uid, activity: activity);
      }
    }
    // delete job
    await _dataSource.deleteData(path: FirestorePath.subject(uid, subject.id));
  }

  Stream<Subject> watchSubject(
          {required UserID uid, required SubjectID subjectId}) =>
      _dataSource.watchDocument(
        path: FirestorePath.subject(uid, subjectId),
        builder: (data, documentId) => Subject.fromMap(data, documentId),
      );

  Stream<List<Subject>> watchSubjects({required UserID uid}) =>
      _dataSource.watchCollection(
        path: FirestorePath.subjects(uid),
        builder: (data, documentId) => Subject.fromMap(data, documentId),
      );

  Future<List<Subject>> fetchSubjects({required UserID uid}) =>
      _dataSource.fetchCollection(
        path: FirestorePath.subjects(uid),
        builder: (data, documentId) => Subject.fromMap(data, documentId),
      );

  Future<void> setActivity({required UserID uid, required Activity activity}) =>
      _dataSource.setData(
        path: FirestorePath.entry(uid, activity.id),
        data: activity.toMap(),
      );

  Future<void> deleteActivity(
          {required UserID uid, required Activity activity}) =>
      _dataSource.deleteData(path: FirestorePath.entry(uid, activity.id));

  Stream<List<Activity>> watchActivity(
          {required UserID uid, Subject? subject}) =>
      _dataSource.watchCollection<Activity>(
        path: FirestorePath.entries(uid),
        queryBuilder: subject != null
            ? (query) => query.where('subjectId', isEqualTo: subject.id)
            : null,
        builder: (data, documentID) => Activity.fromMap(data, documentID),
      );
}

final databaseProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(ref.watch(firestoreDataSourceProvider));
});

final subjectsStreamProvider = StreamProvider.autoDispose<List<Subject>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final database = ref.watch(databaseProvider);
  return database.watchSubjects(uid: user.uid);
});

final subjectStreamProvider =
    StreamProvider.autoDispose.family<Subject, SubjectID>((ref, subjectId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final database = ref.watch(databaseProvider);
  return database.watchSubject(uid: user.uid, subjectId: subjectId);
});

final subjectActivitiesStreamProvider =
    StreamProvider.autoDispose.family<List<Activity>, Subject>((ref, subject) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching jobs');
  }
  final database = ref.watch(databaseProvider);
  return database.watchActivity(uid: user.uid, subject: subject);
});
