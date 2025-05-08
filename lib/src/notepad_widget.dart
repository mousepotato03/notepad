import 'package:flutter/material.dart';
import 'package:notepad/utils/custom_debug_print.dart';

import 'cover_widget.dart';
import 'header_widget.dart';
import 'notepad_paper.dart';

class NotepadWidget extends StatefulWidget {
  const NotepadWidget({
    super.key,
    this.width = 350.0,
    this.height = 500,
    required this.children,
    this.cutoffForward = 0.6,
    this.cutoffBackward = 0.2,
    // this.onFlipStart,
    // this.onFlippedEnd,
    this.headerHeight = 30,
    this.headerColor = const Color(0xff040f63),
    this.duration = const Duration(milliseconds: 450),
  });

  final double width;
  final double height;
  final List<Widget> children;
  final double cutoffForward;
  final double cutoffBackward;

  // final void Function()? onFlipStart;
  // final void Function(int currentIndex)? onFlippedEnd;

  // Header
  final double headerHeight;
  final Color headerColor;
  final Duration duration;

  @override
  State<NotepadWidget> createState() => _NotepadWidgetState();
}

class _NotepadWidgetState extends State<NotepadWidget>
    with TickerProviderStateMixin {
  List<Widget> pages = [];
  final List<AnimationController> _controllers = []; // 각 페이지의 애니메이션 컨트롤러
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  void didUpdateWidget(covariant NotepadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _setUp() {
    for (var i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        vsync: this,
        value: 1.0,
        duration: widget.duration,
      );
      _controllers.add(controller);

      final page = NotepadPaper(
        dragAmount: controller,
        pageIndex: i,
        currentPageNotifier: _currentPageNotifier,
        child: widget.children[i],
      );
      pages.add(page);
    }
    pages = pages.reversed.toList();
  }

  bool? _isDraggingUp;
  int notepadIndex = 0;
  double _dragStartY = 0.0; // 드래그 시작 위치
  double _dragDistance = 0.0; // 드래그 거리

  bool get _isFirstPage => notepadIndex == 0;
  bool get _isLastPage => notepadIndex == (pages.length - 1);

  void _onDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _dragDistance = 0.0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragDistance = details.globalPosition.dy - _dragStartY;
    _isDraggingUp = _dragDistance < 0;

    if (_isDraggingUp == true) {
      if (!_isLastPage) {
        _controllers[notepadIndex].value =
            1.0 + (_dragDistance / widget.height);
      }
    } else {
      if (!_isFirstPage) {
        _controllers[notepadIndex - 1].value =
            1.0 - (_dragDistance / widget.height);
      }
    }
  }

  Future _onDragFinish() async {
    if (_isDraggingUp != null) {
      if (_isDraggingUp == true) {
        if (!_isLastPage) {
          if (_controllers[notepadIndex].value <= widget.cutoffForward) {
            await _controllers[notepadIndex]
                .animateTo(0.0, duration: widget.duration);
            setState(() => notepadIndex += 1);
            _currentPageNotifier.value = notepadIndex;
          } else {
            await _controllers[notepadIndex]
                .animateTo(1.0, duration: widget.duration);
          }
        }
      } else {
        if (!_isFirstPage) {
          if (_controllers[notepadIndex - 1].value >= widget.cutoffBackward) {
            await _controllers[notepadIndex - 1]
                .animateTo(1.0, duration: widget.duration);
            setState(() => notepadIndex -= 1);
            _currentPageNotifier.value = notepadIndex;
          } else {
            await _controllers[notepadIndex - 1]
                .animateTo(0.0, duration: widget.duration);
          }
        }
      }
    }
    _isDraggingUp = null;
    infoDebugPrint('Drag Ended');
    infoDebugPrint('currentIndex: $notepadIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(10, 8),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NotepadHeader(
            width: widget.width,
            height: widget.headerHeight,
            color: widget.headerColor,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, dimens) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: (details) => _onDragFinish(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const NotepadCover(),
                    if (pages.isNotEmpty) ...pages else const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
