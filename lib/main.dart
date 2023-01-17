import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Smart Notification System'),
            backgroundColor: Colors.grey,
          ),
          body: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                          width: 380.0,
                          height: 100.0,
                          // ignore: unnecessary_const
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              'Weather',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )))),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                          width: 380.0,
                          height: 100.0,
                          // ignore: unnecessary_const
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              'Meetings',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )))),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                          width: 380.0,
                          height: 100.0,
                          // ignore: unnecessary_const
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              'Team',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )))),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                          width: 380.0,
                          height: 100.0,
                          // ignore: unnecessary_const
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              'Traffic',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )))),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                          width: 380.0,
                          height: 100.0,
                          // ignore: unnecessary_const
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              'Office',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )))),
            ],
          )),
    );
  }
}
