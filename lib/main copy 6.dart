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
//         home: Scaffold(
//       appBar: AppBar(
//         title: Text("Slivers"),
//       ),
//       body: _build1(
//         context,
//         sessionGroups,
//       ),
//     ));
//   }

//   Widget _build1(BuildContext context, List<SessionGroup> sessionGroups) {
//     return ListView.builder(
//         itemCount: sessionGroups.length,
//         itemBuilder: (BuildContext context, int index) {
//           return _build2(context, index, sessionGroups[index]);
//         });
//   }

//   Widget _build2(BuildContext context, int index, SessionGroup sessionGroup) {
//     var startDate = DateTime.parse(sessionGroup.startDateTime).toLocal();
//     var endDate = DateTime.parse(sessionGroup.endDateTime).toLocal();
//     var dateStr =
//         "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";

//     return Row(children: <Widget>[
//       Text(dateStr),
//       _build3(context, sessionGroup),
//     ]);
//   }

//   Widget _build3(BuildContext context, SessionGroup sessionGroup) {
//     var rr = <Widget>[];

//     for (var index = 0; index < sessionGroup.sessions.length; index++) {
//       rr.add(_build4(context, index, sessionGroup.sessions));
//     }
//     // return SingleChildScrollView(
//     //   child: Column(children: rr),
//     // );

//     return SingleChildScrollView(
//       child: Column(children: rr),
//     );
//   }

//   // ListView _build3(BuildContext context, int index, SessionGroup sessionGroup) {
//   //   return ListView.builder(
//   //     shrinkWrap: true,
//   //     padding: const EdgeInsets.all(8),
//   //     itemCount: sessionGroup.session.length,
//   //     itemBuilder: (BuildContext context, int index) {
//   //       return _build4(context, index, sessionGroup.session);
//   //     },
//   //   );
//   // }

//   Widget _build4(BuildContext context, int index, List<Session> sessions) {
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
//     return LimitedBox(
//       maxHeight: 200,
//       maxWidth: 200,
//       child: ListTile(
//         leading: Text(dateStr),
//         title: Text(title),
//         subtitle: Text(session.sessionCode),
//       ),
//     );
//   }
// }
