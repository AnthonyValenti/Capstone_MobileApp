import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/commute_page.dart';
import 'package:flutter_application_1/pages/meetings_page.dart';
import 'package:flutter_application_1/pages/office_page.dart';
import 'package:flutter_application_1/pages/team_page.dart';
import 'package:flutter_application_1/pages/weather_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('GK02: Smart System',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bkg3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const MyStatefulWidget(),
      ),
    ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade500,
      textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      fixedSize: const Size(300, 80),
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton.icon(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherPage()),
              );
            },
            label: const Text(' Weather'),
            icon: const ImageIcon(
              AssetImage("images/cloudy.png"),
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeetingsPage()),
              );
            },
            label: const Text(' Meetings'),
            icon: const ImageIcon(
              AssetImage("images/calendar.png"),
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamPage()),
              );
            },
            label: const Text(' Team'),
            icon: const ImageIcon(
              AssetImage("images/messenger.png"),
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommutePage()),
              );
            },
            label: const Text(' Commute'),
            icon: const ImageIcon(
              AssetImage("images/map.png"),
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OfficePage()),
              );
            },
            label: const Text(' Office'),
            icon: const ImageIcon(
              AssetImage("images/settings.png"),
              size: 40,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
