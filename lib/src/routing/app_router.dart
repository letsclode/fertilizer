import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/dashboard/dashboard_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/main/main_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/welcome/welcome_page.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/account/account_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/edit_subject_screen/edit_subject_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/go_router_refresh_stream.dart';

import '../features/subjects/presentation/activity_screen/activities_screen.dart';
import '../features/subjects/presentation/subject_activities_screen/subject_activiies_screen.dart';
import '../features/subjects/presentation/subjects_screen/subjects_screen.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  signIn,
  emailPassword,
  dashboard,
  // jobs,
  job, //specific job
  // addJob,
  // editJob,
  editSubject,
  // entry,
  activity,
  addEntry,
  editEntry,
  subjects,
  addSubject,
  account,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  // final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return GoRouter(
    initialLocation: "/",
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;

      final bool onloginPage = state.subloc == '/';
      print(state.subloc);

      if (!isLoggedIn && !onloginPage) {
        return '/';
      }

      if (isLoggedIn && onloginPage) {
        return '/dashboard';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'emailPassword',
            name: AppRoute.emailPassword.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
                userType: UserType.student,
              ),
            ),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/subjects',
            name: AppRoute.subjects.name,
            pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey, child: const SubjectScreen()),
            routes: [
              GoRoute(
                path: 'add',
                name: AppRoute.addSubject.name,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: const EditSubjectScreen(),
                  );
                },
              ),
              GoRoute(
                path: ':id',
                name: AppRoute.job.name,
                pageBuilder: (context, state) {
                  final id = state.params['id']!;
                  return MaterialPage(
                    key: state.pageKey,
                    child: SubjectActivitiesScreen(subjectID: id),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'subjects/add',
                    name: AppRoute.addEntry.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final subjectId = state.params['id']!;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: ActivitiesScreen(
                          subjectId: subjectId,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'subjects/:eid',
                    name: AppRoute.activity.name,
                    pageBuilder: (context, state) {
                      final subjectId = state.params['id']!;
                      final activityId = state.params['aid']!;
                      final activity = state.extra as Activity?;
                      return MaterialPage(
                        key: state.pageKey,
                        child: ActivitiesScreen(
                          subjectId: subjectId,
                          activityId: activityId,
                          activity: activity,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'edit',
                    name: AppRoute.editSubject.name,
                    pageBuilder: (context, state) {
                      final subjectId = state.params['id'];
                      final subject = state.extra as Subject?;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: EditSubjectScreen(
                            subjectID: subjectId, subject: subject),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/subjects',
            name: AppRoute.subjects.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SubjectScreen(),
            ),
          ),
          GoRoute(
            path: '/dashboard',
            name: AppRoute.dashboard.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const AccountScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Container(
      child: Text("Error ${state.error}"),
    ),
  );
});
