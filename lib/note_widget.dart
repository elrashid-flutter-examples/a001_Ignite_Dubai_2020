import 'package:co_elrashid_ignite/note.dart';
import 'package:co_elrashid_ignite/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  NoteWidget({
    Key key,
    this.note,
  }) : super(key: key) {
    print("NoteWidget");
    print(note);
    print(note.text);
    print(note.id);
  }

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.note.text;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 5.0),
              ),
              hintText: 'Note .......',
            ),
            textAlign: TextAlign.center,
            maxLines: null,
            controller: _controller,
            onChanged: (text) {
              print("onChanged => value = $text");
              widget.note.text = text;
              print(widget.note.text);
              updateNote(widget.note);
            },
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_hide),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: widget.note.text));
              },
            ),
            // IconButton(
            //   icon: Icon(Icons.save),
            //   onPressed: () {
            //     updateNote(widget.note);
            //     // _controller.clear();
            //     // FocusScope.of(context).unfocus();
            //     setState(() {});
            //   },
            // ),
            // Expanded(child: Container()),
            // IconButton(
            //   icon: Icon(Icons.delete),
            //   onPressed: () {},
            // ),
          ],
        )
      ],
    );
  }
}
