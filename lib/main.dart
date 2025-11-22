import 'package:flutter/material.dart';
import 'features/select_type/ui/select_type_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mercypharma',
      showSemanticsDebugger: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: SelectTypeScreen(),
    );
  }
}

