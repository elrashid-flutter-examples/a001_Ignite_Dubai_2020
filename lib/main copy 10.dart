// import 'package:co_elrashid_ignite/sessions.dart';
// import 'package:flutter/material.dart';
// import 'dart:core';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// GlobalKey _keyRed = GlobalKey();

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     var sessionsGroups = getNormalDay01SessionsGroups();

//     return MaterialApp(
//       home: Scaffold(
//         body: Column(
//           children: <Widget>[
//             Flexible(
//               child: Row(
//                 children: <Widget>[
//                   Text("hi"),
//                   Expanded(
//                     child: ListView(
//                       // shrinkWrap: true,
//                       children: [
//                         Text(
//                             "It means our Widget start from 0.0 from the X axis and 76.0 from the Y axis from TOP-LEFT."),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   var sessionsGroups = getNormalDay01SessionsGroups();

//   //   return MaterialApp(
//   //     home: Scaffold(
//   //       body: _build1(context, sessionsGroups),
//   //     ),
//   //   );
//   // }

//   Widget _build1(BuildContext context, List<SessionGroup> sessionGroups) {
//     var r = <TableRow>[];
//     for (var sessionGroup in sessionGroups) {
//       r.add(_build2(sessionGroup));
//     }
//     return Table(children: r);
//   }

//   TableRow _build2(SessionGroup sessionGroup) {
//     var startDate = DateTime.parse(sessionGroup.startDateTime).toLocal();
//     var endDate = DateTime.parse(sessionGroup.endDateTime).toLocal();
//     var dateStr =
//         "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";

//     return TableRow(
//       children: <Widget>[
//         TableCell(
//           child: Text(dateStr),
//         ),
//         TableCell(
//           child: _build3(context, sessionGroup),
//           verticalAlignment: TableCellVerticalAlignment.baseline,
//         ),
//       ],
//     );
//   }

//   ListView _build3(BuildContext context, SessionGroup sessionGroup) {
//     return ListView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.all(8),
//       itemCount: sessionGroup.sessions.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _build4(context, index, sessionGroup.sessions);
//       },
//     );
//   }

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
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
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
