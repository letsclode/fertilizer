import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:starter_architecture_flutter_firebase/firebase_options.dart';

const vapidKey = "<YOUR_PUBLIC_VAPID_KEY_HERE>";

final messaging = FirebaseMessaging.instance;

class Notification {
  Future<String> getToken() async {
    // use the registration token to send messages to users from your trusted server environment
    String? token;

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      token = await messaging.getToken(
        vapidKey: vapidKey,
      );
    } else {
      token = await messaging.getToken();
    }

    if (kDebugMode) {
      print('Registration Token=$token');
    }
    return token ?? '';
  }

  void sendMessageToFcmRegistrationToken() {
    try {
      String registrationToken = "REPLACE_WITH_FCM_REGISTRATION_TOKEN";
      Map<String, String>? data = {'to': registrationToken};

      messaging.sendMessage(to: registrationToken, data: data);
    } catch (e) {
      print(e);
    }
  }

  void subscribeFcmRegistrationTokensToTopic() {
    try {
      String topicName = "app_promotion";

      messaging.subscribeToTopic(topicName);
    } catch (e) {
      print(e);
    }
  }

  void sendMessageToFcmTopic() {
    String topicName = "app_promotion";
    messaging.sendMessage();
  }
}
