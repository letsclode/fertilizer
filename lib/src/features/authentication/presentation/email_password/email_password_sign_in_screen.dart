import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/primary_button.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/app_sizes.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_validators.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/string_validators.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

import '../../../../common_widgets/custom_text_button.dart';

/// Email & password sign in screen.
/// Wraps the [EmailPasswordSignInContents] widget below with a [Scaffold] and
/// [AppBar] with a title.
class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen(
      {super.key, required this.formType, required this.userType});
  final EmailPasswordSignInFormType formType;
  final UserType userType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');
  static const idNumber = Key('idnumber');

  @override
  Widget build(BuildContext context) {
    return EmailPasswordSignInContents(
      formType: formType,
      userType: userType,
    );
  }
}

/// A widget for email & password authentication, supporting the following:
/// - sign in
/// - register (create an account)
class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  EmailPasswordSignInContents({
    this.userType = UserType.student,
    super.key,
    required this.formType,
  });

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;

  UserType userType;

  @override
  ConsumerState<EmailPasswordSignInContents> createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idNumberController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var _submitted = false;
  // track the formType as a local state variable
  late var _formType = widget.formType;
  late final _userType = widget.userType;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(emailPasswordSignInControllerProvider.notifier);
      await controller.submit(
        email: email,
        password: password,
        formType: _formType,
      );
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType() {
    // * Toggle between register and sign in form
    setState(() => _formType = _formType.secondaryActionFormType);
    // * Clear the password field when doing so
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInControllerProvider);
    return FocusScope(
      node: _node,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            gapH8,
            // Email field
            TextFormField(
              key: EmailPasswordSignInScreen.emailKey,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email'.hardcoded,
                hintText: 'test@test.com'.hardcoded,
                enabled: !state.isLoading,
                labelStyle: const TextStyle().copyWith(
                    fontSize:
                        Theme.of(context).textTheme.labelMedium!.fontSize),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  !_submitted ? null : emailErrorText(email ?? ''),
              autocorrect: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.light,
              onEditingComplete: () => _emailEditingComplete(),
              inputFormatters: <TextInputFormatter>[
                ValidatorInputFormatter(
                    editingValidator: EmailEditingRegexValidator()),
              ],
            ),
            gapH8,
            // ID NUmber field
            _userType == UserType.student
                ? TextFormField(
                    key: EmailPasswordSignInScreen.idNumber,
                    controller: _idNumberController,
                    decoration: InputDecoration(
                      labelText: "ID Number",
                      enabled: !state.isLoading,
                      labelStyle: const TextStyle().copyWith(
                          fontSize: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .fontSize),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) =>
                        !_submitted ? null : "Invalid ID Number",
                    obscureText: true,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardAppearance: Brightness.light,
                    onEditingComplete: () => _passwordEditingComplete(),
                  )
                // Password field
                : TextFormField(
                    key: EmailPasswordSignInScreen.passwordKey,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: _formType.passwordLabelText,
                      labelStyle: const TextStyle().copyWith(
                          fontSize: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .fontSize),
                      enabled: !state.isLoading,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => !_submitted
                        ? null
                        : passwordErrorText(password ?? '', _formType),
                    obscureText: true,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardAppearance: Brightness.light,
                    onEditingComplete: () => _passwordEditingComplete(),
                  ),
            gapH20,
            PrimaryButton(
              text: _formType.primaryButtonText,
              isLoading: state.isLoading,
              onPressed: state.isLoading ? null : () => _submit(),
            ),
            gapH8,
            if (_userType == UserType.instructor) ...{
              CustomTextButton(
                text: _formType.secondaryButtonText,
                onPressed: state.isLoading ? null : _updateFormType,
              ),
            }
          ],
        ),
      ),
    );
  }
}
