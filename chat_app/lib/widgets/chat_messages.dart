import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No messages found',
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Something went wrong...',
            ),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nxtChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nxtChatMessage != null ? nxtChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                isMe: loggedUser.uid == currentMessageUserId,
                message: chatMessage['text'],
              );
            } else {
              return MessageBubble.first(
                isMe: loggedUser.uid == currentMessageUserId,
                userImage: chatMessage['userImage'],
                username: chatMessage['userName'],
                message: chatMessage['text'],
              );
            }
          },
        );
      },
    );
  }
}
