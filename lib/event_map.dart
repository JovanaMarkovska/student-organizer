import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application_bloc.dart';
import 'map.dart';

class EventMaps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      // child: MaterialApp(
      //   home: HomeScreen(),
      // ),
      child: HomeScreen(),

    );
  }
}
