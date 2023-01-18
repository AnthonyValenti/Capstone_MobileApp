import 'package:flutter/material.dart';

class CommutePage extends StatelessWidget {
  const CommutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commute',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: const Center(
        child: Text(
          "Commute",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
