import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'add_new_appointment.dart';
import 'calendar.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList(
      {Key? key, required this.title, required this.appointments})
      : super(key: key);
  final String title;
  final List<Appointment> appointments;
  @override
  AppointmentsListState createState() =>
      AppointmentsListState(title: title, appointments: appointments);
}

class AppointmentsListState extends State<AppointmentList> {
  late final String title;
  final List<Appointment> appointments;
  AppointmentsListState({required this.title, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          new AppointmentForm(appointments: appointments)),
                );
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (contx, index) {
          print(appointments[index].subject);
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      appointments[index].subject,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      appointments[index].startTime.year.toString() +
                          "/" +
                          appointments[index].startTime.month.toString() +
                          '/' +
                          appointments[index].startTime.day.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      appointments[index].startTime.hour.toString() +
                          ":" +
                          appointments[index].startTime.minute.toString() +
                          ':' +
                          appointments[index].startTime.second.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        appointments.remove(appointments[index]);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Calendar(appointments: appointments)),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
