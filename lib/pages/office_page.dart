import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> colorList = <String>['White', 'Blue', 'Red', 'Purple'];

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
        backgroundColor: Colors.blueGrey.shade500,
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
  bool light1 = false;
  bool light2 = false;
  bool light3 = false;
  String selectedColor = colorList.first;
  Color selectedC = Colors.white;
  Map<String, dynamic> selectedColorRBG = {
    "r": 255,
    "g": 0,
    "b": 0,
  };

  static const platform1 = MethodChannel('capstone.flutter.lights.on');
  static const platform2 = MethodChannel('capstone.flutter.lights.off');
  static const platform3 = MethodChannel('capstone.flutter.lights.color');
  Future<void> lightsOn() async {
    try {
      await platform1.invokeMethod('lightsOn');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> lightsOff() async {
    try {
      await platform2.invokeMethod('lightsOff');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> changeColor() async {
    try {
      await platform3.invokeMethod('changeColor', selectedColorRBG);
    } on PlatformException catch (e) {
      print(e);
    }
  }

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
                      if (light1 == true) {
                        lightsOn();
                      }
                      if (light1 == false) {
                        lightsOff();
                      }
                    },
                  ))),
          DropdownButton<String>(
            value: selectedColor,
            icon: const Icon(Icons.palette_outlined),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                selectedColor = value!;
                if (selectedColor == "White") {
                  selectedC = Colors.white;
                }
                if (selectedColor == "Blue") {
                  selectedC = Colors.blue;
                }
                if (selectedColor == "Purple") {
                  selectedC = Colors.purple;
                }
                if (selectedColor == "Red") {
                  selectedC = Colors.red;
                }
                selectedColorRBG = {
                  "r": selectedC.red,
                  "g": selectedC.green,
                  "b": selectedC.blue,
                };
                changeColor();
              });
            },
            items: colorList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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
        ],
      ),
    );
  }
}
