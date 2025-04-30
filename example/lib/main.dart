import 'package:flutter/material.dart';
import 'package:notepad/notepad.dart';

void main() {
  runApp(const NotePadTestApp());
}

class NotePadTestApp extends StatelessWidget {
  const NotePadTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter Memo Notepad Widget",
      home: Scaffold(
        body: Center(
          child: NotepadWidget(
            children: [
              TestPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: 100,
      height: 100,
      child: const Text("hello"),
    );
  }
}
