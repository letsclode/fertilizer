import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/job_entries_screen/classpage/widgets/button_dropdoown.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Row(
            children: const [
              CustomButtonTest(),
            ],
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Lesson 1"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Lesson 2"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Lesson 3"),
            ),
          )
        ],
      ),
    );
  }
}
