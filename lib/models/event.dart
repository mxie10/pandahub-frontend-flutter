import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.eventType,
    required this.updatedAt
  });

  final String id;
  final String title;
  final String description;
  final Timestamp date;
  final String location;
  final String organizer;
  final String eventType;
  final Timestamp updatedAt;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: json['date'] is Timestamp ? json['date'] : Timestamp.now(),
        location: json['location'] ?? '',
        organizer: json['organizer'] ?? '',
        eventType: json['eventType'] ?? '',
        updatedAt: json['updatedAt'] is Timestamp ? json['updatedAt'] : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizer': organizer,
      'eventType': eventType,
      'updatedAt': updatedAt
    };
  }
}
