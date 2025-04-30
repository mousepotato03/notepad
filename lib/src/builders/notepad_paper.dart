import 'package:flutter/material.dart';

class NotepadPaper extends StatefulWidget {
  const NotepadPaper({super.key, required this.child});

  final Widget child;

  @override
  State<NotepadPaper> createState() => _NotepadPaperState();
}

class _NotepadPaperState extends State<NotepadPaper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      child: CustomPaint(
        painter: NoteLinePainter(),
        child: Stack(
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }
}

// Notepad Line Style
class NoteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
