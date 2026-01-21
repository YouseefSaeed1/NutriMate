import 'package:flutter/material.dart';

class ScreensCover extends StatelessWidget {
  const ScreensCover({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/covers/wood.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
