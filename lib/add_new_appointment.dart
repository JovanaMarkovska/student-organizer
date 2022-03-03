import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_organizer/appointments_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Create a Form widget.
class AppointmentForm extends StatefulWidget {
  const AppointmentForm({required this.appointments});
  final List<Appointment> appointments;

  @override
  AppointmentFormState createState() {
    return AppointmentFormState(appointments);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AppointmentFormState extends State<AppointmentForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final myController = TextEditingController();
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final List<Appointment> appointments;
  // final List<Appointment> appointments;

  String subject = "";
  String date = "";
  String time = "";
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  AppointmentFormState(this.appointments);

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  addExamToList(Appointment appointment) {
    setState(() {
      appointments.add(appointment);
      Navigator.pop(context);
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: myController,
            onFieldSubmitted: (value) {
              subject = value;
            },
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Text(
            "Selected date: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text("Select date"),
          ),
          Text(
            'Selected time: ${_time.format(context)}',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          ElevatedButton(
            onPressed: _selectTime,
            child: Text('Select time'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  setState(() {
                    subject = myController.text;
                    date = selectedDate.day.toString() +
                        "." +
                        selectedDate.month.toString() +
                        "." +
                        selectedDate.year.toString();
                    time = _time.format(context).toString();
                  });
                  //addExamToList(Exam(name: name,date: date,time: time,dateTime: DateTime.parse('2022-05-10 13:00')));
                  addExamToList(Appointment(
                    startTime: DateTime(selectedDate.year, selectedDate.month,
                        selectedDate.day, _time.hour),
                    endTime: DateTime(selectedDate.year, selectedDate.month,
                        selectedDate.day, _time.hour + 2),
                    subject: subject,
                    startTimeZone: '',
                    endTimeZone: '',
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new AppointmentList(
                            title: 'Student Organizer',
                            appointments: appointments)),
                  );

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AppointmentList(title:'kurac',appointments: appointments)));

                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    ));
  }
}
