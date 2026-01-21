import 'package:flutter/material.dart';

class ResultColumn extends StatelessWidget {
  const ResultColumn({
    super.key,
    required this.title,
    required this.value,
    this.explanation,
  });

  final String title;
  final String value;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final Widget child = Text(
      title.toUpperCase(),
      style: TextTheme.of(context).titleMedium?.copyWith(letterSpacing: 1.1),
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (explanation != null) ...[
                    Tooltip(
                      message: explanation!,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      child: child,
                    ),
                  ] else
                    child,
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white12, thickness: 1),
      ],
    );
  }
}
