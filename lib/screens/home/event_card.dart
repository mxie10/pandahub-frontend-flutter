import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pandahubfrontend/models/event.dart';
import 'package:pandahubfrontend/screens/details/details.dart';
import 'package:pandahubfrontend/shared/styled_heading.dart';
import 'package:pandahubfrontend/shared/styled_text.dart';
import 'package:pandahubfrontend/theme.dart';

class EventCard extends StatelessWidget {
  const EventCard(this.event, {super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => DetailsScreen(event: event)));
      },
      child: Card(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledHeading(event.title), StyledText('${DateFormat('yyyy-MM-dd HH:mm').format(event.date.toDate())}(UTC)')
              ],
            ),
            const Expanded(child: SizedBox()),
            Icon(Icons.arrow_forward, color: AppColors.textColor)
          ],
        ),
      )),
    );
  }
}
