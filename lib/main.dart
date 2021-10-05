import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'Websocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum ConnectionPhase { ConnectDb, ExecuteTutd }

class _MyHomePageState extends State<MyHomePage> {
  var phase = ConnectionPhase.ConnectDb;
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8000'));

  @override
  Widget build(BuildContext context) {
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
                controller: _controller,
                decoration: const InputDecoration(labelText: 'enter a db name'),
              ),
            ),
            Container(
              height: 250,
              child: StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  print('${snapshot.data}');
                  responses.add(snapshot.data);
                  if (responses.length > 3) { responses.removeAt(0); } 
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
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    print('send ${_controller.text}');
    if (_controller.text.isNotEmpty) {
      switch (phase) {
        case ConnectionPhase.ConnectDb:
          {
            _channel.sink.add('connectdb:' + _controller.text);
            phase = ConnectionPhase.ExecuteTutd;
            break;
          }
        case ConnectionPhase.ExecuteTutd:
          {
            _channel.sink.add('executetutd/json:' + _controller.text);
          }
      }
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
