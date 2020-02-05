import 'dart:convert';

import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:flutter/services.dart';

List<Session> _sessions;
Future<List<Session>> getSessions() async {
  if (_sessions == null) {
    var sessionsData = await rootBundle.loadString('assets/sessions.json');

    _sessions = new List<Session>();
    var sessionsJson = json.decode(sessionsData);
    sessionsJson
        .forEach((element) => _sessions.add(new Session.fromJson(element)));
  }

  return _sessions;
}
