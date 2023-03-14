import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/email_password/email_password_sign_in_form_type.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/job_entries_screen/classpage/student/student_pageController.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/job_entries_screen/classpage/widgets/student_action.dart';

import '../../../../../authentication/presentation/email_password/email_password_sign_in_controller.dart';

class StudentPage extends ConsumerStatefulWidget {
  const StudentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentPageState();
}

class StudentModel {
  final String? id;
  final String email;
  final String password;
  final String idCode;
  StudentModel(
      {this.id,
      required this.email,
      required this.password,
      required this.idCode});
}

class _StudentPageState extends ConsumerState<StudentPage> {
  bool isChecked = false;

  addStudent(StudentModel student) async {
    final controller = ref.read(emailPasswordSignInControllerProvider.notifier);
    try {
      await controller.submit(
          email: student.email,
          password: student.password,
          formType: EmailPasswordSignInFormType.register,
          userType: UserType.student,
          idCode: student.idCode);
      print("Successful add");
    } catch (e) {
      print(e);
    }
  }

  importCsv() {}

  @override
  Widget build(BuildContext context) {
    final String value = ref.watch(helloWorldProvider);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              Row(
                children: [
                  TextButton(onPressed: () {}, child: const Text("Import")),
                  IconButton(
                      onPressed: () {
                        StudentModel newStudent = StudentModel(
                            email: 'student1@gmail.com',
                            password: '123123123',
                            idCode: '1234567');

                        addStudent(newStudent);
                      },
                      icon: const Icon(Icons.group_add_outlined)),
                ],
              )
            ],
          ),
          Expanded(
              child: ListView(
            children: [
              Card(
                child: ListTile(
                  onTap: () {},
                  leading: Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  title: SizedBox(
                    width: 200,
                    child: Row(
                      children: const [
                        StudentActionButton(),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                    onTap: () {},
                    leading: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    title: Row(
                      children: const [
                        CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/profile_pic.png"),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text("Jane Doe")
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_outlined),
                    )),
              )
            ],
          ))
        ],
      ),
    );
  }
}
