import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

final db = FirebaseFirestore.instance;
List<Meeting> meetings = <Meeting>[];

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
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dayTimeStart = TextEditingController();
  TextEditingController dayTimeEnd = TextEditingController();
  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime? pickedDate;
  var timeStart;
  var timeEnd;

  getDataFromDB() async {
    var results = await db.collection("meetings").get();
    if (mounted) {
      setState(() {
        results.docs.forEach((element) {
          meetings.add(Meeting(
            eventName: element['eventName'],
            from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(element['timeStart']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(element['timeEnd']),
            background: Colors.blue,
            isAllDay: false,
          ));
        });
      });
    }
  }

  @override
  void initState() {
    dateController.text = "Select Date";
    dayTimeStart.text = "Set Start Time";
    dayTimeEnd.text = "Set End Time";
    meetings.clear();
    getDataFromDB();
    super.initState();
  }

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
            dataSource: MeetingDataSource(meetings),
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
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
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
                                controller: nameController,
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
                                  labelText: dateController.text,
                                  labelStyle: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2101));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate!);
                                    setState(() {
                                      dateController.text =
                                          formattedDate; //set foratted date to TextField value.
                                    });
                                  }
                                },
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
                                    labelText: dayTimeStart.text,
                                    labelStyle: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    timeStart = await showTimePicker(
                                        context: context,
                                        initialTime: timeOfDay);
                                    if (timeStart != null) {
                                      setState(() {
                                        if (timeStart.hour < 10 &&
                                            timeStart.minute < 10) {
                                          dayTimeStart.text =
                                              "0${timeStart.hour}:0${timeStart.minute}";
                                        }
                                        if (timeStart.hour < 10 &&
                                            timeStart.minute > 10) {
                                          dayTimeStart.text =
                                              "0${timeStart.hour}:${timeStart.minute}";
                                        }
                                        if (timeStart.hour > 10 &&
                                            timeStart.minute < 10) {
                                          dayTimeStart.text =
                                              "${timeStart.hour}:0${timeStart.minute}";
                                        } else {
                                          dayTimeStart.text =
                                              "${timeStart.hour}:${timeStart.minute}";
                                        }
                                      });
                                    }
                                  }),
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
                                    labelText: dayTimeEnd.text,
                                    labelStyle: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    timeEnd = await showTimePicker(
                                        context: context,
                                        initialTime: timeOfDay);
                                    if (timeEnd != null) {
                                      setState(() {
                                        if (timeEnd.hour < 10 &&
                                            timeEnd.minute < 10) {
                                          dayTimeEnd.text =
                                              "0${timeEnd.hour}:0${timeEnd.minute}";
                                        }
                                        if (timeEnd.hour < 10 &&
                                            timeEnd.minute > 10) {
                                          dayTimeEnd.text =
                                              "0${timeEnd.hour}:${timeEnd.minute}";
                                        }
                                        if (timeEnd.hour > 10 &&
                                            timeEnd.minute < 10) {
                                          dayTimeEnd.text =
                                              "${timeEnd.hour}:0${timeEnd.minute}";
                                        } else {
                                          dayTimeEnd.text =
                                              "${timeEnd.hour}:${timeEnd.minute}";
                                        }
                                      });
                                    }
                                  }),
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
                                  onPressed: () {
                                    db.collection('meetings').add({
                                      'eventName': nameController.text,
                                      'timeStart':
                                          "${pickedDate?.day}/${pickedDate?.month}/${pickedDate?.year} ${timeStart.hour}:${timeStart.minute}:00",
                                      'timeEnd':
                                          "${pickedDate?.day}/${pickedDate?.month}/${pickedDate?.year} ${timeEnd.hour}:${timeEnd.minute}:00",
                                    });
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                style: style2,
                                child: const Text('Cancel'),
                                onPressed: () {
                                  setState(() {
                                    dayTimeStart.text = "Set Start Time";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                  },
                );
              },
              child: const Text('Add')),
          const SizedBox(
            width: 70,
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
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Wrap(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                  },
                );
              },
              child: const Text('Edit')),
        ]),
      ],
    ));
  }
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
  Meeting(
      {required this.eventName,
      required this.from,
      required this.to,
      required this.background,
      required this.isAllDay});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
