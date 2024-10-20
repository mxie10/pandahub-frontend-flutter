import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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
  bool? _showErrorMessage;
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
    _selectedEventType = 'Conference';
    _errorMessage = '';
    _showErrorMessage = false;
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

  void onCreateEvent() {
    if (_formKey.currentState!.validate()) {
      try {
        final dateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        Map<String, dynamic> map = {};
        map['id'] = uuid.v4();
        map['title'] = _titleController.text.trim();
        map['description'] = _descriptionController.text.trim();
        map['date'] = Timestamp.fromDate(dateTime);
        map['location'] = _locationController.text.trim();
        map['organizer'] = _organizerController.text.trim();
        map['eventType'] = _selectedEventType;

        Provider.of<EventStore>(context, listen: false).addEvent(map);
        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (e) {
        setState(() {
          _showErrorMessage = true;
          _errorMessage = 'Add event failed, please try again later!';
        });
        rethrow;
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showErrorMessage == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _errorMessage ?? 'Something wrong happened! Please try again later!',
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      });
      _showErrorMessage = false;
    }

    return Scaffold(
      appBar: AppBar(title: const StyledTitle('Create Event')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DateTimePicker(
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  dateController: _dateController,
                  timeController: _timeController,
                  onDateChanged: _onDateChanged,
                  onTimeChanged: _onTimeChanged,
                ),
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
                          return 'Please enter event title';
                        }
                        return null;
                      },
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
                          style: const TextStyle(color: Colors.white, fontSize: 14),
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
                // Create button
                SizedBox(
                  width: 500,
                  child: FilledButton(
                    onPressed: onCreateEvent,
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
