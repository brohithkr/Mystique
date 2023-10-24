// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'color_schemes.g.dart';
import 'chat_ui.dart';
import 'random_name.dart';
import 'config.dart' as config;

// WebSocketChannel? wsChannel;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mystique",
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleLogo(
              context: context,
            ),
            SizedBox(height: 100),
            InputForm(),
          ],
        ),
      ),
    );
  }
}

class TitleLogo extends StatelessWidget {
  final BuildContext context;
  const TitleLogo({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 0,
      ),
      child: Text(
        "Mystique",
        style: TextStyle(
            fontSize: 60,
            fontFamily: "Retrocycles",
            color: Color.fromARGB(255, 134, 177, 186)),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  var username = "";
  var autoGenName = genRandName();
  var loadState = "";
  void handleUsername(String data) {
    setState(() {
      username = data;
    });
  }

  void handleLoad(String state) {
    setState(() {
      loadState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "select a ",
          style: TextStyle(fontSize: 30, fontFamily: "Retrocycles"),
        ),
        Text(
          "nickname",
          style: TextStyle(fontSize: 45, fontFamily: "Retrocycles"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UsernameField(controller: controller),
              DiceButton(controller: controller)
            ],
          ),
        ),
        SubmitButton(
          controller: controller,
          handleLoad: handleLoad,
        ),
        StreamBox(loadState: loadState, controller: controller),
      ],
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: TextFormField(
        // focusNode: focusNode,
        // initialValue: username,
        // onChanged: (value) => handleUsername(value),
        controller: controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          // hintText: (username == "") ? autoGenName : null,
          // labelText: (username == "") ? autoGenName : null,
          border: InputBorder.none,
          // contentPadding: EdgeInsets.all(8),
          hintStyle: TextStyle(),
        ),
        style: TextStyle(),
      ),
    );
  }
}

class DiceButton extends StatelessWidget {
  const DiceButton({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // print(username);
        var randName = genRandName();
        controller.value = TextEditingValue(
          text: randName,
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: randName.length,
            ),
          ),
        );
      },
      child: Icon(
        Icons.casino_rounded,
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.controller,
    required this.handleLoad,
  });

  final TextEditingController controller;
  final void Function(String) handleLoad;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: () {
          if (controller.text == "") {
            var errorBar = SnackBar(
              content: Text(
                "Please select a nickname",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.blueGrey.shade900,
            );
            ScaffoldMessenger.of(context).showSnackBar(errorBar);
            return;
          }
          handleLoad("start");
        },
        style: ButtonStyle(alignment: Alignment.center),
        child: Text("Start chatting!"),
      ),
    );
  }
}

class StreamBox extends StatefulWidget {
  // final WebSocketChannel channel;
  final TextEditingController controller;
  final String loadState;
  const StreamBox(
      {super.key, required this.loadState, required this.controller});

  @override
  State<StreamBox> createState() => _StreamBoxState();
}

class _StreamBoxState extends State<StreamBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.loadState == "") {
      return SizedBox();
    }
    var username = widget.controller.text;
    final wsSocket = WebSocketChannel.connect(
        Uri.parse('${config.SERVER_URL}/connect?username=$username'));
    // await wsSocket.ready;
    // var x = widget.loadState;
    return StreamBuilder(
      stream: wsSocket.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoadBox(
            loadMsg: "Finding users, please wait...",
          );
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(),
          ),
        );
        return SizedBox();
      },
    );
  }
}

class LoadBox extends StatelessWidget {
  final String loadMsg;
  const LoadBox({super.key, required this.loadMsg});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinKitCircle(
            color: Theme.of(context).colorScheme.onBackground,
            size: 50,
          ),
        ),
        Text(
          loadMsg,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        )
      ],
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
