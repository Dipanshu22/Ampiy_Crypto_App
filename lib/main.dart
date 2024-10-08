import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ampiy App Redesign',
      theme: ThemeData(
        brightness: Brightness.light, // Light theme
        primaryColor: Colors.deepPurple, // Primary accent color
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Default text color for light mode
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        primaryColor: Colors.deepPurple, // Primary accent color
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Default text color for dark mode
        ),
      ),
      themeMode: ThemeMode.dark, // Set default to dark mode
      home: const MyHomePage(),
    );
  }
}
