import 'dart:async';

import 'package:co_elrashid_ignite/sessions/data/data/speaker_sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/session_cover.dart';
import 'package:flutter/material.dart';

class SpeakerWidget extends StatefulWidget {
  final String speakerId;

  SpeakerWidget({Key key, @required this.speakerId}) : super(key: key);

  @override
  _SpeakerWidgetState createState() => _SpeakerWidgetState();
}

class _SpeakerWidgetState extends State<SpeakerWidget> {
  var sessions = <Session>[];
  var _title = new Completer<String>();

  refreshData() async {
    sessions = await getSpeakerSessions(widget.speakerId);
    _title.complete(getSpeakerName());
    print("refreshData");
  }

  String getSpeakerName() {
    var speakerIdIndex = sessions?.first?.speakerIds?.indexOf(widget.speakerId);
    if (speakerIdIndex != null && speakerIdIndex > -1)
      return sessions.first.speakerNames[speakerIdIndex];
    else
      return "";
  }

  String getSpeakerCompany() {
    var speakerIdIndex = sessions?.first?.speakerIds?.indexOf(widget.speakerId);
    if (speakerIdIndex != null && speakerIdIndex > -1)
      return sessions.first.speakerCompanies[speakerIdIndex];
    else
      return "";
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
                  : Text("Speaker"),
        ),
      ),
      body: FutureBuilder(
          future: refreshData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(getSpeakerName()),
                              Text(getSpeakerCompany()),
                            ],
                          ),
                          Image.asset(
                            'assets/i/no-bg/${widget.speakerId}.png',
                            color: Colors.blue[100],
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            return SessionCoverWidget(sessions[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          }),
    );
  }
}