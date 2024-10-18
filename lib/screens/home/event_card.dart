import 'package:flutter/material.dart';
import 'package:pandahubfrontend/models/event.dart';
import 'package:pandahubfrontend/shared/styled_heading.dart';
import 'package:pandahubfrontend/shared/styled_text.dart';
import 'package:pandahubfrontend/theme.dart';

class EventCard extends StatelessWidget {
  const EventCard(this.event, {super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledHeading(event.title),
                StyledText(event.date)
              ],
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: (){}, 
              icon: Icon(Icons.arrow_forward, color: AppColors.textColor)
            )
          ],
        ),
      )
    );
  }
}