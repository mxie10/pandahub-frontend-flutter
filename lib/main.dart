import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pandahubfrontend/firebase_options.dart';
import 'package:pandahubfrontend/screens/home/home.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:pandahubfrontend/theme.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    ChangeNotifierProvider(
      create: (create) => EventStore(),
      child: MaterialApp(
        theme: primaryTheme,
        home: const Home()
        ),
    ));
}

