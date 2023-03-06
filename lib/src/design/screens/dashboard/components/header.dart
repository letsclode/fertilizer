import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import '../../../constants.dart';
import '../../../responsive.dart';
import 'package:http/http.dart' as http;

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String? token;

  @override
  void initState() {
    passToken();
    super.initState();
  }

  passToken() async {
    FirebaseFirestore.instance
        .collection("admintokens")
        .doc("HrN6zpXzEnN0wv6P872Z71184Up1")
        .get()
        .then((value) => {
              setState(() {
                token = value.data()!.values.first.toString();
                print(token);
              })
            })
        .catchError((err) => print(err));
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAwbaSXRc:APA91bE3cGglZGUNI0h8vuW1PaSBLFMy0MjBb_DE1QEG4wJjU-oqJ1b3pC8s25jaseOFfP248WQAwgFC8vp_B3wxUJx_xtgJMDICVczImwsDkjDkp_8sS8-Bpo9JZ_FmdgezOBXYarCT',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  //TODO: activate when menu button press
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              print("send message");
              print(token!);
              sendPushMessage("This is the body", "This is the title", token!);
            },
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context)) ...{
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        },
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 10, end: 10),
              showBadge: true,
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
            )
          ],
        )),
      ],
    );
  }
}
//TODO: Profile Card
// class ProfileCard extends StatelessWidget {
//   const ProfileCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: defaultPadding),
//       padding: const EdgeInsets.symmetric(
//         horizontal: defaultPadding,
//         vertical: defaultPadding / 2,
//       ),
//       decoration: BoxDecoration(
//         color: secondaryColor,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/images/profile_pic.png",
//             height: 38,
//           ),
//           if (!Responsive.isMobile(context))
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
//               child: Text("Angelina Jolie"),
//             ),
//           const Icon(Icons.notifications),
//         ],
//       ),
//     );
//   }
// }

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
