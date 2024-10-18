import 'package:flutter/material.dart';
import 'package:pandahubfrontend/screens/create/date_picker.dart';
import 'package:pandahubfrontend/screens/home/home.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:pandahubfrontend/shared/styled_text_field.dart';
import 'package:pandahubfrontend/shared/styled_title.dart';
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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _organizerController;

  String? _selectedEventType;
  String? _combinedDateTime;

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

  void onCreateEvent(){
    Map<String, dynamic> map = {};
    map['id'] = uuid.v4();
    map['title'] = _titleController.text;
    map['description'] = _descriptionController.text;
    map['date'] = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute).toString();
    map['location'] = _locationController.text;
    map['organizer'] = _organizerController.text;
    map['eventType'] = _selectedEventType;

    Provider.of<EventStore>(context, listen: false).addEvent(map);
     Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Home()));
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
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
    return Scaffold(
      appBar: AppBar(title: const StyledTitle('Create Event')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Date time picker
              DateTimePicker(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                dateController: _dateController,
                timeController: _timeController,
                onDateChanged: _onDateChanged,
                onTimeChanged: _onTimeChanged
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
                      fontSize: 14
                    ), 
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEventType = newValue;
                    });
                  },
                  items: eventTypeList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14
                        ), 
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0), // Rounded corners
                      borderSide: const BorderSide(color: Colors.grey), // Border color when enabled
                    ),
                  ),
                  dropdownColor: Colors.black,
                ),
              ),
              // Create button
              FilledButton(onPressed: (){
                onCreateEvent();
              }, 
                child: const Text('Create')
              )
            ],
          ),
        ),
      ),
    );
  }
}
