import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bkg5.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: const Reminders(),
      ),
    );
  }
}

class Reminders extends StatefulWidget {
  const Reminders({super.key});

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  TextEditingController nameController = TextEditingController();
  TextEditingController reminderController = TextEditingController();
  List<Reminder> remindersList = <Reminder>[];

  getDataFromDB() async {
    remindersList.clear();
    var results = await db.collection("reminders").get();
    if (mounted) {
      setState(() {
        results.docs.forEach((element) {
          remindersList.add(Reminder(
            name: element['name'],
            description: element['reminder'],
          ));
        });
      });
    }
  }

  @override
  void initState() {
    remindersList.clear();
    getDataFromDB();
    super.initState();
  }

  TextStyle style1 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final ButtonStyle style3 = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    fixedSize: const Size(150, 50),
    backgroundColor: Colors.blueGrey.shade500,
  );

  final ButtonStyle style2 = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    fixedSize: const Size(150, 50),
    backgroundColor: Colors.blueGrey.shade200,
  );
  final ButtonStyle style4 = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    fixedSize: const Size(250, 80),
    backgroundColor: Colors.blueGrey.shade200,
  );
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          SizedBox(
              height: 600,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Reminder',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  rows: remindersList
                      .map(
                        (reminder) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                reminder.name,
                                style: style1,
                              ),
                            ),
                            DataCell(
                              Text(
                                reminder.description,
                                style: style1,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        context: context,
                        backgroundColor: Colors.blueGrey.shade500,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Wrap(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: TextFormField(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          controller: nameController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 3,
                                                )),
                                            fillColor: Colors.blueGrey.shade200,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            labelText: 'Name',
                                            labelStyle: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: TextFormField(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          controller: reminderController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 3,
                                                )),
                                            fillColor: Colors.blueGrey.shade200,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            labelText: 'Reminder',
                                            labelStyle: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                        style: style2,
                                        child: const Text('Add'),
                                        onPressed: () {
                                          db.collection('reminders').add({
                                            'name': nameController.text,
                                            'reminder': reminderController.text,
                                          });
                                          Navigator.pop(context);
                                          setState(() {
                                            nameController.text = "";
                                            reminderController.text = "";
                                            getDataFromDB();
                                          });
                                        }),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      style: style2,
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        setState(() {
                                          nameController.text = "";
                                          nameController.text = "";
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
                    style: style3,
                    child: const Text("Add"),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 30, 30),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        context: context,
                        backgroundColor: Colors.blueGrey.shade500,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Wrap(
                              children: [
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: remindersList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Column(
                                        children: [
                                          const Padding(
                                              padding: EdgeInsets.all(10)),
                                          ElevatedButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('Warning'),
                                                content: const Text(
                                                    'Are you sure you would like to delete this reminder?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'OK');
                                                      db
                                                          .collection(
                                                              "reminders")
                                                          .where('reminder',
                                                              isEqualTo:
                                                                  remindersList[
                                                                          index]
                                                                      .description)
                                                          .get()
                                                          .then((value) =>
                                                              value.docs.forEach(
                                                                  (element) {
                                                                element
                                                                    .reference
                                                                    .delete();
                                                              }));
                                                      setState(() {
                                                        remindersList
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            style: style4,
                                            child: Text(
                                              remindersList[index].description,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                const Padding(padding: EdgeInsets.all(10)),
                              ],
                            );
                          });
                        },
                      );
                    },
                    style: style3,
                    child: const Text("Delete"),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class Reminder {
  final String name;
  final String description;

  Reminder({required this.name, required this.description});
}
