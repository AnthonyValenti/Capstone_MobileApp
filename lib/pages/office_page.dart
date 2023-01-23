import 'package:flutter/material.dart';

class OfficePage extends StatelessWidget {
  const OfficePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: const Center(
        child: SwitchExample(),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = true;
  bool light2 = true;
  bool light3 = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "Main Lights:",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              width: 100,
              height: 80,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: light1,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        light1 = value;
                      });
                    },
                  ))),
          const SizedBox(height: 70),
          const Text(
            "Office Lights:",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              width: 100,
              height: 80,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: light2,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        light2 = value;
                      });
                    },
                  ))),
          const SizedBox(height: 70),
          const Text(
            "Side Lights:",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              width: 100,
              height: 80,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: light3,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        light3 = value;
                      });
                    },
                  ))),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
