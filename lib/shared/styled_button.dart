import 'package:flutter/material.dart';
import 'package:pandahubfrontend/theme.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
      super.key,
      required this.onPressed,
      required this.child
  });

  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
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
