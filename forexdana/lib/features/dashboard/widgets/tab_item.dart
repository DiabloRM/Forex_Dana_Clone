import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  const TabItem({required this.label, this.isActive = false, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? Colors.black : Colors.grey,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
    );
  }
}
