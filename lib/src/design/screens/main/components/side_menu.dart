import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';
import '../../../../features/authentication/presentation/account/account_screen_controller.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/alert_dialogs.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(accountScreenControllerProvider);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              context.goNamed(AppRoute.dashboard.name);
            },
          ),
          DrawerListTile(
            title: "Subjects",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              context.goNamed(AppRoute.jobs.name);
            },
          ),
          // DrawerListTile(
          //   title: "Subjects",
          //   svgSrc: "assets/icons/menu_task.svg",
          //   press: () {
          //     context.goNamed(AppRoute.subjects.name);
          //   },
          // ),
          DrawerListTile(
            title: "Students",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              context.goNamed(AppRoute.account.name);
            },
          ),
          DrawerListTile(
            title: "Activity",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Account",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_profile.svg",
            press: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?'.hardcoded,
                      cancelActionText: 'Cancel'.hardcoded,
                      defaultActionText: 'Logout'.hardcoded,
                    );
                    if (logout == true) {
                      ref
                          .read(accountScreenControllerProvider.notifier)
                          .signOut();
                    }
                  },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
