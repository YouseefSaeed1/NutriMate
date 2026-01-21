import 'package:flutter/material.dart';

Widget scannerActionButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Icon(icon, size: 35, color: Colors.white70),
    ),
  );
}
