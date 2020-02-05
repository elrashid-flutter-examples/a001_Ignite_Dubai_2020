import 'package:co_elrashid_ignite/sessions/data/data/normal_sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<int, List<Session>> sessions = <int, List<Session>>{};

Future<List<Session>> getDaySessions(int day) async {
  print("getDaySessions $day ");
  if (sessions[day] == null) {
    sessions[day] = (await getNormalSessions())
        .where((l) => DateTime.parse(l.startDateTime).day == day)
        .toList();
    sessions[day].sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return sessions[day];
}
