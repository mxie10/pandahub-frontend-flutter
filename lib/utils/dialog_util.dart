import 'package:flutter/material.dart';
import 'package:pandahubfrontend/shared/styled_button.dart';
import 'package:pandahubfrontend/shared/styled_heading.dart';
import 'package:pandahubfrontend/shared/styled_text.dart';
import 'package:pandahubfrontend/theme.dart';

void showCustomDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.secondaryAccent,
        title: StyledHeading(title),
        content: StyledText(content),
        actions: [
          StyledButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const StyledHeading('close'),
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}
