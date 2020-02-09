import 'dart:async';

import 'package:co_elrashid_ignite/sessions/data/data/location.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/session_cover.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LocationSessionsWidget extends StatefulWidget {
  final String location;

  LocationSessionsWidget({Key key, @required this.location}) : super(key: key);

  @override
  _LocationSessionsWidgetState createState() => _LocationSessionsWidgetState();
}

class _LocationSessionsWidgetState extends State<LocationSessionsWidget> {
  var sessions = <Session>[];
    var _title = new Completer<String>();

  refreshData() async {
    sessions = await getLocationSessions(widget.location);
    _title.complete(sessions.first.location);
    setState(() {});

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
                  : Text("location"),
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
