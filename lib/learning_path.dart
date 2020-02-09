import 'dart:async';

import 'package:co_elrashid_ignite/sessions/data/data/learning_path.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/session_cover.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LearningPathSessionsWidget extends StatefulWidget {
  final String learningPath;

  LearningPathSessionsWidget({Key key, @required this.learningPath})
      : super(key: key);

  @override
  _LearningPathSessionsWidgetState createState() =>
      _LearningPathSessionsWidgetState();
}

class _LearningPathSessionsWidgetState
    extends State<LearningPathSessionsWidget> {
  var sessions = <Session>[];
  var _title = new Completer<String>();

  refreshData() async {
    sessions = await getLearningPathSessions(widget.learningPath);
    _title.complete(sessions.first.location);
    print("refreshData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _title.future,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? Text(snapshot.data)
                  : Text("Learning Path"),
        ),
      ),
      body: FutureBuilder(
          future: refreshData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return SessionCoverWidget(sessions[index]);
                  },
                ),
              );
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          }),
    );
  }
}
