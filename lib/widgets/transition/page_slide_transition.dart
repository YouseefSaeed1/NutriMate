import 'package:flutter/material.dart';

class PageSlideTransition extends PageRouteBuilder {
  PageSlideTransition({required this.page, required this.left})
    : super(
        pageBuilder: (ctx, animation, secondaryAnimation) => page,
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          final animate = Tween<Offset>(
            begin: left ? const Offset(-1, 0) : const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );
          return SlideTransition(position: animate, child: child);
        },
      );

  final Widget page;
  final bool left;
}
