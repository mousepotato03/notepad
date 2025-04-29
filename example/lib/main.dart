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
              Text("ㅎㅇ"),
            ],
          ),
        ),
      ),
    );
  }
}
