import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String userType, String idCode) {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => postDetailsToFirestore(email, userType, idCode));
  }

  postDetailsToFirestore(String email, String rule, String idCode) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = _auth.currentUser;
      if (idCode.isNotEmpty) {
        CollectionReference ref =
            FirebaseFirestore.instance.collection('users');
        ref
            .doc(user!.uid)
            .set({'email': email, 'rule': rule, 'idcode': idCode});
      } else {
        CollectionReference ref =
            FirebaseFirestore.instance.collection('users');
        ref.doc(user!.uid).set({'email': email, 'rule': rule});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
