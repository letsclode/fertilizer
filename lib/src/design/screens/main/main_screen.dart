import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/src/design/responsive.dart';
import 'package:starter_architecture_flutter_firebase/src/design/screens/dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: add privder for key
      // key: context.read<MenuControllerCustom>().scaffoldKey,
      drawer: const SideMenu(),

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            const Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          const Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: DashboardScreen(),
          ),
        ],
      ),
    );
  }
}
