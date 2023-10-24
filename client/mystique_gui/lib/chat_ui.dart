// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

ColorScheme getColorScheme(BuildContext context) =>
    Theme.of(context).colorScheme;

class ChatPage extends StatefulWidget {
  final WebSocketChannel? wsSocket;
  final String yourName;
  final String theirName;
  const ChatPage({
    super.key,
    this.wsSocket,
    required this.yourName,
    required this.theirName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  var chatHistory = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Text("Chat page under progress ${widget.yourName}"),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Message(data: "Hey there", whose: "their"),
          Message(data: "Hello i am rohith.", whose: "yours"),
          Bottombar(controller: controller),
        ],
      ),
    );
  }
}

class Bottombar extends StatelessWidget {
  const Bottombar({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 9, child: MessageForm(controller: controller)),
        Flexible(flex: 1, fit: FlexFit.tight, child: SendButton()),
      ],
    );
  }
}

class MessageForm extends StatelessWidget {
  const MessageForm({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    //lets use icon button here next
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: getColorScheme(context).inversePrimary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.send_rounded,
          color: getColorScheme(context).onPrimaryContainer,
        ),
      ),
    );
  }
}

class ChatBody extends StatefulWidget {
  final String wsSocket;
  const ChatBody({super.key, required this.wsSocket});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class Chats extends StatelessWidget {
  final List<Widget> chatHistory;
  const Chats({
    super.key,
    required this.chatHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.data,
    required this.whose,
  });

  final String whose;
  final String data;

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;
    return Row(
        mainAxisAlignment: (whose == "their")
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: (whose == "their")
            ? [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 36, 38, 41),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data,
                        style: TextStyle(
                          color: myColorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
              ]
            : [
                Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: myColorScheme.inversePrimary,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data,
                        style: TextStyle(
                          color: myColorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                )
              ]);
  }
}
