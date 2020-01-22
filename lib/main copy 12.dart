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
//         body: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints viewportConstraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: viewportConstraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       Flexible(
//                         child: Row(
//                           children: <Widget>[
//                             Text("hi"),
//                             CustomScrollView(
//                               slivers: [
//                                 SliverList(
//                                   delegate: SliverChildListDelegate(<Widget>[
//                                     Text(
//                                         "It means our Widget start from 0.0 from the X axis and 76.0 from the Y axis from TOP-LEFT."),
//                                   ]),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
