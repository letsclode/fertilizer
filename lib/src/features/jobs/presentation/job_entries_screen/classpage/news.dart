import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Create Post"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Post 1"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Post 2"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {},
              title: const Text("Post 3"),
            ),
          )
        ],
      ),
    );
  }
}
