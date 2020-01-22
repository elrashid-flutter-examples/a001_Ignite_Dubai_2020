// import 'package:co_elrashid_ignite/sessions.dart';
// import 'package:flutter/material.dart';
// import 'dart:core';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     var sessions = getNormalSessions();

//     return MaterialApp(
//       home: Scaffold(
//         body: _build2(sessions),
//       ),
//     );
//   }

//   ListView _build1(List<Session> sessions) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: sessions.length,
//       itemBuilder: (BuildContext context, int index) {
//         var session = sessions[index];
//         var startDate = DateTime.parse(session.startDateTime).toLocal();
//         var endDate = DateTime.parse(session.endDateTime).toLocal();
//         var dateStr =
//             "${startDate.hour}:${startDate.minute}\n${endDate.hour}:${endDate.minute}";
//         var title = session.title.substring(
//             0, session.title.length > 100 ? 100 : session.title.length);
//         return ListTile(
//           leading: Text(dateStr), // Icon(Icons.album),
//           title: Text(title),
//           subtitle: Text(session.sessionCode),
//         );
//       },
//     );
//   }

//   Widget _build2() {
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const ListTile(
//               leading: Icon(Icons.album),
//               title: Text('The Enchanted Nightingale'),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//             ),
//             ButtonBar(
//               children: <Widget>[
//                 FlatButton(
//                   child: const Text('BUY TICKETS'),
//                   onPressed: () {/* ... */},
//                 ),
//                 FlatButton(
//                   child: const Text('LISTEN'),
//                   onPressed: () {/* ... */},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
