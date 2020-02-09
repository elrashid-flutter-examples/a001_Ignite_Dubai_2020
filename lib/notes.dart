import 'dart:convert';
import 'dart:io';

import 'package:co_elrashid_ignite/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

var uuid = Uuid();

Future<List<Note>> getSessionNotes(String sessionId) async {
  final notes = (await getNotes());
  print(notes);
  var sessionNotes = notes.where((w) => w.sessionId == sessionId).toList();
  print(sessionNotes);

  return sessionNotes;
}

Future<Note> addNote(Note note) async {
  try {
    Directory notesDir = await getNotesDir();
    var guid = uuid.v1();
    note.id = guid;
    note.isDeleted = false;
    // final notePath =
    //     path.normalize(path.join(notesDir.path, "${note.id}.json"));
    final notePath = "${notesDir.path}/${note.id}.json";
    final noteFile = File(notePath);
    final json = jsonEncode(note);
    print(json);
    await noteFile.writeAsString(json);
  } catch (e) {
    print(e);
  }
  return note;
}

Future<bool> updateNote(Note note) async {
  try {
    print("updateNote");
    print(jsonEncode(note));
    Directory notesDir = await getNotesDir();
    final notePath =
        path.normalize(path.join(notesDir.path, "${note.id}.json"));
    final noteFile = File(notePath);
    final json = jsonEncode(note);
    await noteFile.writeAsString(json);
  } catch (e) {
    print(e);
    return true;
  }
  return false;
}

Future<List<Note>> getNotes() async {
  // if (notes = null) {
  notes = <Note>[];
  try {
    final notesDir = await getNotesDir();
    final fileEntities = notesDir.listSync();
    for (var fileEntity in fileEntities) {
      try {
        final filetext = await File(fileEntity.path).readAsString();
        final json = jsonDecode(filetext);
        final note = Note.fromJson(json);
        notes.add(note);
      } catch (e) {
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
  // }
  return notes;
}

Future<Directory> getNotesDir() async {
  final appDirPath = (await getApplicationDocumentsDirectory()).path;
//flutter: FileSystemException: Creation failed, path = '/note' (OS Error: Permission denied, errno = 13)
// path.join  not working only output /note
  // final notesDirPath = path.normalize(path.join(appDirPath, "/note/"));

  final notesDirPath = (appDirPath + "/note");

  final notesDir = Directory(notesDirPath);
  notesDir.createSync(recursive: true);
  return notesDir;
}

List<Note> notes;
