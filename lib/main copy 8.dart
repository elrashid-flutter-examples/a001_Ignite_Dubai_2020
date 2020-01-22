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
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Text(
//                   'Headline',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(
//                   height: 200.0,
//                   child: ListView.builder(
//                     physics: ClampingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     itemCount: 15,
//                     itemBuilder: (BuildContext context, int index) => Card(
//                       child: Center(child: Text('Dummy Card Text')),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               'Demo Headline 2',
//               style: TextStyle(fontSize: 18),
//             ),
//             Card(
//               child: ListTile(
//                   title: Text('Motivation $int'),
//                   subtitle: Text('this is a description of the motivation')),
//             ),
//             Card(
//               child: ListTile(
//                   title: Text('Motivation $int'),
//                   subtitle: Text('this is a description of the motivation')),
//             ),
//             Card(
//               child: ListTile(
//                   title: Text('Motivation $int'),
//                   subtitle: Text('this is a description of the motivation')),
//             ),
//             Card(
//               child: ListTile(
//                   title: Text('Motivation $int'),
//                   subtitle: Text('this is a description of the motivation')),
//             ),
//             Card(
//               child: ListTile(
//                   title: Text('Motivation $int'),
//                   subtitle: Text('this is a description of the motivation')),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }

//   @override
//   Widget buildxxxx(BuildContext context) {
//     var sessionGroups = getNormalDay01SessionsGroups();
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//         title: Text("Slivers"),
//       ),
//       body: Column(
//         children: <Widget>[
//           new Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
//           new Expanded(
//             child: _build1(
//               context,
//               sessionGroups,
//             ),
//           ),
//         ],
//       ),
//     ));
//   }

//   Widget _build1(BuildContext context, List<SessionGroup> sessionGroups) {
//     return ListView.builder(
//         shrinkWrap: true,
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
//       _build3(context, index, sessionGroup),
//     ]);
//   }

//   ListView _build3(BuildContext context, int index, SessionGroup sessionGroup) {
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
//     return LimitedBox(
//       maxHeight: 200,
//       maxWidth: 200,
//       child: Center(
//         child: Card(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: Text(dateStr),
//                 title: Text(title),
//                 subtitle: Text(session.sessionCode),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }