import 'package:flutter/material.dart';
import 'package:pandahubfrontend/models/event.dart';
import 'package:pandahubfrontend/screens/create/date_picker.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:pandahubfrontend/shared/styled_text_field.dart';
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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _organizerController;

  String? _selectedEventType;

  List<Map<String, dynamic>> get statsAsFormattedList => [
        {"title": 'Event title', 'controller': _titleController},
        {"title": 'Event description', 'controller': _descriptionController},
        {"title": 'Event location', 'controller': _locationController},
        {"title": 'Event organizer', 'controller': _organizerController},
      ];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _organizerController = TextEditingController();
    _dateController.text = widget.event.date.split(' ')[0];
    _timeController.text = widget.event.date.split(' ')[1];
    _titleController.text = widget.event.title;
    _descriptionController.text = widget.event.description;
    _locationController.text = widget.event.location;
    _organizerController.text = widget.event.organizer;
    _selectedEventType = widget.event.eventType;
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
    if (_dateController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _titleController.text.trim().isEmpty) {

      showCustomDialog(
        context, 
        'Oops! Some fields are missing!',
        'Event date, time and title are needed!');
      return;
    }

    try {
      Map<String, dynamic> map = {};
      map['id'] = widget.event.id;
      map['title'] = _titleController.text.trim();
      map['description'] = _descriptionController.text.trim();
      map['date'] = '${_dateController.text} ${_timeController.text}';
      map['location'] = _locationController.text.trim();
      map['organizer'] = _organizerController.text.trim();
      map['eventType'] = _selectedEventType;

      Provider.of<EventStore>(context, listen: false).updateEvent(map);
      
      showCustomDialog(
        context, 
        'Success!',
        'The event has been successfully updated!'
      );
    } catch (e) {
      rethrow;
    }
  }

  void onDeleteEvent() {
    try {
      print(widget.event);
      Provider.of<EventStore>(context, listen: false)
          .deleteEvent(widget.event.id);
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const StyledTitle('Event Details')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                  // Rest fields
                  ...statsAsFormattedList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: StyledTextField(
                        textFieldcontroller: item['controller'],
                        labelText: item['title'],
                      ),
                    );
                  }),
                  // Dropdown list for event types
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      value: _selectedEventType,
                      hint: const Text(
                        'Select Event Type',
                        style: TextStyle(
                            color: Color.fromARGB(255, 133, 131, 131),
                            fontSize: 14),
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
                                color: Colors.white, fontSize: 14),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.black,
                    ),
                  ),
                  // Create button
                  SizedBox(
                    width: 500,
                    child: FilledButton(
                      onPressed: onUpdateEvent,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
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
    );
  }
}
