import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../login/login_page.dart';
import '../../signup/signup_page.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Login as a"),
        const SizedBox(
          height: 10,
        ),
        Hero(
          tag: "login_btn",
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen(
                        isStudent: true,
                      
                      );
                    },
                  ),
                );
              },
              child: const Text(
                "Student",
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen(isStudent: false);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryLightColor, elevation: 0),
            child: const Text(
              "Instructor",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
