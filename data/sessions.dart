import 'dart:convert';
import 'dart:core';

import 'dart:io';

List<Session> _sessions;
Future<List<Session>> getSessions() async {
  var sessionsData = await new File("Sessions.json").readAsString();

  if (_sessions == null) {
    _sessions = new List<Session>();
    var sessionsJson = json.decode(sessionsData);
    sessionsJson
        .forEach((element) => _sessions.add(new Session.fromJson(element)));
  }

  return _sessions;
}

class Session {
  double searchScore;
  String sessionId;
  String sessionInstanceId;
  String sessionCode;
  String sessionCodeNormalized;
  String title;
  String sortTitle;
  int sortRank;
  String description;
  String registrationLink;
  String startDateTime;
  String endDateTime;
  int durationInMinutes;
  String sessionType;
  String sessionTypeLogical;
  String learningPath;
  String level;
  String format;
  String topic;
  String sessionTypeId;
  bool isMandatory;
  bool visibleToAnonymousUsers;
  bool visibleInSessionListing;
  String techCommunityDiscussionId;
  List<String> speakerIds;
  List<String> speakerNames;
  List<String> speakerCompanies;
  String links;
  String lastUpdate;
  String techCommunityUrl;
  String location;

  List<Session> siblingModules;

  Session(
      {this.searchScore,
      this.sessionId,
      this.sessionInstanceId,
      this.sessionCode,
      this.sessionCodeNormalized,
      this.title,
      this.sortTitle,
      this.sortRank,
      this.description,
      this.registrationLink,
      this.startDateTime,
      this.endDateTime,
      this.durationInMinutes,
      this.sessionType,
      this.sessionTypeLogical,
      this.learningPath,
      this.level,
      this.format,
      this.topic,
      this.sessionTypeId,
      this.isMandatory,
      this.visibleToAnonymousUsers,
      this.visibleInSessionListing,
      this.techCommunityDiscussionId,
      this.speakerIds,
      this.speakerNames,
      this.speakerCompanies,
      this.links,
      this.lastUpdate,
      this.techCommunityUrl,
      this.location,
      this.siblingModules});

  Session.fromJson(Map<String, dynamic> json) {
    searchScore = json['@search.score'];
    sessionId = json['sessionId'].toString();
    sessionInstanceId = json['sessionInstanceId'];
    sessionCode = json['sessionCode'];
    sessionCodeNormalized = json['sessionCodeNormalized'];
    title = json['title'];
    sortTitle = json['sortTitle'];
    sortRank = json['sortRank'];
    description = json['description'];
    registrationLink = json['registrationLink'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    durationInMinutes = json['durationInMinutes'];
    sessionType = json['sessionType'];
    sessionTypeLogical = json['sessionTypeLogical'];
    learningPath = json['learningPath'];
    level = json['level'];
    format = json['format'];
    topic = json['topic'];
    sessionTypeId = json['sessionTypeId'];
    isMandatory = json['isMandatory'];
    visibleToAnonymousUsers = json['visibleToAnonymousUsers'];
    visibleInSessionListing = json['visibleInSessionListing'];
    techCommunityDiscussionId = json['techCommunityDiscussionId'];
    speakerIds = json['speakerIds'].cast<String>();
    speakerNames = json['speakerNames'].cast<String>();
    speakerCompanies = json['speakerCompanies'].cast<String>();
    links = json['links'];
    lastUpdate = json['lastUpdate'];
    techCommunityUrl = json['techCommunityUrl'];
    location = json['location'];
    // siblingModules = json['siblingModules'].cast<Session>();
    //  siblingModules = json['siblingModules'].map((Map xx)=> Session.fromJson(xx)).toList();

    if (json['siblingModules'] != null)
      siblingModules = List<Session>.from(
          json['siblingModules'].map((i) => Session.fromJson(i)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@search.score'] = this.searchScore;
    data['sessionId'] = this.sessionId;
    data['sessionInstanceId'] = this.sessionInstanceId;
    data['sessionCode'] = this.sessionCode;
    data['sessionCodeNormalized'] = this.sessionCodeNormalized;
    data['title'] = this.title;
    data['sortTitle'] = this.sortTitle;
    data['sortRank'] = this.sortRank;
    data['description'] = this.description;
    data['registrationLink'] = this.registrationLink;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['durationInMinutes'] = this.durationInMinutes;
    data['sessionType'] = this.sessionType;
    data['sessionTypeLogical'] = this.sessionTypeLogical;
    data['learningPath'] = this.learningPath;
    data['level'] = this.level;
    data['format'] = this.format;
    data['topic'] = this.topic;
    data['sessionTypeId'] = this.sessionTypeId;
    data['isMandatory'] = this.isMandatory;
    data['visibleToAnonymousUsers'] = this.visibleToAnonymousUsers;
    data['visibleInSessionListing'] = this.visibleInSessionListing;
    data['techCommunityDiscussionId'] = this.techCommunityDiscussionId;
    data['speakerIds'] = this.speakerIds;
    data['speakerNames'] = this.speakerNames;
    data['speakerCompanies'] = this.speakerCompanies;
    data['links'] = this.links;
    data['lastUpdate'] = this.lastUpdate;
    data['techCommunityUrl'] = this.techCommunityUrl;
    data['location'] = this.location;
    data['siblingModules'] = this.siblingModules;
    return data;
  }
}

Future<List<Speaker>> getSpeakersFormSessions() async {
  var _sessions = await getSessions();
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
  return _speakers;
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
