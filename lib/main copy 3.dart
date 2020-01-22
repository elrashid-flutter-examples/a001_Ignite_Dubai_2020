// import 'package:co_elrashid_ignite/sessions.dart';
// import 'package:flutter/material.dart';
// import 'dart:core';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // @override
//   // Widget build(BuildContext context) {
//   //   var sessions = getNormalSessions();

//   //   return MaterialApp(
//   //     home: Scaffold(
//   //       body: _build1(context, sessions),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var sessions = getNormalDay01SessionsGroups();
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Slivers"),
//         ),
//         body: CustomScrollView(
//           slivers: _sliverList(context, sessions),
//         ),
//       ),
//     );
//   }

//   List<Widget> _sliverList(
//       BuildContext context, List<SessionGroup> sessionGroups) {
//     var widgetList = new List<Widget>();
//     for (int index = 0; index < sessionGroups.length; index++) {
//       widgetList.add(SliverList(
//         delegate:
//             SliverChildBuilderDelegate((BuildContext context, int index2) {
//           return _build1(context, index2, sessionGroups[index]);
//           // return Container(
//           //   alignment: Alignment.center,
//           //   color: Colors.lightBlue[100 * (index2 % 9)],
//           //   child: Text('list item $index2 / $index'),
//           // );
//         }, childCount: sessionGroups.length),
//       ));
//     }
//     return widgetList;
//   }

//   ListView _build1(BuildContext context,int index, SessionGroup sessionGroup) {
//     return ListView.builder(
//       itemCount: sessionGroup.sessions.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _build2(context, index, sessionGroup);
//       },
//     );
//   }

//   Widget _build2(BuildContext context, int index, SessionGroup sessions) {
//     var session = sessions[index];
//     var startDate = DateTime.parse(session.startDateTime).toLocal();
//     var endDate = DateTime.parse(session.endDateTime).toLocal();
//     var dateStr =
//         "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";
//     var lastIndex = index - 1;
//     if (-1 < lastIndex) {
//       var lastSession = sessions[lastIndex];
//       if (lastSession.startDateTime == session.startDateTime) {
//         dateStr = "";
//       }
//     }

//     var title = session.title
//         .substring(0, session.title.length > 100 ? 100 : session.title.length);
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             ListTile(
//               leading: Text(dateStr),
//               title: Text(title),
//               subtitle: Text(session.sessionCode),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
