import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class VerticalFlipEffect extends CustomPainter {
  const VerticalFlipEffect({
    required this.amount,
    required this.image,
    required this.backgroundColor,
  }): super(repaint: amount);

  final Animation<double> amount;
  final ui.Image image;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 페이지 높이 계산
    double visibleHeight = image.height * amount.value;
    if (visibleHeight <= 0) return;

    // 배경 그리기
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, visibleHeight), backgroundPaint);


    
    final originalAspectRatio = image.width / image.height;
    
    final targetAspectRatio = size.width / size.height;
    
    double targetWidth = size.width;
    double targetHeight = size.height;
    
    if (originalAspectRatio > targetAspectRatio) {
      targetWidth = size.height * originalAspectRatio;
    } else {
      targetHeight = size.width / originalAspectRatio;
    }
    
    final dx = (size.width - targetWidth) / 2;
    final dy = (size.height - targetHeight) / 2;
    
    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble() * amount.value,
    );

    final visibleTargetHeight = targetHeight * amount.value;
    final dstRect = Rect.fromLTWH(
      dx,
      dy,
      targetWidth,
      visibleTargetHeight,
    );
    
    canvas.drawImageRect(image, srcRect, dstRect, paint);
    
    final debugPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(dstRect, debugPaint);
  }

  @override
  bool shouldRepaint(covariant VerticalFlipEffect oldDelegate) {
    return oldDelegate.amount.value != amount.value || 
           oldDelegate.image != image;
  }
}