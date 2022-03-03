import 'package:flutter/material.dart';
import 'appointments_list.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppointmentList(appointments: [], title: 'Student Organizer',),
    );
  }
}
