import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        setState(() {
          loggedInUser = user;
          _isLoading = false;
        });
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

// //not simultaneous update
  // void getMessages()async{

  //   final messages =await _firestore.collection('messages').get();
  //   for(var message  in messages.docs){
  //     print(message.data());
  //   }

  // }

// //it is simultaneous update
  void messagesStream() async {
    await for (var firebase_snapshot
        in _firestore.collection('messages').snapshots()) {
      for (var message in firebase_snapshot.docs) {
        // print(message.data()['text']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // getMessages();
              messagesStream();
              // _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }

                  List<MessageBubble> messageBubbles = [];
                  for (QueryDocumentSnapshot message in snapshot.data!.docs) {
                    final messageData = message.data() as Map;
                    final messageText = messageData['text'];
                    final messageSender = messageData['sender'];

                    final currentUser =loggedInUser?.email;

                  
                    final messageBubble =
                        MessageBubble(messageSender, messageText,currentUser==messageSender);

                    messageBubbles.add(messageBubble);
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageBubbles,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecorationRegister,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text,this.isMe);
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe?BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))
                :BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "$text",
                style: TextStyle(fontSize: 15,color: isMe?Colors.white:Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
