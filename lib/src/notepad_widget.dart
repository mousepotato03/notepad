import 'package:flutter/material.dart';
import 'package:notepad/src/builders/notepad_paper.dart';

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

  void _setUp() {
    pages.clear();
    for (var i = 0; i < widget.children.length; i++) {
      final child = NotepadPaper(
        width: widget.width,
        height: widget.height,
        child: widget.children[i],
      );
      pages.add(child);
    }
    pages = pages.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(),
          LayoutBuilder(
            builder: (context, dimens) => GestureDetector(
              child: Stack(
                children: [
                  NotepadCover(
                    width: widget.width,
                    height: widget.height,
                  ),
                  if (pages.isNotEmpty) ...pages else const SizedBox.shrink(),
                ],
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
