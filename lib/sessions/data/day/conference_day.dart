import 'package:co_elrashid_ignite/sessions/data/day/sessions_groups.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';

Map<int, ConferenceDay> _conferenceDay = <int, ConferenceDay>{};
Future<ConferenceDay> getConferenceDay(int day) async {
  if (_conferenceDay[day] == null) {
    _conferenceDay[day] = ConferenceDay(
      day,
      (await getSessionsGroups(day)),
    );
  }
  return _conferenceDay[day];
}
