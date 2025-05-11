import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Map<int, ui.Image?> imageData = {};
ValueNotifier<int> currentPage = ValueNotifier(-1);
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

class NotepadPaper extends StatefulWidget {
  const NotepadPaper({
    super.key,
    required this.dragAmount,
    required this.child,
    required this.pageIndex,
  });

  final Animation<double> dragAmount;
  final Widget child;
  final int pageIndex;

  @override
  State<NotepadPaper> createState() => _NotepadPaperState();
}

class _NotepadPaperState extends State<NotepadPaper> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (context, currentPage, child) {
        if (widget.pageIndex == currentPageIndex.value ||
            widget.pageIndex == currentPageIndex.value + 1) {
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
