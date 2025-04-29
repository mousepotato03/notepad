import 'package:flutter/material.dart';

class NotepadCover extends StatelessWidget {
  const NotepadCover({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xed93602a),
      ),
    );
  }
}
