import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final db = FirebaseFirestore.instance;

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meetings',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.blueGrey.shade500,
        ),
        body: const Events());
  }
}

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventStates();
}

class _EventStates extends State<Events> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      fixedSize: const Size(150, 80),
      backgroundColor: Colors.blueGrey.shade500,
    );
    final ButtonStyle style2 = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      fixedSize: const Size(150, 50),
      backgroundColor: Colors.blueGrey.shade200,
    );
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          color: Colors.grey.shade200,
          height: 620,
          child: SfCalendar(
            dataSource: MeetingDataSource(getMeetings()),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(children: [
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: style,
              onPressed: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  context: context,
                  backgroundColor: Colors.blueGrey.shade500,
                  builder: (BuildContext context) {
                    return Wrap(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                fillColor: Colors.blueGrey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Meeting Name',
                                labelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                fillColor: Colors.blueGrey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Start Time',
                                labelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                fillColor: Colors.blueGrey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'End Time',
                                labelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    )),
                                fillColor: Colors.blueGrey.shade200,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Invite Members',
                                labelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              style: style2,
                              child: const Text('Add'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              style: style2,
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add')),
          const SizedBox(
            width: 70,
          ),
          ElevatedButton(
              style: style, onPressed: () {}, child: const Text('Edit')),
        ]),
      ],
    ));
  }

  Future<void> getDataFromDB() async {
    await db.collection("meetings").get().then((event) {
      for (var doc in event.docs) {
        print(doc.data()['eventName']);
        print(doc.data()['timeStart']);
        print(doc.data()['timeEnd']);
      }
    });
  }
}

List<Meeting> getMeetings() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
