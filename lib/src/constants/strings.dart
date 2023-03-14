class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';

  // Logout
  static const String logout = 'Logout';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const String logoutFailed = 'Logout failed';

  // Sign In Page
  static const String signIn = 'Sign in';
  static const String signInWithEmailPassword = 'Sign in with email & password';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';
  static const String signInFailed = 'Sign in failed';

  // Home page
  static const String homePage = 'Home Page';

  // Jobs page
  static const String kclass = 'My Class';
  //dashboard
  static const String dashboard = 'DashBoard';

  // Entries page
  static const String subject = 'Subjects';

  // Account page
  static const String account = 'Account';
  static const String accountPage = 'Account Page';
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
