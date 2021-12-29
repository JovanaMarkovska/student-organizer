import 'package:flutter/material.dart';
import 'add_new_exam.dart';
import 'exam.dart';

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
      home: MyHomePage(
          title: 'Student Organizer',
          exams: [],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final List<Exam> exams;

  MyHomePage({required this.title, required this.exams});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCustomForm(exams: exams)),
              );
            }
          ),

        ],
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (contx, index){
          print(exams[index].name);
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children : [
                    Text(
                    exams[index].name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    exams[index].date,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey
                    ),
                    textAlign: TextAlign.left,

                  ),
                  Text(
                    exams[index].time,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey
                    ),
                    textAlign: TextAlign.left,

                  ),
            ],
                ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          exams.remove(exams[index]);
                        },
                      ),
                    ),



              ],

            ),


          );
        },
      ),

    );

  }
}


