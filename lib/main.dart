import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'behavior.dart';
import 'package:pretty_json/pretty_json.dart';

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
                    //reverse: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_logic.responses[index]),
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
  var displayError = Rxn<DisplayError>();
  var responses = [].obs;

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

  void handleResponse(msg) {
    Map<String, dynamic> json = jsonDecode(msg);
    if (json.containsKey('promptInfo')) {
      promptInfo.value = PromptInfo.fromJson(json['promptInfo']);
    } else if (json.containsKey('displayerror')) {
      displayError.value = DisplayError.fromJson(json['displayerror']);
      responses.insert(0, displayError.value?.error);
    }
    else if (json.containsKey('displayrelation')){
      responses.insert(0, prettyJson(json, indent: 2));
    }
  }

  void onClose() {
    _channel.sink.close();
  }
}

class PromptInfo {
  final String schemaName;
  final String headName;

  PromptInfo(this.schemaName, this.headName);

  PromptInfo.fromJson(Map<String, dynamic> json)
      : schemaName = json['schemaname'],
        headName = json['headname'];

  Map<String, dynamic> toJson() => {
        'promptInfo': {
          'schemaname': schemaName,
          'headname': headName,
        }
      };
}

class DisplayError {
  final String error;

  DisplayError(this.error);

  DisplayError.fromJson(Map<String, dynamic> json) : error = json['json'];

  Map<String, dynamic> toJson() => {
        'displayerror': {'json': error}
      };
}

/*
class DisplayRelation {

  DisplayRelation();

  DisplayRelation.fromJson(Map<String, dynamic> json)
      : schemaName = json['schemaname'],
        headName = json['headname'];

  Map<String, dynamic> toJson() => {
        'displayrelation': {
          'schemaname': schemaName,
          'headname': headName,
        }
      };
}
*/
