import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pandahubfrontend/models/event.dart';

class EventStore extends ChangeNotifier {
  List<dynamic> _events = [];
  List<dynamic> _allEvents = [];
  bool _isLoading = false;

  List<dynamic> get events => _events;
  bool get isLoading => _isLoading;

  final url = dotenv.env['API_URL'] ?? '';

  EventStore() {
    fetchEvents();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); 
  }

// Fetch events
  void fetchEvents() {
    _setLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('events')
          .snapshots()
          .listen((snapshot) {
        _allEvents = snapshot.docs.map((doc) {
          final data = doc.data();
          return Event.fromJson(doc.id, data);
        }).toList();
        _events = List.from(_allEvents); 
        notifyListeners();
      });
    }catch (e) {
      rethrow;
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
      } 
    }catch(e){
      rethrow;
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
            '$url/${data['id']}'), 
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
      }
    }catch(e){
      rethrow;
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
      }
    }catch(e){
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Filter by event type
  void filterByEventType(String eventType) {
    if (eventType == 'All') {
      _events = List.from(_allEvents); 
    } else {
      _events = _allEvents.where((event) => event.eventType == eventType).toList();
    }
    notifyListeners(); 
  }
}
