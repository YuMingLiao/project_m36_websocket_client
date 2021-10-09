import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'behavior.dart';
import 'relation.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() => Text(_logic.promptInfo.value == null
                ? 'no db yet'
                : 'Current Branch:(${_logic.promptInfo.value?.headName}) Schema:(${_logic.promptInfo.value?.schemaName})')),
            Form(
              child: TextFormField(
                controller: _logic.textCtr,
                decoration: const InputDecoration(labelText: 'enter a db name'),
              ),
            ),
            Container(
              height: 250,
              child: Obx(() => ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: _logic.responses[index].buildItem(),
                      );
                    },
                    itemCount: _logic.responses.length,
                  )),
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
  var promptInfo = Rxn<PromptInfo>(); //nullable observable variable
  List<Item> responses = <Item>[].obs;


  void onInit() {
    _channel.stream.listen((msg) => handleResponse(msg));
  }

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

//OK message
//{
//  "acknowledged": true
//}
  void handleResponse(msg) {
    Map<String, dynamic> json = jsonDecode(msg);
    if (json.containsKey('promptInfo')) {
      promptInfo.value = PromptInfo.fromJson(json['promptInfo']);
    } else if (json.containsKey('acknowledged')) {
      responses.insert(0, DisplayJson.fromJson(json));
    } else if (json.containsKey('displayerror')) {
      var e = DisplayError.fromJson(json['displayerror']);
      responses.insert(0, e);
    }
    else if (json.containsKey('displayrelation')){
      responses.insert(0, DisplayRelation.fromJson(json['displayrelation']));
    }
    else { 
      responses.insert(0, DisplayJson.fromJson(json));
    }
  }

  void onClose() {
    _channel.sink.close();
  }
}



