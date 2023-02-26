import 'package:flutter/material.dart';
import '../../../features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import '../../../features/authentication/presentation/email_password/email_password_sign_in_screen.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../main/components/background.dart';
import 'components/signup_top_image.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignupScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: EmailPasswordSignInScreen(
                        formType: EmailPasswordSignInFormType.register,
                        userType: UserType.instructor,
                      ),
                    ),
                    SizedBox(height: defaultPadding / 2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.register,
                userType: UserType.instructor,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
