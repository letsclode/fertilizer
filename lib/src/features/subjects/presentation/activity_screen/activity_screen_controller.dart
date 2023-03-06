import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';

class EntryScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<bool> setEntry(Activity activity) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final database = ref.read(databaseProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => database.setActivity(uid: currentUser.uid, activity: activity));
    return state.hasError == false;
  }
}

final entryScreenControllerProvider =
    AutoDisposeAsyncNotifierProvider<EntryScreenController, void>(
        EntryScreenController.new);
