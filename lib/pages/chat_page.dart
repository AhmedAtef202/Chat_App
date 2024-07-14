import 'package:chatapp1/constants.dart';
import 'package:chatapp1/models/message.dart';
import 'package:chatapp1/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final ScrollController _controller = ScrollController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i].data()));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chat',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
              backgroundColor: kPrimaryColor,
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatBubble(
                                message: messagesList[index],
                              )
                            : ChatBubbleForFriend(message: messagesList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: Controller,
                    onSubmitted: (data) {
                      messages.add({
                        'message': data,
                        'created_at': DateTime.now(),
                        'id': email
                      });
                      Controller.clear();
                      _controller.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                      hintText: 'Type a message',
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return  Text('');
        }
      },
    );
  }
}
