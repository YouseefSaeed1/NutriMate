import 'package:flutter/material.dart';

class PageFadeTransition extends PageRouteBuilder {
  PageFadeTransition({required this.page})
    : super(
        pageBuilder: (ctx, animation, secondaryAnimation) => page,
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
  final Widget page;
}
