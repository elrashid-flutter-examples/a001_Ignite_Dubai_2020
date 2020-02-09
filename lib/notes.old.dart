// import 'dart:convert';
// import 'dart:io';

// import 'package:co_elrashid_ignite/sessions/models/models.dart';
// import 'package:co_elrashid_ignite/sessions/widgets/session_cover.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';


// class NotesWidget extends StatefulWidget {
 
// // final String speakerId;
//  final Session session;

//   NotesWidget({Key key , this.session,}) : super(key: key);
//   @override
//   _NotesWidgetState createState() => _NotesWidgetState();
// }

// class _NotesWidgetState extends State<NotesWidget> {
//   TextEditingController _controller;

//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   var notes = <Note>[];
//   var _notesWidgets = <int, Widget>{};
//   var _notesControllers = <int, TextEditingController>{};
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           notes.add(Note(text: "",speakerId: widget.session.speakerIds.);
//           setState(() {});
//         },
//         child: Icon(
//           Icons.add,
//         ),
//       ),
//       appBar: AppBar(title: Text("Notes")),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             SessionCoverWidget(widget.session),
//             Expanded(
//               child: Container(
//                 child: ListView.builder(
//                     itemCount: notes.length,
//                     itemBuilder: (context, index) {
//                       if (_notesControllers[index] == null)
//                         _notesControllers[index] = TextEditingController();
//                       if (_notesWidgets[index] == null)
//                         _notesWidgets[index] = Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextField(
//                                 keyboardType: TextInputType.multiline,
//                                 decoration: new InputDecoration(
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.greenAccent, width: 5.0),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.red, width: 5.0),
//                                   ),
//                                   hintText: 'Note .......',
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 maxLines: null,
//                                 controller: _notesControllers[index],
//                                 onChanged: (value) {
//                                   notes[index] = value;
//                                 },
//                               ),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 IconButton(
//                                   icon: Icon(Icons.keyboard_hide),
//                                   onPressed: () {
//                                     FocusScope.of(context).unfocus();
//                                     setState(() {});
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.content_copy),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.save),
//                                   onPressed: () {
//                                     notes.add(_controller.text);
//                                     _controller.clear();
//                                     FocusScope.of(context).unfocus();
//                                     setState(() {});
//                                   },
//                                 ),
//                                 Expanded(child: Container()),
//                                 IconButton(
//                                   icon: Icon(Icons.delete),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             )
//                           ],
//                         );
//                       _notesControllers[index].text = notes[index];
//                       return _notesWidgets[index];
//                     }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Note {
//   String id;
//   String speakerId;
//   String sessionId;
//   String day;
//   String text;
//   bool isDeleted;
//   Note({
//     this.id,
//     this.speakerId,
//     this.sessionId,
//     this.day,
//     this.text,
//     this.isDeleted,
//   });

//   Note.fromJson(Map<String, dynamic> json) {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     this.id = data['id'];
//     this.speakerId = data['speakerId'];
//     this.sessionId = data['sessionId'];
//     this.text = data['text'];
//     this.day = data['day'];
//     this.isDeleted = data['isDeleted'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['speakerId'] = this.speakerId;
//     data['sessionId'] = this.sessionId;
//     data['text'] = this.text;
//     data['day'] = this.day;
//     data['isDeleted'] = this.isDeleted;
//     return data;
//   }
// }

// Future<List<Note>> getSessionNotes(String sessionId) async {
//   final notes = (await getNotes());
//   var sessionNotes = notes.where((w) => w.sessionId == sessionId).toList();
//   return sessionNotes;
// }

// Future<Note> addNote(Note note) async {
//   try {
//     Directory notesDir = await getNotesDir();
//     var guid = uuid.v1();
//     note.id = guid;
//     note.isDeleted = false;
//     final notePath =
//         path.normalize(path.join(notesDir.path, "${note.id}.json"));
//     final noteFile = File(notePath);
//     final json = jsonEncode(Note);
//     await noteFile.writeAsString(json);
//   } catch (e) {
//     print(e);
//   }
//   return note;
// }

// Future<bool> updateNote(Note note) async {
//   try {
//     Directory notesDir = await getNotesDir();
//     final notePath =
//         path.normalize(path.join(notesDir.path, "${note.id}.json"));
//     final noteFile = File(notePath);
//     final json = jsonEncode(Note);
//     await noteFile.writeAsString(json);
//   } catch (e) {
//     print(e);
//     return true;
//   }
//   return false;
// }

// Future<List<Note>> getNotes() async {
//   // if (notes = null) {
//   notes = <Note>[];
//   try {
//     final notesDir = await getNotesDir();
//     final fileEntities = notesDir.listSync();
//     for (var fileEntity in fileEntities) {
//       try {
//         final filetext = await File(fileEntity.path).readAsString();
//         final json = jsonDecode(filetext);
//         final note = Note.fromJson(json);
//         notes.add(note);
//       } catch (e) {
//         print(e);
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
//   // }
//   return notes;
// }

// Future<Directory> getNotesDir() async {
//   final appDirPath = (await getApplicationDocumentsDirectory()).path;
//   final notesDirPath = path.normalize(path.join(appDirPath, "/note/"));
//   final notesDir = Directory(notesDirPath);
//   notesDir.createSync(recursive: true);
//   return notesDir;
// }

// List<Note> notes;
