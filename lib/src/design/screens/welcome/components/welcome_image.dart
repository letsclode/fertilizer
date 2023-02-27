import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatefulWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeImage> createState() => _WelcomeImageState();
}

class _WelcomeImageState extends State<WelcomeImage> {
  void messageListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
        showDialog(
            context: context,
            builder: ((BuildContext context) {
              return AlertDialog(
                content: Text(message.notification!.title!),
              );
            }));
      }
    });
  }

  @override
  void initState() {
    messageListener(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            // MaterialButton(
            //   onPressed: () async {
            //     final fcmToken = await FirebaseMessaging.instance.getToken(
            //         vapidKey:
            //             "BIFF0CwSoBUwFO4kKc-JguA4LuYk_git0W2kS7pwSascASClXl894ry03eErTR6lrk99Dalq4DIwr6Yhtxp5hV0");
            //     print(fcmToken);
            //   },
            //   child: const Text("Token"),
            // ),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/chat.svg",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
