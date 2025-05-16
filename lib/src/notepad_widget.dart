import 'package:flutter/material.dart';

import 'cover_widget.dart';
import 'header_widget.dart';
import 'notepad_paper.dart';

class NotepadWidget extends StatefulWidget {
  const NotepadWidget({
    super.key,
    this.width = 350.0,
    this.height = 500,
    this.backgroundColor = const Color(0xFFFFECB3),
    required this.children,
    this.cutoffForward = 0.8,
    this.cutoffBackward = 0.8,
    // this.onFlipStart,
    // this.onFlippedEnd,
    this.headerHeight = 30,
    this.headerColor = const Color(0xff040f63),
    this.duration = const Duration(milliseconds: 450),
  });

  final double width;
  final double height;
  final Color backgroundColor;
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
  int notepadIndex = 0; 
  List<Widget> pages = [];
  final List<AnimationController> _controllers = []; // 각 페이지의 애니메이션 컨트롤러
  bool? _isForward;

  @override
  void didUpdateWidget(covariant NotepadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 전역 변수 초기화
    imageData = {};
    currentPage = ValueNotifier(-1);
    currentPageIndex = ValueNotifier(0);

    // 페이지 세팅
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
        key: Key("Page$i"),
        backgroundColor: widget.backgroundColor,
        child: widget.children[i],
      );
      pages.add(page);
    }
    pages = pages.reversed.toList();
  }

  bool get isFirstPage => notepadIndex == 0;
  bool get isLastPage => notepadIndex == pages.length - 1;

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints dimens) {
    currentPage.value = notepadIndex;
    final ratio = details.delta.dy / dimens.maxHeight;

    // 페이지 이동 방향 결정
    if (_isForward == null) {
      if (details.delta.dy < 0) {
        _isForward = true;
      } else {
        _isForward = false;
      }
    }
    // 컨트롤러에 드래그 전달
    _controllers[notepadIndex].value += ratio;
  }

  Future<void> _onDragFinish() async {
    if (_isForward != null) {
      if (_isForward == true && !isLastPage) {
        // Go Next Page
        currentPage.value = notepadIndex; // 애니메이션 타겟 설정
        await _controllers[notepadIndex].reverse();
        if (mounted) {
          setState(() => notepadIndex++);
          if (notepadIndex < pages.length) {
            currentPageIndex.value = notepadIndex; //위젯 인덱스 업데이트
          }
        }
        currentPage.value = -1; // 애니메이션 종료
      } else if (_isForward == false && !isFirstPage) {
        // Go Previous Page
        currentPage.value = notepadIndex - 1;
        await _controllers[notepadIndex - 1].forward();
        if (mounted) {
          setState(() => notepadIndex--);
          currentPageIndex.value = notepadIndex; //위젯 인덱스 업데이트
        }
        currentPage.value = -1; // 애니메이션 종료
      }
    } else {
    // 페이지 이동 없을 시 이전 상태로 복원
    }

    // 드래그 변수 초기화
    _isForward = null;
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
                onVerticalDragUpdate: (details) =>
                    _onDragUpdate(details, dimens),
                onVerticalDragEnd: (details) => _onDragFinish(),
                onVerticalDragCancel: () => _isForward = null,
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
