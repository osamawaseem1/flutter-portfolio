import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;
  final String sectionKey;
  final Duration delay;

  const AnimatedSection({
    super.key,
    required this.child,
    required this.sectionKey,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.sectionKey),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.05),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
