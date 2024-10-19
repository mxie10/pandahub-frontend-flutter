import 'package:flutter/material.dart';
import 'package:pandahubfrontend/screens/create/create.dart';
import 'package:pandahubfrontend/screens/home/event_card.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:provider/provider.dart';

const List<String> list = <String>['All', 'Conference', 'Workshop', 'Webinar'];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = 'All';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventStore>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Events List')),
      body: Column(
        children: [
          // Dropdown button used for filter events
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                  Provider.of<EventStore>(context, listen: false).filterByEventType(dropdownValue);
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
            ),
          ),
          if (eventProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if(eventProvider.events.isEmpty)
            const Expanded(
              child: Center(child: Text('You don''t have any events now'))
            )
          else
            // Event list
            Expanded(
              child: Consumer<EventStore>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: eventProvider.events.length,
                    itemBuilder: (context, index) {
                      final event = eventProvider.events[index];
                      return EventCard(event);
                    },
                  );
                },
              ),
            ),
        ],
      ),
      // Add button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const CreateScreen()));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
