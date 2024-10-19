import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
      super.key,
      required this.onPressed,
      required this.child,
      this.backgroundColor
  });

  final Function() onPressed;
  final Widget child;
  final WidgetStateProperty<Color?>? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      style: ButtonStyle(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: child
      )
    );
  }
}
