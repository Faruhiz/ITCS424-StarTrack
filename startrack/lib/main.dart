import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class NewsEvent {
  final String id;
  final String banner;
  final int createdAt;
  final String description;
  final int endAt;
  final int startAt;
  final String title;
  final String url;

  const NewsEvent(
      {required this.id,
      required this.banner,
      required this.createdAt,
      required this.description,
      required this.endAt,
      required this.startAt,
      required this.title,
      required this.url});

  factory NewsEvent.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": String id,
        "banner": String banner,
        "createdAt": int createdAt,
        "description": String description,
        "endAt": int endAt,
        "startAt": int startAt,
        "title": String title,
        "url": String url,
      } =>
        NewsEvent(
            id: id,
            banner: banner,
            createdAt: createdAt,
            description: description,
            endAt: endAt,
            startAt: startAt,
            title: title,
            url: url),
      _ => throw const FormatException('FAILED TO LOAD EVENTS'),
    };
  }
}

Future<NewsEvent> fetchEvents() async {
  final res =
      await http.get(Uri.parse('https://api.ennead.cc/starrail/news/events'));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return NewsEvent.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => NewsEventsPage();

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Honkai: Star Rail News & Events',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //       fontFamily: 'Roboto', // Use a modern font
  //     ),
  //     home: NewsEventsPage(),
  //   );
  // }
}

class NewsEventsPage extends State<MyApp> {
  late Future<NewsEvent> newsEvents;

  @override
  void initState() {
    super.initState();
    newsEvents = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Honkai: Star Rail News & Events'),
        backgroundColor: Color(0xFF3366FF),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<NewsEvent>(
          future: newsEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No news events available.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Color(0xFFEFEFEF),
                    child: ExpansionTile(
                      title: Text(
                        snapshot.data![index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data![index].date,
                        style: TextStyle(
                          color: Color(0xFF666666),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Details:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snapshot.data![index].content,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(57, 52, 55, 100),
    );
  }
}
