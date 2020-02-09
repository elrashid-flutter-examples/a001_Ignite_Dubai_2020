import 'package:co_elrashid_ignite/note.dart';
import 'package:co_elrashid_ignite/note_widget.dart';
import 'package:co_elrashid_ignite/notes.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/session_cover.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class SessionNotesWidget extends StatefulWidget {
  final Session session;

  SessionNotesWidget({
    Key key,
    this.session,
  }) : super(key: key);
  @override
  _SessionNotesWidgetState createState() => _SessionNotesWidgetState();
}

class _SessionNotesWidgetState extends State<SessionNotesWidget> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Note> notes;

  refreshData() async {
    notes = await getSessionNotes(widget.session.sessionId);
    // _title.complete(sessions.first.location);
    // setState(() {});

    print("refreshData");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // notes.add(;
          var s = widget.session;
          await addNote(
            Note(
              text: "",
              speakerIds: s.speakerIds,
              sessionId: s.sessionId,
              location: s.location,
              learningPath: s.learningPath,
              day: DateTime.parse(s.startDateTime).day,
            ),
          );

          setState(() {});
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(title: Text("Session Notes")),
      body: SafeArea(
        child: FutureBuilder(
            future: refreshData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SessionCoverWidget(widget.session),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                             return  NoteWidget(note: notes[index]);
                            }),
                      ),
                    ),
                  ],
                );
              } else
                return Text("...");
            }),
      ),
    );
  }
}
