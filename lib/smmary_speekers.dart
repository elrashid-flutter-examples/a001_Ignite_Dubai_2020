import 'dart:convert';
import 'dart:io';

import 'sessions.dart';

void main() {
  var _sessions = getSessions();
  var _speakers = <Speaker>[];
  _sessions.where((w) => w.speakerIds.length > 0).forEach((_session) {
    for (var i = 0; i < _session.speakerIds.length; i++) {
      var _speaker = Speaker(
        _session.speakerIds[i],
        _session.speakerNames[i],
        _session.speakerCompanies[i],
      );
      _speakers.add(_speaker);
    }
  });
  _speakers = _speakers.toSet().toList();
  print("total Speakers : ${_speakers.length}");
  final jsonfilename = 'speakers.json';
  final csvfilename = 'speakers.csv';
  JsonEncoder encoder = new JsonEncoder.withIndent(' ');
  String json = encoder.convert(_speakers);
  new File(jsonfilename).writeAsString(json);
  new File(csvfilename).writeAsString(_speakers
      .map((m) => "${m.speakerId}\t${m.speakerName}\t${m.speakerCompany}")
      .join("\n"));
 
}

class Speaker {
  String speakerId;
  String speakerName;
  String speakerCompany;
  Speaker(
    this.speakerId,
    this.speakerName,
    this.speakerCompany,
  );

  @override
  bool operator ==(other) {
    // Dart ensures that operator== isn't called with null
    if (other == null) {
      return false;
    }
    if (other is! Speaker) {
      return false;
    }
    return (speakerId == (other as Speaker).speakerId) &&
        (speakerId == (other as Speaker).speakerId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speakerId'] = this.speakerId;
    data['speakerName'] = this.speakerName;
    data['speakerCompany'] = this.speakerCompany;
    return data;
  }

  int _hashCode;
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = speakerId.hashCode;
    }
    return _hashCode;
  }
}
