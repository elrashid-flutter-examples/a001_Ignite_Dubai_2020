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
//     var sessionGroups = getNormalDay01SessionsGroups();
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Slivers"),
//         ),
//         body: CustomScrollView(
//           slivers: [_build1(context, sessionGroups)],
//         ),
//       ),
//     );
//   }

//   Widget _build1(BuildContext context, List<SessionGroup> sessionGroups) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//         return _build2(context, index, sessionGroups[index]);
//       }, childCount: sessionGroups.length),
//     );
//   }

//   Widget _build2(BuildContext context, int index, SessionGroup sessionGroup) {
//     var startDate = DateTime.parse(sessionGroup.startDateTime).toLocal();
//     var endDate = DateTime.parse(sessionGroup.endDateTime).toLocal();
//     var dateStr =
//         "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";

//     return Row(children: <Widget>[
//       Text(dateStr),
//       CustomScrollView(slivers: [
//         SliverList(
//           delegate:
//               SliverChildBuilderDelegate((BuildContext context, int index) {
//             return _build3(context, index, sessionGroup.session);
//           }, childCount: sessionGroup.session.length),
//         )
//       ]),
//     ]);
//   }

//   Widget _build3(BuildContext context, int index, List<Session> sessions) {
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
