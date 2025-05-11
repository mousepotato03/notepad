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
              TestPage1(),
              TestPage2(),
              TestPage3(),
            ],
          ),
        ),
      ),
    );
  }
}

class TestPage1 extends StatelessWidget {
  const TestPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Page1",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
        ),
      ),
    );
  }
}

class TestPage2 extends StatelessWidget {
  const TestPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Page2",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
        ),
      ),
    );
  }
}

class TestPage3 extends StatelessWidget {
  const TestPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Page3",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
        ),
      ),
    );
  }
}
