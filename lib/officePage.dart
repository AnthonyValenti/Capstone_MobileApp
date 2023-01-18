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
        child: Text(
          "Office",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
