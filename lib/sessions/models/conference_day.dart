import 'package:co_elrashid_ignite/sessions/models/session_group.dart';

class ConferenceDay {
  int day;
  ConferenceDay(
    this.day,
    this.sessionsGroups,
  );
  List<SessionGroup> sessionsGroups;
}
