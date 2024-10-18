import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pandahubfrontend/models/event.dart';
import 'package:provider/provider.dart';

class EventStore extends ChangeNotifier {
  List<dynamic> _events = [];
  bool _isLoading = false;

  List<dynamic> get events => _events;
  bool get isLoading => _isLoading;

  final url = 'https://api-zh73dsuc2a-uc.a.run.app/api/events';

  EventStore() {
    fetchEvents();
  }

  // fetch events
  void fetchEvents() {
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
  }

  // add event
  Future<void> addEvent(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id':data['id'],
        'title': data['title'],
        'description': data['description'],
        'location': data['location'],
        'organizer': data['organizer'],
        'eventType': data['eventType'],
        'date': data['date'],
      }),
    );

    if (response.statusCode == 201) {
      fetchEvents(); 
    } else {
      // Handle error
      print('Failed to add event: ${response.body}');
    }
  }
}
