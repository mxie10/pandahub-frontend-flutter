import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pandahubfrontend/models/event.dart';
import 'package:pandahubfrontend/screens/create/date_picker.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:pandahubfrontend/shared/styled_title.dart';
import 'package:pandahubfrontend/utils/dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

const List<String> eventTypeList = <String>[
  'Conference',
  'Workshop',
  'Webinar',
];

class DetailsScreen extends StatefulWidget {
  final Event event;

  const DetailsScreen({super.key, required this.event});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();

  String? _selectedEventType;
  late bool _showErrorMessage;
  String? _errorMessage;

  List<Map<String, dynamic>> get statsAsFormattedList => [
        {"title": 'Event title', 'controller': _titleController},
        {"title": 'Event description', 'controller': _descriptionController},
        {"title": 'Event location', 'controller': _locationController},
        {"title": 'Event organizer', 'controller': _organizerController},
      ];

  @override
  void initState() {
    super.initState();
    final eventDateTime = widget.event.date.toDate().toLocal();
    _selectedDate = eventDateTime;
    _selectedTime = TimeOfDay.fromDateTime(eventDateTime);
    _dateController.text = DateFormat('yyyy-MM-dd').format(eventDateTime);
    _timeController.text = DateFormat('HH:mm').format(eventDateTime);
    _titleController.text = widget.event.title;
    _descriptionController.text = widget.event.description;
    _locationController.text = widget.event.location;
    _organizerController.text = widget.event.organizer;
    _selectedEventType = widget.event.eventType;
    _showErrorMessage = false;
    _errorMessage = '';
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void onUpdateEvent() {
    if(_dateController.text.isEmpty || _timeController.text.isEmpty){
      showCustomDialog(context, 'Oops! Some fields are missing!',
          'Event date and event time are needed!');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      showCustomDialog(
        context, 
        'Oops! Some fields are missing!',
        'Please fill out all required fields.',
      );
      return;
    }

    try {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      Map<String, dynamic> map = {
        'id': widget.event.id,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': Timestamp.fromDate(dateTime),
        'location': _locationController.text.trim(),
        'organizer': _organizerController.text.trim(),
        'eventType': _selectedEventType,
      };

      Provider.of<EventStore>(context, listen: false).updateEvent(map);
      
      showCustomDialog(
        context, 
        'Success!',
        'The event has been successfully updated!',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Update event failed, please try again later';
        _showErrorMessage = true;
      });
      rethrow;
    }
  }

  void onDeleteEvent() {
    try {
      Provider.of<EventStore>(context, listen: false).deleteEvent(widget.event.id);
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      setState(() {
        _errorMessage = 'Delete event failed, please try again later';
        _showErrorMessage = true;
      });
      rethrow;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showErrorMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _errorMessage ?? 'Something went wrong! Please try again later!',
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      });
      _showErrorMessage = false;
    }

    return Scaffold(
      appBar: AppBar(title: const StyledTitle('Event Details')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Date time picker
                    DateTimePicker(
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      dateController: _dateController,
                      timeController: _timeController,
                      onDateChanged: _onDateChanged,
                      onTimeChanged: _onTimeChanged,
                    ),
                    // Form fields
                    ...statsAsFormattedList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: item['controller'],
                          decoration: InputDecoration(
                            labelText: item['title'],
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(color:Colors.white),
                          validator: (value) {
                            if (item['title'] == 'Event title' && (value == null || value.isEmpty)) {
                              return 'Please enter ${item['title']}';
                            }
                            if (item['title'] == 'Event date' && (value == null || value.isEmpty)) {
                              return 'Please enter ${item['title']}';
                            }
                            if (item['title'] == 'Event time' && (value == null || value.isEmpty)) {
                              return 'Please enter ${item['title']}';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                    // Dropdown for event types
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DropdownButtonFormField<String>(
                        value: _selectedEventType,
                        hint: const Text(
                          'Select Event Type',
                          style: TextStyle(
                            color: Color.fromARGB(255, 133, 131, 131),
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedEventType = newValue;
                          });
                        },
                        items: eventTypeList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        dropdownColor: Colors.black,
                      ),
                    ),
                    // Update button
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 500,
                      child: FilledButton(
                        onPressed: onUpdateEvent,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 2, 17, 56),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 500,
                  child: FilledButton(
                    onPressed: onDeleteEvent,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
