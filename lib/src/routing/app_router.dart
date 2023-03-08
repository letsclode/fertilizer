import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/dashboard/dashboard_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/main/main_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/welcome/welcome_page.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/account/account_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/presentation/entries_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/entry_screen/entry_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/job_entries_screen/job_entries_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/edit_job_screen/edit_job_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/jobs_screen/jobs_screen.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/go_router_refresh_stream.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  signIn,
  emailPassword,
  dashboard,
  jobs,
  job, //specific job
  addJob,
  editJob,
  entry,
  addEntry,
  editEntry,
  subjects,
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
            path: '/jobs',
            name: AppRoute.jobs.name,
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: JobsScreen()),
            routes: [
              GoRoute(
                path: 'add',
                name: AppRoute.addJob.name,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: const EditJobScreen(),
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
                    child: JobEntriesScreen(jobId: id),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'subjects/add',
                    name: AppRoute.addEntry.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id']!;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: EntryScreen(
                          jobId: jobId,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'subjects/:eid',
                    name: AppRoute.entry.name,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id']!;
                      final entryId = state.params['eid']!;
                      final entry = state.extra as Entry?;
                      return MaterialPage(
                        key: state.pageKey,
                        child: EntryScreen(
                          jobId: jobId,
                          entryId: entryId,
                          entry: entry,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'edit',
                    name: AppRoute.editJob.name,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id'];
                      final job = state.extra as Job?;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: EditJobScreen(jobId: jobId, job: job),
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
              child: const ActivityScreen(),
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
