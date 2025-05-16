import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'vertical_flip_effect.dart';

Map<int, ui.Image?> imageData = {};
ValueNotifier<int> currentPage = ValueNotifier(-1);
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

class NotepadPaper extends StatefulWidget {
  const NotepadPaper({
    super.key,
    required this.dragAmount,
    required this.child,
    required this.pageIndex,
    required this.backgroundColor,
  });

  final Animation<double> dragAmount;
  final Widget child;
  final int pageIndex;
  final Color backgroundColor;

  @override
  State<NotepadPaper> createState() => _NotepadPaperState();
}

class _NotepadPaperState extends State<NotepadPaper> {
  final GlobalKey _boundaryKey = GlobalKey();

  void _captureImage(Duration timeStamp, int index) async {
    if (_boundaryKey.currentContext == null) return;
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      final boundary = _boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage();
      setState(() {
        imageData[index] = image.clone();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPage,
      builder: (context, currentPage, child) {
        if (imageData[widget.pageIndex] != null && currentPage >= 0) {
          return CustomPaint(
            painter: VerticalFlipEffect(
              amount: widget.dragAmount,
              image: imageData[widget.pageIndex]!,
              backgroundColor: widget.backgroundColor,
            ),
            size: Size.infinite,
          );
        } else {
          if (currentPage == widget.pageIndex ||
              (currentPage == (widget.pageIndex + 1))) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) => _captureImage(timeStamp, currentPageIndex.value),
            );
          }
          if (widget.pageIndex == currentPageIndex.value ||
              widget.pageIndex == currentPageIndex.value + 1) {
            return Container(
              color: widget.backgroundColor,
              child: RepaintBoundary(
                key: _boundaryKey,
                child: CustomPaint(
                  painter: NoteLinePainter(),
                  child: Stack(
                    children: [
                      widget.child,
                    ],
                  ),
                ),
              ),
            );
          } else {
            // 다른 페이지는 빈 컨테이너로 표시
            return Container();
          }
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
