import 'package:flutter/material.dart';
import 'package:pandahubfrontend/screens/create/create.dart';
import 'package:pandahubfrontend/screens/home/event_card.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
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
          if (eventProvider.isLoading) 
            const Center(child: CircularProgressIndicator())
          else 
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CreateScreen()));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
