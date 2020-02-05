import 'package:co_elrashid_ignite/sessions/data/day/sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<int, List<SessionGroup>> _sessionsGroups = <int, List<SessionGroup>>{};

Future<List<SessionGroup>> getSessionsGroups(int day) async {
  if (_sessionsGroups[day] == null) {
    _sessionsGroups[day] = (await getDaySessions(day))
        .map((m) => SessionGroup(m.startDateTime, m.endDateTime))
        .toSet()
        .toList();
    _sessionsGroups[day].sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }

  _sessionsGroups[day].forEach(
    (f) async => f.sessions = (await getDaySessions(day))
        .where((w) =>
            w.startDateTime == f.startDateTime &&
            w.endDateTime == f.endDateTime)
        .toList(),
  );

  return _sessionsGroups[day];
}
