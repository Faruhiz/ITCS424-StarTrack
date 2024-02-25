import 'package:flutter/material.dart';
import 'package:startrack/pages/loginPage.dart';
import 'package:startrack/pages/newsEventPage.dart';

void main() {
  runApp(const StarTrackApp());
}

class StarTrackApp extends StatelessWidget {
  const StarTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/newsEvent': (context) => const NewsEvents(),
      },
    );
  }
}
