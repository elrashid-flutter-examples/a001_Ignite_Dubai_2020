import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class MyAppx extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: NotesWidget(),
    );
  }
}

class NotesWidget extends StatefulWidget {
  NotesWidget({Key key}) : super(key: key);

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var notes = <String>[];
  var _notesWidgets = <int, Widget>{};
  var _notesControllers = <int, TextEditingController>{};
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(title: Text("sss")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                // decoration: BoxDecoration(
                //   border: Border(
                //     left: BorderSide(
                //         width: 16.0, color: Colors.lightBlue.shade600),
                //     bottom: BorderSide(
                //         width: 8.0, color: Colors.lightBlue.shade900),
                //   ),
                //   color: Colors.white,
                // ),
                // color: Colors.blue,
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      if (_notesControllers[index] == null)
                        _notesControllers[index] = TextEditingController();
                      if (_notesWidgets[index] == null)
                        _notesWidgets[index] = Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.greenAccent, width: 5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              ),
                              hintText: 'Note .......',
                            ),
                            textAlign: TextAlign.center,
                            maxLines: null,
                            controller: _notesControllers[index],
                            onChanged: (value) {
                              notes[index] = value;
                            },
                          ),
                        );
                      _notesControllers[index].text = notes[index];
                      return _notesWidgets[index];
                    }),
              ),
            ),
            Container(
              // color: Colors.blueGrey,
              padding: const EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   border: Border(
              //     left:
              //         BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
              //     bottom:
              //         BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
              //   ),
              //   // color: Colors.white,
              // ),
              child: TextField(
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.greenAccent, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  ),
                  hintText: 'Note .......',
                ),
                maxLines: 5,
                minLines: 2,
                controller: _controller,
              ),
            ),
            RaisedButton(
              child: Icon(Icons.save),
              onPressed: () {
                notes.add(_controller.text);
                _controller.clear();
                FocusScope.of(context).unfocus();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}

class Note {
  String id;

  Note({this.id});
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}
