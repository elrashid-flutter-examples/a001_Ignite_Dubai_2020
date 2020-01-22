import 'package:co_elrashid_ignite/sessions.dart';
import 'package:flutter/material.dart';
import 'dart:core';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // Widget build(BuildContext context) {
  //   var sessions = getNormalSessions();

  //   return MaterialApp(
  //     home: Scaffold(
  //       body: _build1(context, sessions),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Slivers"),
        ),
        body: CustomScrollView(
          slivers: _sliverList(50, 10),
        ),
      ),
    );
  }

  var pinnedIndex = 0;
  List<Widget> _sliverList(int size, int sliverChildCount) {
    var widgetList = new List<Widget>();
    for (int index1 = 0; index1 < size; index1++)
      widgetList
        ..add(SliverAppBar(
          title: Text("Title $index1"),
          pinned: false,
          floating: true,
          snap: true,
        ))
        ..add(SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index2) {
            print(index1);
            return Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index2 % 9)],
              child: Text('list item $index2 / $index1'),
            );
          }, childCount: sliverChildCount),
        ));

    return widgetList;
  }

  ListView _build1(BuildContext context, List<Session> sessions) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (BuildContext context, int index) {
        return _build2(context, index, sessions);
      },
    );
  }

  Widget _build2(BuildContext context, int index, List<Session> sessions) {
    var session = sessions[index];
    var startDate = DateTime.parse(session.startDateTime).toLocal();
    var endDate = DateTime.parse(session.endDateTime).toLocal();
    var dateStr =
        "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";
    var lastIndex = index - 1;
    if (-1 < lastIndex) {
      var lastSession = sessions[lastIndex];
      if (lastSession.startDateTime == session.startDateTime) {
        dateStr = "";
      }
    }

    var title = session.title
        .substring(0, session.title.length > 100 ? 100 : session.title.length);
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Text(dateStr),
              title: Text(title),
              subtitle: Text(session.sessionCode),
            ),
          ],
        ),
      ),
    );
  }
}
