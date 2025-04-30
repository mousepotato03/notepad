import 'package:flutter/material.dart';

import 'builders/notepad_paper.dart';
import 'utils/cover_widget.dart';

class NotepadWidget extends StatefulWidget {
  const NotepadWidget({
    super.key,
    this.width = 350.0,
    this.height = 500,
    required this.children,
    this.cutoffForward = 0.8,
    this.cutoffBackward = 0.1,
    this.headerHeight = 30,
    this.headerColor = const Color(0xff040f63),
  });

  final double width;
  final double height;
  final List<Widget> children;
  final double cutoffForward;
  final double cutoffBackward;

  //Header
  final double headerHeight;
  final Color headerColor;

  @override
  State<NotepadWidget> createState() => _NotepadWidgetState();
}

class _NotepadWidgetState extends State<NotepadWidget> {
  List<Widget> pages = [];

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
    pages.clear();
    for (var i = 0; i < widget.children.length; i++) {
      final child = NotepadPaper(child: widget.children[i]);
      pages.add(child);
    }
    pages = pages.reversed.toList(); //첫 번째 페이지가 가장 먼저 보이도록 함.
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
          buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, dimens) => GestureDetector(
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

  //Notepad Header
  Widget buildHeader() {
    return Container(
      width: widget.width,
      height: widget.headerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.headerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
