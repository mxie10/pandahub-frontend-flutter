import 'package:flutter/material.dart';
import 'package:pandahubfrontend/screens/create/date_picker.dart';
import 'package:pandahubfrontend/shared/styled_text_field.dart';
import 'package:pandahubfrontend/shared/styled_title.dart';

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
              DateTimePicker(
                initialDate: _selectedDate,
                initialTime: _selectedTime,
                dateController: _dateController,
                timeController: _timeController,
              ),
              ...statsAsFormattedList.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StyledTextField(
                    textFieldcontroller: item['controller'],
                    labelText: item['title'],
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
              FilledButton(onPressed: (){
                print(_descriptionController.text);
              }, 
                child: const Text('test')
              )
            ],
          ),
        ),
      ),
    );
  }
}
