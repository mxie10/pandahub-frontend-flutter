import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    required this.textFieldcontroller,
    required this.labelText,
    this.icon,
    this.onPress,
    this.defaultValue,
    this.isReadOnly = false, // Add default value
  });

  final TextEditingController textFieldcontroller;
  final String labelText;
  final Icon? icon;
  final VoidCallback? onPress;
  final String? defaultValue;
  final bool isReadOnly; // New flag

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: textFieldcontroller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: icon != null
            ? IconButton(
                icon: icon!,
                onPressed: onPress ?? () {},
              )
            : null,
      ),
    );
  }
}
