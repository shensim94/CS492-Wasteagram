import 'package:flutter/material.dart';
import 'screens/post_entries.dart';

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wasteagram',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PostEntries()
    );
  }
}