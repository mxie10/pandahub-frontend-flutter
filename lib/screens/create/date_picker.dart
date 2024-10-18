import 'package:flutter/material.dart';
import 'package:pandahubfrontend/shared/styled_text_field.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;

  const DateTimePicker({
    super.key,
    this.selectedDate,
    this.selectedTime,
    required this.dateController,
    required this.timeController,
    required this.onDateChanged,
    required this.onTimeChanged
  });

  @override
  // ignore: library_private_types_in_public_api
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime? _selectedDate;
  late TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _selectedTime = widget.selectedTime ?? TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateChanged(pickedDate);
      _updateDateInTextField();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      widget.onTimeChanged(pickedTime);
      _updateTimeInTextField();
    }
  }

  void _updateDateInTextField() {
    widget.dateController.text =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
  }

  void _updateTimeInTextField() {
    widget.timeController.text = "${_selectedTime!.hour.toString()} : ${(_selectedTime!.minute.toString())}";
  }

  @override
  void dispose() {
    // Dispose of the controller when no longer needed
    widget.dateController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledTextField(
          textFieldcontroller: widget.dateController,
          labelText: 'Pick up a date',
          icon:  const Icon(Icons.calendar_month),
          onPress: () => _selectDate(context)
        ),
        const SizedBox(height: 10),
        StyledTextField(
          textFieldcontroller: widget.timeController,
          labelText: 'Pick up a time',
          icon:  const Icon(Icons.timelapse),
          onPress: () => _selectTime(context)
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
