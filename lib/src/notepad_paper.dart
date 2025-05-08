import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Map<int, ui.Image?> imageData = {}; //캡쳐된 이미지 저장
/// 현재 페이지 넘김 애니메이션이 진행 중인 페이지의 인덱스.
///
/// - 페이지 넘김이 **비활성화**된 경우: `-1`
/// - 특정 페이지에서 애니메이션이 **진행 중**인 경우: `>=0`
ValueNotifier<int> flippingPageIndex = ValueNotifier(-1);

/// 애니메이션 완료 후 렌더링될 페이지의 인덱스
ValueNotifier<int> visiblePageIndex = ValueNotifier(0);

class NotepadPaper extends StatefulWidget {
  const NotepadPaper({
    super.key,
    required this.swipeAmount,
    required this.child,
  });

  final Animation<double> swipeAmount;
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
