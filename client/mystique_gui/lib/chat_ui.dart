import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final WebSocketChannel wsSocket;
  const ChatPage({super.key, required this.wsSocket});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(),
          Bottombar(),
        ],
      )
    );
  }
}

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        
      ],
    );
  }
}
