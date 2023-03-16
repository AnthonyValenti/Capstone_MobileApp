import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final int timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String user1Id;
  final String user2Id;
  final String user2Name;
  final String user2ProfilePicture;

  const ChatScreen(
      {Key? key,
      required this.user1Id,
      required this.user2Id,
      required this.user2Name,
      required this.user2ProfilePicture})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _firestore = FirebaseFirestore.instance;
  late final _auth = FirebaseAuth.instance;
  late final _currentUser = _auth.currentUser;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    _controller.clear();
    _firestore.collection('messages').add({
      'senderId': widget.user1Id,
      'receiverId': widget.user2Id,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Widget _buildMessage(Message message) {
    try {
      final isMe = message.senderId == _currentUser!.uid;
      return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueGrey[50] : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(message.text),
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error building message: $e');
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user2ProfilePicture),
            ),
            const SizedBox(width: 8),
            Text(widget.user2Name),
          ],
        ),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('senderId', isEqualTo: widget.user1Id)
                  .where('receiverId', isEqualTo: widget.user2Id)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) =>
                        Message.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _controller.text.trim().isEmpty
                      ? null
                      : () {
                          _sendMessage(_controller.text);
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
