import 'package:flutter/material.dart';
import '../../../features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import '../../../features/authentication/presentation/email_password/email_password_sign_in_screen.dart';
import '../../responsive.dart';
import '../main/components/background.dart';
import 'components/login_top_image.dart';

class LoginScreen extends StatelessWidget {
  final bool isStudent;
  const LoginScreen({Key? key, required this.isStudent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(
            isStudent: isStudent,
          ),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 380,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: EmailPasswordSignInScreen(
                            formType: EmailPasswordSignInFormType.signIn,
                            userType: isStudent
                                ? UserType.student
                                : UserType.instructor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  final bool isStudent;
  const MobileLoginScreen({Key? key, required this.isStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
                userType: isStudent ? UserType.student : UserType.instructor,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
