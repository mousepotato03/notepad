import 'package:flutter/material.dart';

class NotepadPaper extends StatefulWidget {
  const NotepadPaper({
    super.key,
    required this.dragAmount,
    required this.child,
    required this.pageIndex,
    required this.currentPageNotifier,
  });

  final Animation<double> dragAmount;
  final Widget child;
  final int pageIndex;
  final ValueNotifier<int> currentPageNotifier;

  @override
  State<NotepadPaper> createState() => _NotepadPaperState();
}

class _NotepadPaperState extends State<NotepadPaper> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentPageNotifier,
      builder: (context, currentPage, child) {
        if (widget.pageIndex == currentPage ||
            widget.pageIndex == currentPage + 1) {
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
        } else {
          // 다른 페이지는 빈 컨테이너로 표시
          return Container();
        }
      },
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
