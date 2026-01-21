import 'package:flutter/material.dart';

class WheelSelector extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const WheelSelector({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<WheelSelector> createState() => _WheelSelectorState();
}

class _WheelSelectorState extends State<WheelSelector> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.value - widget.min,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView(
              controller: _controller,
              itemExtent: 50,
              onSelectedItemChanged: (index) {
                widget.onChanged(index + widget.min);
              },
              physics: const FixedExtentScrollPhysics(),
              children: List.generate(widget.max - widget.min + 1, (index) {
                final int itemValue = index + widget.min;
                final bool isSelected = itemValue == widget.value;
                return RotatedBox(
                  quarterTurns: 1,
                  child: Center(
                    child: Text(
                      itemValue.toString(),
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 20,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: -4,
            child: Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
