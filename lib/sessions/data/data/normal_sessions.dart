import 'package:co_elrashid_ignite/sessions/data/data/all.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

List<Session> _normalSessions;

Future<List<Session>> getNormalSessions() async {
  if (_normalSessions == null) {
    _normalSessions = (await getSessions())
        .where((l) => l.sessionType != "Learning Path")
        .toList();
    _normalSessions.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }

  return _normalSessions;
}
