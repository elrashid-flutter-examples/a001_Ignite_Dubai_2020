class Note {
  String id;
  String sessionId;
  List<String> speakerIds;
  String location;
  String learningPath;
  int day;
  String text;
  bool isDeleted;
  Note({
    this.id,
    this.sessionId,
    this.speakerIds,
    this.location,
    this.learningPath,
    this.day,
    this.text,
    this.isDeleted,
  });

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['sessionId'];
    speakerIds = json['speakerIds']?.cast<String>();
    location = json['location'];
    learningPath = json['learningPath'];
    day = json['day'];
    text = json['text'];
    isDeleted = json['isDeleted'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sessionId'] = this.sessionId;
    data['speakerIds'] = this.speakerIds;
    data['learningPath'] = this.learningPath;
    data['location'] = this.location;
    data['day'] = this.day;
    data['text'] = this.text;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}
