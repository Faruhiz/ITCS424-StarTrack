// ignore_for_file: prefer_const_constructors, prefer_final_fields, file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:startrack/structModel/newsEvent.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: NewsEvents()));
}

class NewsEvents extends StatefulWidget {
  const NewsEvents({super.key});

  @override
  State<NewsEvents> createState() => _NewsEventsState();
}

class _NewsEventsState extends State<NewsEvents> {
  late List<NewsEvent> _newsData = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Honkai: Star Rail News & Events'),
            backgroundColor: Color(0xFF3366FF),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: FutureBuilder<List<NewsEvent>>(
              future: getEventsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No news events available.');
                } else {
                  return ListView.builder(
                    itemCount: _newsData.length,
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
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Details:',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  // SizedBox(height: 8.0),
                                  Text(
                                    snapshot.data![index].description,
                                    // textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Image(
                                    image: NetworkImage(
                                        snapshot.data![index].banner),
                                    height: 400,
                                    width: 400,
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
        ));
  }

  Future<List<NewsEvent>> getEventsData() async {
    final res =
        await http.get(Uri.parse('https://api.ennead.cc/starrail/news/events'));
    var data = jsonDecode(res.body.toString());

    if (res.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        _newsData.add(NewsEvent.fromJson(i));
      }
      return _newsData;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
