class Event {
  Event(
      {required this.id,
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
  final String date;
  final String location;
  final String organizer;
  final String eventType;
  final String updatedAt;

  factory Event.fromJson(String id, Map<String, dynamic> json) {

    return Event(
        id: id,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: json['date'] ?? '',
        location: json['location'] ?? '',
        organizer: json['organizer'] ?? '',
        eventType: json['eventType'] ?? '',
        updatedAt: json['updatedAt'] ?? ''
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
