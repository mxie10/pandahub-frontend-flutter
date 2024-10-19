import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pandahubfrontend/models/event.dart';

class EventStore extends ChangeNotifier {
  List<dynamic> _events = [];
  bool _isLoading = false;

  List<dynamic> get events => _events;
  bool get isLoading => _isLoading;

  final url = 'https://api-zh73dsuc2a-uc.a.run.app/api/events';

  EventStore() {
    fetchEvents();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // This ensures the UI is updated when the loading state changes
  }

  // Fetch events
  void fetchEvents() {
    _setLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('events')
          .snapshots()
          .listen((snapshot) {
        _events = snapshot.docs.map((doc) {
          final data = doc.data();
          return Event.fromJson(doc.id, data);
        }).toList();
        notifyListeners();
      });
    } finally {
      _setLoading(false);
    }
  }

  // Add event
  Future<void> addEvent(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': data['id'],
          'title': data['title'],
          'description': data['description'],
          'location': data['location'],
          'organizer': data['organizer'],
          'eventType': data['eventType'],
          'date': data['date'],
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        // Handle error
        print('Failed to add event: ${response.body}');
      }
    } finally {
      _setLoading(false);
    }
  }

  // Update event
  Future<void> updateEvent(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final response = await http.put(
        Uri.parse(
            '$url/${data['id']}'), // Assuming the URL includes the event ID
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': data['id'],
          'title': data['title'],
          'description': data['description'],
          'location': data['location'],
          'organizer': data['organizer'],
          'eventType': data['eventType'],
          'date': data['date'],
        }),
      );

      if (response.statusCode == 200) {
        notifyListeners(); 
      } else {
        // Handle error
        print('Failed to update event: ${response.body}');
      }
    } finally {
      _setLoading(false);
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    _setLoading(true);
    try {
      final response = await http.delete(
        Uri.parse('$url/$eventId'), 
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _events.removeWhere((event) => event.id == eventId);
        notifyListeners(); 
      } else {
        print('Failed to delete event: ${response.body}');
      }
    } finally {
      _setLoading(false);
    }
  }
}
