export 'package:co_elrashid_ignite/sessions/utilities/get_random_color.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

Map<String, Map<String, Color>> _assgindColors = <String, Map<String, Color>>{};
Color getRandomColor(String group, String key) {
  if (_assgindColors[group] == null) _assgindColors[group] = {};
  if (_assgindColors[group][key] == null) {
    _assgindColors[group][key] =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(0.3);
  }
  return _assgindColors[group][key];
}

List<SesstionFilterEntry> getFilters() {
  List<SesstionFilterEntry> _filters = List();
  if (_assgindColors[learningPathKey] != null) {
    _assgindColors[learningPathKey]
        .forEach((k, v) => _filters.add(SesstionFilterEntry(k, v)));
  }

  return _filters;
}


class SesstionFilterEntry {
  const SesstionFilterEntry(this.name, this.color);
  final String name;
  final Color color;
}
var learningPathKey = "LearningPath";
var locationPathKey = "Location";
