import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.onTap,
    this.title,
    this.iconData,
    this.child,
    this.height,
  }) : assert(child != null || (title != null && iconData != null));

  final VoidCallback onTap;
  final String? title;
  final IconData? iconData;
  final Widget? child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: height ?? 178,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(25),
          ),
          child:
              child ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconData, size: 50, color: Colors.white),
                  const SizedBox(height: 15),
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextTheme.of(
                      context,
                    ).titleLarge?.copyWith(fontSize: 16),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
