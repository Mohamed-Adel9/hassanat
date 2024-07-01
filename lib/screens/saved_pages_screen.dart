import 'package:flutter/material.dart';

class SavedPagesScreen extends StatefulWidget {
  const SavedPagesScreen({super.key});

  @override
  State<SavedPagesScreen> createState() => _SavedPagesScreenState();

}

class _SavedPagesScreenState extends State<SavedPagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index) {
        return const Row(children: [
          Text("data"),
        ],);
      },),
    );
  }
}
