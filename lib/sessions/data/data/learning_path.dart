import 'package:co_elrashid_ignite/sessions/data/data/normal_sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<String, List<Session>> sessions = <String, List<Session>>{};

Future<List<Session>> getLearningPathSessions(String learningPath) async {
  print("getLearningPathSessions $learningPath ");
  if (sessions[learningPath] == null) {
    sessions[learningPath] = (await getNormalSessions())
        .where((l) => l.learningPath == learningPath)
        .toList();
    sessions[learningPath].sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return sessions[learningPath];
}
