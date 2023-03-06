import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/edit_subject_screen/job_submit_exception.dart';

class EditJobScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<bool> submit({
    Subject? subject,
    required String name,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    // set loading state
    state = const AsyncLoading().copyWithPrevious(state);
    // check if name is already in use
    final database = ref.read(databaseProvider);
    final subjects = await database.fetchSubjects(uid: currentUser.uid);
    final allLowerCaseNames =
        subjects.map((job) => job.name.toLowerCase()).toList();
    if (subject != null) {
      allLowerCaseNames.remove(subject.name.toLowerCase());
    }
    // check if name is already used
    if (allLowerCaseNames.contains(name.toLowerCase())) {
      state = AsyncError(JobSubmitException(), StackTrace.current);
      return false;
    } else {
      final id = subject?.id ?? documentIdFromCurrentDate();
      final updated = Subject(
        id: id,
        name: name,
      );
      state = await AsyncValue.guard(
        () => database.setSubject(uid: currentUser.uid, subject: updated),
      );
      return state.hasError == false;
    }
  }
}

final editJobScreenControllerProvider =
    AutoDisposeAsyncNotifierProvider<EditJobScreenController, void>(
        EditJobScreenController.new);
