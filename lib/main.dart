/// main.dart 
/// Author: Kevin Xie
/// Date: 2024-10-19
/// Description: Initializes Firebase, loads environment variables, 
/// and sets up the application with a provider for event management.
/// 
/// Features:
/// - Firebase integration
/// - Environment variable management
/// - State management using Provider
/// - Custom theme support
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pandahubfrontend/firebase_options.dart';
import 'package:pandahubfrontend/screens/home/home.dart';
import 'package:pandahubfrontend/services/events_store.dart';
import 'package:pandahubfrontend/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");  
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

