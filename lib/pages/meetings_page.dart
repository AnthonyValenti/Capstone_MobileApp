import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
              style: style, onPressed: () {}, child: const Text('Add')),
          const SizedBox(
            width: 70,
          ),
          ElevatedButton(
              style: style, onPressed: () {}, child: const Text('Edit')),
        ]),
      ],
    ));
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
