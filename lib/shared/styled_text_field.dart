import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    required this.textFieldcontroller,
    required this.labelText,
    this.icon, 
    this.onPress, 
    this.defaultValue,
  });
  
  final TextEditingController textFieldcontroller;
  final String labelText;
  final Icon? icon; 
  final VoidCallback? onPress; 
  final String? defaultValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: textFieldcontroller,
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
