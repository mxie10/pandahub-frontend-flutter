import 'package:flutter/material.dart';
import 'package:pandahubfrontend/screens/create/date_picker.dart';
import 'package:pandahubfrontend/shared/styled_text_field.dart';
import 'package:pandahubfrontend/shared/styled_title.dart';

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
  late final TextEditingController _eventTypeController;

  List<Map<String,dynamic>> get statsAsFormattedList => [
    {"title":'Event title','controller':_titleController},
    {"title":'Event description','controller':_descriptionController},
    {"title":'Event location','controller':_locationController},
    {"title":'Event organizer','controller':_organizerController},
    {"title":'Event type','controller':_eventTypeController},
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
    _eventTypeController = TextEditingController();
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
    _eventTypeController.dispose();
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
                    timeController: _timeController
                  ),
                  ...statsAsFormattedList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: StyledTextField(
                        textFieldcontroller: item['controller'], 
                        labelText: item['title']
                      ),
                    );
                  }).toList(),
                ],
          ))),
    );
  }
}
