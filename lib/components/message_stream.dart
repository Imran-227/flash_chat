import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required FirebaseFirestore firestore,
    required this.collectionPath,
    required this.currentUserEmail,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final String collectionPath;
  final String? currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(collectionPath)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return const Center(child: kMyCircularProgressIndicator);
        }
        Iterable messages = snapshot.data!.docs;
        for (QueryDocumentSnapshot<Object?> message in messages) {
          String messageContent = message.get('content');
          String messageSender = message.get('sender');
          bool isMe = messageSender == currentUserEmail;

          messageBubbles.add(
            MessageBubble(
                sender: messageSender, content: messageContent, isMe: isMe),
          );
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
