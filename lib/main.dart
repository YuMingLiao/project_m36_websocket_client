// import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'behavior.dart';
import 'relation.dart';
import 'package:flutter/services.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'Project:M36 Websocket Client';
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
    final MyHomePageLogic _ = Get.put(MyHomePageLogic());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('This flutter app will allow you to try TutorialD websocket server. Try some of the sample queries below.'),
            Obx( ()=>
              Row(
                children: <Widget>[
                  Text('connect to:'),
                  DropdownButton<WebSocketProtocol>(
                    value: _.wsProtocol.value,
                    onChanged: (_.connPhase.value == ConnectionPhase.executetutd) ? null :
                      (WebSocketProtocol? newValue) {
                        if( newValue != null ){ _.wsProtocol.value = newValue; }
//                    setState(() {
//                      dropdownValue = newValue!;
//                    });
                    },
                    items: <WebSocketProtocol>[WebSocketProtocol.ws, WebSocketProtocol.wss]
                           .map<DropdownMenuItem<WebSocketProtocol>>((WebSocketProtocol value) {
                             return DropdownMenuItem<WebSocketProtocol>(
                               value: value,
                               child: Text(value.toString().split('.')[1]),
                             );
                           }).toList(),
                  ),
                  Text("://"),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      enabled: _.connPhase.value == ConnectionPhase.disconnected,
                      controller: _.ipAddressCtr,
                      decoration: const InputDecoration(labelText: 'ip address'),
                    ),
                  ),
                  Text(':'),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      enabled: _.connPhase.value == ConnectionPhase.disconnected,
                      controller: _.portCtr,
                      decoration: new InputDecoration(labelText: "Enter your number"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                  Text('/'),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      enabled: _.connPhase.value == ConnectionPhase.disconnected,
                      controller: _.directoryCtr,
                      decoration: const InputDecoration(labelText: 'directory'),
                    ),
                  ),
                  Text(' database:'),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      enabled: _.connPhase.value == ConnectionPhase.disconnected,
                      controller: _.databaseNameCtr,
                      decoration: const InputDecoration(labelText: 'db name'),
                    ),
                  ),
                  TextButton(
                    onPressed: (_.connPhase.value == ConnectionPhase.executetutd) ? _.disconnect : _.connect,
                    child: (_.connPhase.value == ConnectionPhase.executetutd) ? Text('Disconnect') : Text('Connect'),
                  ),        
                ]),
            ),
            
            Obx(() => Text('Status: ' + (_.promptInfo.value == null
                ? 'Disconnected'
                : 'Connected. Current Branch:(${_.promptInfo.value?.headName}) Schema:(${_.promptInfo.value?.schemaName})'))),
            Form(
              child: TextFormField(
                controller: _.textCtr,
                decoration: const InputDecoration(labelText: 'Enter a TutorialD query here.'),
              ),
            ),
            Container(
              height: 250,
              child: Obx(() => ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: _.responses[index].buildItem(),
                      );
                    },
                    itemCount: _.responses.length,
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _.sendMessage,
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

enum WebSocketProtocol { ws, wss }
enum ConnectionPhase { disconnected, executetutd }

class MyHomePageLogic extends GetxController {
//  final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8000'));
  var _channel; 
  var wsProtocol = WebSocketProtocol.ws.obs;
  final TextEditingController ipAddressCtr = TextEditingController();
  final TextEditingController portCtr = TextEditingController();
  final TextEditingController directoryCtr = TextEditingController();
  final TextEditingController databaseNameCtr = TextEditingController();
  var connPhase = ConnectionPhase.disconnected.obs;
  var db = ''.obs;
  var promptInfo = Rxn<PromptInfo>(); //nullable observable variable
  final TextEditingController textCtr = TextEditingController();
  List<Item> responses = <Item>[].obs;


  void onInit() {
    ipAddressCtr.text = '127.0.0.1';
    portCtr.text = '8000';
    databaseNameCtr.text = 'db';
  }

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(wsProtocol.value.toString().split('.')[1] + '://' + ipAddressCtr.text + ':' + portCtr.text + '/' + directoryCtr.text ));
    _channel.stream.listen((msg) => handleResponse(msg));
    _channel.sink.add('connectdb:' + databaseNameCtr.text);
    connPhase.value = ConnectionPhase.executetutd;
  }

  void sendMessage() {
    print('send ${textCtr.text}');
    if (textCtr.text.isNotEmpty) {
      switch (connPhase.value) {
        case ConnectionPhase.disconnected:
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
  void disconnect() {
    responses = <Item>[];
    promptInfo.value = null;
    _channel.sink.close();
    connPhase.value = ConnectionPhase.disconnected;
  }
  void onClose() {
    _channel.sink.close();
  }
}



