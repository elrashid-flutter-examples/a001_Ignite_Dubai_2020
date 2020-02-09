import 'package:co_elrashid_ignite/sessions/data/data/normal_sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<String, List<Session>> sessions = <String, List<Session>>{};

Future<List<Session>> getSpeakerSessions(String speakerId) async {
  print("getSpeakerSessions $speakerId ");
  if (sessions[speakerId] == null) {
    sessions[speakerId] = (await getNormalSessions())
        .where((l) => l.speakerIds.contains(speakerId))
        .toList();
    sessions[speakerId].sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return sessions[speakerId];
}
