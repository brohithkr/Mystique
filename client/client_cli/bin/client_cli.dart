// import 'dart:ffi';
// import 'package:process_run/shell.dart';

import 'package:web_socket_client/web_socket_client.dart';
import 'dart:io';
import 'config.dart' as config;

//┌├┐└┘
List<String> chatHistory = [];

void displayRefresh(List<String> data) async {
  var horizonalLine = "${"─" * 80}\n";
  var res = horizonalLine;
  // res += ;
  for (var i in data) {
    res += "$i\n";
  }
  res += horizonalLine;
  res += "Type your message: ";
  print(Process.runSync("clear", [], runInShell: true).stdout);
  stdout.write(res);
}

void main() async {
  // displayRefresh();
  stdout.write("Please enter a nickname: ");
  String username = stdin.readLineSync() ?? "user";
  final socket = WebSocket(
    Uri.parse('${config.SERVER_URL}/connect?username=$username'),
  );

  // Wait until a connection has been established.
  await socket.connection.firstWhere((state) {
    // print(state);
    return state is Connected;
  });

  socket.messages.listen((message) {
    // stdout.write("Type your message: ");
    chatHistory.add(message);
    displayRefresh(chatHistory);
    String toSend = stdin.readLineSync() ?? "";
    socket.send(toSend);
    chatHistory.add(toSend);
    displayRefresh(chatHistory);
  });

  // Send a message to the server.
  // socket.send('ping');
}
