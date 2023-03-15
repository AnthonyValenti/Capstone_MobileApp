import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final databaseReference = FirebaseFirestore.instance.collection('team');
  List<Map<dynamic, dynamic>> teamMembers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  void _fetchTeamMembers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentUserId = user.uid;
      final querySnapshot = await databaseReference
          .where("uid", isNotEqualTo: currentUserId)
          .get();
      setState(() {
        teamMembers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  void _navigateToChatScreen(String user1Id, String user2Id, String user2Name,
      String user2ProfilePicture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          user1Id: user1Id,
          user2Id: user2Id,
          user2Name: user2Name,
          user2ProfilePicture: user2ProfilePicture,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: teamMembers.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey),
              itemBuilder: (BuildContext context, int index) {
                final user1Id = FirebaseAuth.instance.currentUser!.uid;
                final user2Id = teamMembers[index]['uid'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(teamMembers[index]['profile_picture']),
                  ),
                  title: Text(teamMembers[index]['name']),
                  subtitle: Text(teamMembers[index]['job_title']),
                  onTap: () {
                    _navigateToChatScreen(
                        user1Id,
                        user2Id,
                        teamMembers[index]['name'],
                        teamMembers[index]['profile_picture']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
