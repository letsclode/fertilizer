import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Table(
        border: TableBorder.all(color: Colors.grey, width: 0.5),
        children: const [
          TableRow(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Names",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lesson 1",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lesson 2",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ]),
          TableRow(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Jane Doe",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "80",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "90",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ]),
          TableRow(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "John Doe",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "80",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "80",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
