import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'behavior.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'Websocket Demo';
    return GetMaterialApp(
      title: title,
      home: MyHomePage(title: title),
      scrollBehavior: MyScrollBehavior(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final MyHomePageLogic _logic = Get.put(MyHomePageLogic());
    List responses = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
                  child: TextFormField(
                    controller: _logic.textCtr,
                    decoration:
                        const InputDecoration(labelText: 'enter a db name'),
                  ),
                ),
            Container(
              height: 250,
              child: StreamBuilder(
                stream: _logic._channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) { Map<String, dynamic> json = jsonDecode(snapshot.data.toString()); }
                  //TODO: change state of PromptInfo
                  responses.add(snapshot.data);
                  //if (responses.length > 3) {
                  //  responses.removeAt(0);
                  // }
                  return ListView.builder(
                    reverse: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(responses[index].toString()),
                      );
                    },
                    itemCount: responses.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logic.sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}

enum ConnectionPhase { connectdb, executetutd }

class MyHomePageLogic extends GetxController {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8000'));
  final TextEditingController textCtr = TextEditingController();
  var connPhase = ConnectionPhase.connectdb.obs;
  var db = ''.obs;
  var schemaname = ''.obs;
  var headname = ''.obs;

  void sendMessage() {
    print('send ${textCtr.text}');
    if (textCtr.text.isNotEmpty) {
      switch (connPhase.value) {
        case ConnectionPhase.connectdb:
          {
            _channel.sink.add('connectdb:' + textCtr.text);
            connPhase.value = ConnectionPhase.executetutd;
            break;
          }
        case ConnectionPhase.executetutd:
          {
            _channel.sink.add('executetutd/json:' + textCtr.text);
          }
      }
    }
  }
  void onClose(){
    _channel.sink.close();
  }

}
