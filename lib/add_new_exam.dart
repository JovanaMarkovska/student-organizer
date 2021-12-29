import 'package:flutter/material.dart';

import 'exam.dart';
import 'main.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({required this.exams});
  final List<Exam> exams;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(exams);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final myController = TextEditingController();
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final List<Exam> exams;

  String name="";
  String date="";
  String time="";
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  MyCustomFormState(this.exams);

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }
  addExamToList(Exam exam){
    exams.add(exam);
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: myController,
                onFieldSubmitted: (value) {
                  name = value;
                },
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text(myController.text),
              Text("Selected date: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}"),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text("Select date"),
              ),
              Text(
                'Selected time: ${_time.format(context)}',
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
                        name = myController.text;
                        date = selectedDate.day.toString()+"."+selectedDate.month.toString()+"."+selectedDate.year.toString();
                        time = _time.format(context).toString();
                      });
                      addExamToList(Exam(name: name,date: date,time: time));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => MyHomePage(
                          exams: exams, title: 'Student Organizer',
                      )));

                    }

                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        )
    );

  }
}