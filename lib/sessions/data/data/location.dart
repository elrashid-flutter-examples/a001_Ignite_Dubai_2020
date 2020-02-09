import 'package:co_elrashid_ignite/sessions/data/data/normal_sessions.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<String, List<Session>> sessions = <String, List<Session>>{};

Future<List<Session>> getLocationSessions(String location) async {
  print("getLocationSessions $location ");
  if (sessions[location] == null) {
    sessions[location] = (await getNormalSessions())
        .where((l) => l.location == location)
        .toList();
    sessions[location].sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return sessions[location];
}
