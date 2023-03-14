import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'student_pageController.g.dart';

@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}
