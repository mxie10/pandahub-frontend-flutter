import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.headlineMedium
    ));
  }
}