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

  // Future<void> fetchEvents() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       List<Event> events = jsonData.map((eventJson) {
  //         String id = eventJson['id'] ?? '';
  //         return Event.fromJson(id, eventJson);
  //       }).toList();
  //       _events = events;
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load events');
  //     }
  //   } catch (error) {
  //     print('Error: ${error}');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
