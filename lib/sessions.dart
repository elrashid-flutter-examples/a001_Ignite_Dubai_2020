import 'dart:convert';
import 'dart:core';

List<Session> _sessions;
List<Session> getSessions() {
  if (_sessions == null) {
    _sessions = new List<Session>();
    var sessionsJson = json.decode(sessionsData);
    sessionsJson
        .forEach((element) => _sessions.add(new Session.fromJson(element)));
  }

  return _sessions;
}

List<Session> _normalSessions;

List<Session> getNormalSessions() {
  if (_normalSessions == null) {
    _normalSessions =
        getSessions().where((l) => l.sessionType != "Learning Path").toList();
    _normalSessions.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }

  return _normalSessions;
}

List<Session> _normalDay01Sessions;

List<Session> getNormalDay01Sessions(List<String> filters) {
  if (_normalDay01Sessions == null || _curtFilters != filters) {
    _normalDay01Sessions = getSessions()
        .where((l) =>
            l.sessionType != "Learning Path" &&
            (filters.length > 0 ? filters.contains(l.learningPath) : true) &&
            DateTime.parse(l.startDateTime).day == 10)
        .toList();
    _normalDay01Sessions.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return _normalDay01Sessions;
}

List<Session> _normalDay02Sessions;

List<Session> getNormalDay02Sessions() {
  if (_normalDay02Sessions == null) {
    _normalDay02Sessions = getSessions()
        .where((l) =>
            l.sessionType != "Learning Path" &&
            DateTime.parse(l.startDateTime).day == 11)
        .toList();
    _normalDay02Sessions.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }
  return _normalDay02Sessions;
}

List<SessionGroup> _normalDay01SessionsGroups;
List<String> _curtFilters;
List<SessionGroup> getNormalDay01SessionsGroups(List<String> filters) {
  if (_normalDay01SessionsGroups == null || _curtFilters != filters) {
    _normalDay01SessionsGroups = getNormalDay01Sessions(filters)
        .map((m) => SessionGroup(m.startDateTime, m.endDateTime))
        .toSet()
        .toList();
    _normalDay01SessionsGroups.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }

  _normalDay01SessionsGroups.forEach(
    (f) => f.sessions = getNormalDay01Sessions(filters)
        .where((w) =>
            w.startDateTime == f.startDateTime &&
            w.endDateTime == f.endDateTime)
        .toList(),
  );

  return _normalDay01SessionsGroups;
}

List<SessionGroup> _normalDay02SessionsGroups;
List<SessionGroup> getNormalDay02SessionsGroups() {
  if (_normalDay02SessionsGroups == null) {
    _normalDay02SessionsGroups = getNormalDay02Sessions()
        .map((m) => SessionGroup(m.startDateTime, m.endDateTime))
        .toSet()
        .toList();
    _normalDay02SessionsGroups.sort((a, b) => DateTime.parse(a.startDateTime)
        .compareTo(DateTime.parse(b.startDateTime)));
  }

  _normalDay02SessionsGroups.forEach(
    (f) => f.sessions = getNormalDay02Sessions()
        .where((w) =>
            w.startDateTime == f.startDateTime &&
            w.endDateTime == f.endDateTime)
        .toList(),
  );
  return _normalDay02SessionsGroups;
}

ConferenceDay _conferenceDay01;
ConferenceDay getConferenceDay01(List<String> filters) {
  if (_conferenceDay01 == null || _curtFilters != filters) {
    _conferenceDay01 = ConferenceDay(
      "1",
      getNormalDay01SessionsGroups(filters),
    );
  }
  return _conferenceDay01;
}

class ConferenceDay {
  String day;
  ConferenceDay(
    this.day,
    this.sessionsGroups,
  );
  List<SessionGroup> sessionsGroups;
}

class SessionGroup {
  String startDateTime;
  String endDateTime;
  SessionGroup(
    this.startDateTime,
    this.endDateTime,
  );

  String get dateStr {
    var _startDateLocal = DateTime.parse(startDateTime).toLocal();
    var _endDateLocal = DateTime.parse(endDateTime).toLocal();

    var _dateStr2 =
        "${_formatTime(_startDateLocal)}\n${_formatTime(_endDateLocal)}";
    var _dateStr = "${_formatTime(_startDateLocal)}";

    return _dateStr;
  }

  String _formatTime(DateTime time) {
    return "${_formatNumber(time.hour)}:${_formatNumber(time.minute)}";
  }

  String _formatNumber(int _number) {
    String _numberStr;
    if (_number < 10) {
      _numberStr = "0${_number}";
    } else {
      _numberStr = "${_number}";
    }
    return _numberStr;
  }

  List<Session> sessions;

  @override
  bool operator ==(other) {
    // Dart ensures that operator== isn't called with null
    if (other == null) {
      return false;
    }
    if (other is! SessionGroup) {
      return false;
    }
    return (startDateTime == (other as SessionGroup).startDateTime) &&
        (endDateTime == (other as SessionGroup).endDateTime);
  }

  int _hashCode;
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = (startDateTime + endDateTime).hashCode;
    }
    return _hashCode;
  }
  // when the key (description) is immutable and the only
  // member of the key you can just use
  // int get hashCode => description.hashCode

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

var sessionsData = '''
[
    {
        "@search.score":  1.0,
        "sessionId":  "86526",
        "sessionInstanceId":  "86526",
        "sessionCode":  "ADM20",
        "sessionCodeNormalized":  "ADM20",
        "title":  "Addressing top management issues with users and groups",
        "sortTitle":  "addressing top management issues with users and groups",
        "sortRank":  2147483647,
        "description":  "Efficient management of users, groups, and devices is core to ensuring your organization runs smoothly on Microsoft 365 services. Come learn tips and tricks on the best way to handle everyday challenges you face â€“ from ensuring a department sticks to their license budget, making sure youâ€™ve got access to those important emails when someone leaves, to setting up groups to enable modern teamwork.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907366",
        "speakerIds":  [
                           "707230"
                       ],
        "speakerNames":  [
                             "Andrew Malone"
                         ],
        "speakerCompanies":  [
                                 "Quality Training (Scotland) Ltd"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86523,
                                   "title":  "Onboarding and setup: Getting the most out of Microsoft 365",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "707230"
                                                  ],
                                   "speakerNames":  [
                                                        "Andrew Malone"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Come and learn about the new onboarding experiences we\u0027ve built in the Microsoft 365 Admin Center. These experiences empower you to learn about and activate the different components of your subscription and to easily understand what to do next with intelligent recommendations. We also cover how you can take your Office 365 subscription to Microsoft 365 with our tailored setup experiences.",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90732",
        "sessionInstanceId":  "90732",
        "sessionCode":  "THR30031",
        "sessionCodeNormalized":  "THR30031",
        "title":  "Azure and the command line â€“ options, tips and tricks",
        "sortTitle":  "azure and the command line â€“ options, tips and tricks",
        "sortRank":  2147483647,
        "description":  "If you love working from the command line, this session covers all the things you need to know to get the most out of the experience on Windows, Mac, and Linux. We start with Windows command line, then the new Terminal, and the Windows Subsystem for Linux (WSL). Then, we cover some interesting developments in the Azure Cloud Shell and show you how you can work with command line options in Visual Studio Code. By the end of this 15 minute session you\u0027ll have some new and interesting ways to control the cloud from your keyboard!",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T09:05:00+00:00",
        "endDateTime":  "2020-02-11T09:20:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Developing Cloud Native Applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "698031"
                       ],
        "speakerNames":  [
                             "Cassie Breviu"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85068",
        "sessionInstanceId":  "85068",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Azure fundamentals",
        "sortTitle":  "azure fundamentals",
        "sortRank":  2147483647,
        "description":  "Understand key cloud concepts and core services, including: storage, pricing, compute, messaging, networking, data, identity, and cloud security.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120815",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86430,
                                 "title":  "Discovering Microsoft Azure",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86431,
                                 "title":  "Azure networking basics",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715291"
                                                ],
                                 "speakerNames":  [
                                                      "Bradley Stewart"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86434,
                                 "title":  "Discovering Azure tooling and utilities",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "719728"
                                                ],
                                 "speakerNames":  [
                                                      "April Edwards"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86432,
                                 "title":  "Azure security fundamentals",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "707101"
                                                ],
                                 "speakerNames":  [
                                                      "Tiberiu George Covaci"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86429,
                                 "title":  "Storing data in Azure",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "717897"
                                                ],
                                 "speakerNames":  [
                                                      "Bernd Verst"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86433,
                                 "title":  "Exploring containers and orchestration in Azure",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "726799"
                                                ],
                                 "speakerNames":  [
                                                      "Hatim Nagarwala"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86447,
                                 "title":  "Keeping costs down in Azure",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86616,
                                 "title":  "What you need to know about governance in Azure",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86448,
                                 "title":  "Azure identity fundamentals",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "719747"
                                                ],
                                 "speakerNames":  [
                                                      "Roelf Zomerman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             },
                             {
                                 "sessionId":  86450,
                                 "title":  "Figuring out Azure functions",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715283"
                                                ],
                                 "speakerNames":  [
                                                      "Christian Nwamba"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                 "location":  "Sheikh Rashid Hall F"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86475",
        "sessionInstanceId":  "86475",
        "sessionCode":  "MCO20",
        "sessionCodeNormalized":  "MCO20",
        "title":  "Azure governance and management",
        "sortTitle":  "azure governance and management",
        "sortRank":  2147483647,
        "description":  "Tailwind Tradersâ€™ deployments are occurring in an ad hoc manner, primarily driven by lack of protocol and unapproved decisions by various operators or employees. Some deployments even violate the organization\u0027s compliance obligations, such as being deployed in an unencrypted manner without DR protection. After bringing their existing IaaS VM fleet under control, Tailwind Traders wants to ensure future deployments comply with policy and organizational requirements.  \\r\\n\\r\\nIn this session, walk through the processes and technologies that will keep Tailwind Tradersâ€™ deployments in good standing with the help of Azure Blueprints, Azure Policy, role-based access control (RBAC), and more.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Managing cloud operations",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907381",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86473,
                                   "title":  "IaaS VM operations",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "724361"
                                                  ],
                                   "speakerNames":  [
                                                        "Pierre Roman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In recent months, Tailwind Traders has been having issues with keeping their sprawling IaaS VM deployment under control, leading to mismanaged resources and inefficient processes.  \\r\\nIn this session, look into how Tailwind Traders can ensure their VMs are properly managed and maintained with the same care in Azure as they were in Tailwind Trader\u0027s on-premises data centers.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86448",
        "sessionInstanceId":  "86448",
        "sessionCode":  "AFUN90",
        "sessionCodeNormalized":  "AFUN90",
        "title":  "Azure identity fundamentals",
        "sortTitle":  "azure identity fundamentals",
        "sortRank":  2147483647,
        "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907393",
        "speakerIds":  [
                           "719747"
                       ],
        "speakerNames":  [
                             "Roelf Zomerman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86431",
        "sessionInstanceId":  "86431",
        "sessionCode":  "AFUN20",
        "sessionCodeNormalized":  "AFUN20",
        "title":  "Azure networking basics",
        "sortTitle":  "azure networking basics",
        "sortRank":  2147483647,
        "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907399",
        "speakerIds":  [
                           "715291"
                       ],
        "speakerNames":  [
                             "Bradley Stewart"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86432",
        "sessionInstanceId":  "86432",
        "sessionCode":  "AFUN40",
        "sessionCodeNormalized":  "AFUN40",
        "title":  "Azure security fundamentals",
        "sortTitle":  "azure security fundamentals",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907397",
        "speakerIds":  [
                           "707101"
                       ],
        "speakerNames":  [
                             "Tiberiu George Covaci"
                         ],
        "speakerCompanies":  [
                                 "Cloudeon A/S"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86617",
        "sessionInstanceId":  "86617",
        "sessionCode":  "MDEV30",
        "sessionCodeNormalized":  "MDEV30",
        "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
        "sortTitle":  "building modern enterprise-grade collaboration solutions with microsoft teams and sharepoint",
        "sortRank":  2147483647,
        "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907333",
        "speakerIds":  [
                           "704728"
                       ],
        "speakerNames":  [
                             "Bill Ayers"
                         ],
        "speakerCompanies":  [
                                 "Flow Simulation Ltd"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86604,
                                   "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "606930"
                                                  ],
                                   "speakerNames":  [
                                                        "Kyle Marsh"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86605,
                                   "title":  "Microsoft Graph: a primer for developers",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86619,
                                   "title":  "Transform everyday business processes with Microsoft 365 platform tools",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
                                   "location":  "Sheikh Rashid Hall A"
                               },
                               {
                                   "sessionId":  86618,
                                   "title":  "Windows 10: The developer platform, and modern application development",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719772"
                                                  ],
                                   "speakerNames":  [
                                                        "Giorgio Sardo"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
                                   "location":  "Sheikh Rashid Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86508",
        "sessionInstanceId":  "86508",
        "sessionCode":  "OPS10",
        "sessionCodeNormalized":  "OPS10",
        "title":  "Building the foundation for modern ops: Monitoring",
        "sortTitle":  "building the foundation for modern ops: monitoring",
        "sortRank":  2147483647,
        "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907372",
        "speakerIds":  [
                           "722025"
                       ],
        "speakerNames":  [
                             "James Toulman"
                         ],
        "speakerCompanies":  [
                                 "Digital Energy"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86506,
                                   "title":  "Responding to incidents",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86505,
                                   "title":  "Learning from failure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Incidents will happenâ€”thereâ€™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86522,
                                   "title":  "Deployment practices for greater reliability",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722024"
                                                  ],
                                   "speakerNames":  [
                                                        "Hosam Kamel"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86524,
                                   "title":  "Preparing for growth: Capacity planning and scaling",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â€œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86400",
        "sessionInstanceId":  "86400",
        "sessionCode":  "DYNA30",
        "sessionCodeNormalized":  "DYNA30",
        "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
        "sortTitle":  "configuring and managing dynamics 365 customer service and dynamics 365 field service â€“ establish a proactive service organization",
        "sortRank":  2147483647,
        "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907408",
        "speakerIds":  [
                           "702496"
                       ],
        "speakerNames":  [
                             "Antti Pajunen"
                         ],
        "speakerCompanies":  [
                                 "Innofactor"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86401,
                                   "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86402,
                                   "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86404,
                                   "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707057"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Al Chami"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86399,
                                   "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704342"
                                                  ],
                                   "speakerNames":  [
                                                        "Elena Djonova"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86404",
        "sessionInstanceId":  "86404",
        "sessionCode":  "DYNA40",
        "sessionCodeNormalized":  "DYNA40",
        "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
        "sortTitle":  "configuring and managing dynamics 365 finance â€“ modernize finance and supply chain",
        "sortRank":  2147483647,
        "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907407",
        "speakerIds":  [
                           "707057"
                       ],
        "speakerNames":  [
                             "Ahmed Al Chami"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86401,
                                   "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86402,
                                   "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86400,
                                   "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86399,
                                   "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704342"
                                                  ],
                                   "speakerNames":  [
                                                        "Elena Djonova"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86399",
        "sessionInstanceId":  "86399",
        "sessionCode":  "DYNA50",
        "sessionCodeNormalized":  "DYNA50",
        "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
        "sortTitle":  "configuring and managing dynamics 365 retail - enable connected retail",
        "sortRank":  2147483647,
        "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907406",
        "speakerIds":  [
                           "704342"
                       ],
        "speakerNames":  [
                             "Elena Djonova"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86401,
                                   "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86402,
                                   "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86400,
                                   "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86404,
                                   "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707057"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Al Chami"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86402",
        "sessionInstanceId":  "86402",
        "sessionCode":  "DYNA20",
        "sessionCodeNormalized":  "DYNA20",
        "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
        "sortTitle":  "configuring and managing dynamics 365 sales and dynamics 365 marketing â€“ establish connected sales and marketing",
        "sortRank":  2147483647,
        "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907409",
        "speakerIds":  [
                           "702496"
                       ],
        "speakerNames":  [
                             "Antti Pajunen"
                         ],
        "speakerCompanies":  [
                                 "Innofactor"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86401,
                                   "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86400,
                                   "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86404,
                                   "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707057"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Al Chami"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86399,
                                   "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704342"
                                                  ],
                                   "speakerNames":  [
                                                        "Elena Djonova"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86598",
        "sessionInstanceId":  "86598",
        "sessionCode":  "SOYS20",
        "sessionCodeNormalized":  "SOYS20",
        "title":  "Connect the organization and engage people with SharePoint, Yammer and Microsoft Stream",
        "sortTitle":  "connect the organization and engage people with sharepoint, yammer and microsoft stream",
        "sortRank":  2147483647,
        "description":  "Company leaders recognize the need to transform their workforce, and organizations where employees are truly engaged report improved employee retention, customer satisfaction, sales metrics, and overall profitability. Microsoft 365 delivers the modern workplace and solutions that help you engage employees across organizational boundaries, generations and geographies, so you can empower your people to achieve more. Learn how SharePoint, Yammer and Stream work together to empower leaders to connect with their organizations, to align people to common goals, and to drive cultural transformation. Dive into the latest innovations including live events, new Yammer experiences and integrations, the intelligent intranet featuring home sites.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Content collaboration, Communication, and Engagement in the Intelligent Workplace",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907344",
        "speakerIds":  [
                           "703050"
                       ],
        "speakerNames":  [
                             "Christopher McNulty"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86595,
                                   "title":  "Content collaboration and protection with SharePoint, OneDrive and Microsoft Teams",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint connects the workplace and powers content collaboration. OneDrive connects you with all your files in Office 365. Teams is the hub for teamwork. Together, SharePoint, OneDrive and Teams are greater than the sum of their parts. Join us for an overview of how these products interact with each other and learn about latest integrations we are working on to bring the richness of SharePoint directly into Teams experiences and vice versa. We\u0027ll explore new innovations for sharing and working together with data using SharePoint lists, and no-code productivity solutions that streamline business processes. Finally, weâ€™ll explore how to structure teams and projects with hub sites.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86596,
                                   "title":  "The intelligent intranet: Transform communications and digital employee experiences",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The intelligent intranet in Microsoft 365 connects the workplace to power collaboration, employee engagement, and knowledge management.  In this demo-heavy session, explore the latest innovations to help you transform your intranet into a rich, mobile-ready employee experiences that\u0027s dynamic, personalized, social and actionable. The session will explore new innovations for sites and portals, showcase common intranet scenarios, and provide actionable guidance toward optimal intranet architecture and governance.",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86600,
                                   "title":  "Harness collective knowledge with intelligent content services and Microsoft Search",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn about the most significant innovations ever unveiled for knowledge management and intelligent content services in Microsoft 365. Get the latest updates on Microsoft Search and other experiences that connect you with knowledge, insights, expertise, answers and actions, within your everyday experiences across Microsoft 365.",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86416",
        "sessionInstanceId":  "86416",
        "sessionCode":  "POWA40",
        "sessionCodeNormalized":  "POWA40",
        "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
        "sortTitle":  "connecting power apps, microsoft power automate, power bi, and the common data service with data",
        "sortRank":  2147483647,
        "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907402",
        "speakerIds":  [
                           "715251"
                       ],
        "speakerNames":  [
                             "Ali Jibran Sayed Mohammed"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86403,
                                   "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86415,
                                   "title":  "Intelligent automation with Microsoft Power Automate",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86417,
                                   "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86418,
                                   "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
                                   "location":  "Sheikh Rashid Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86488",
        "sessionInstanceId":  "86488",
        "sessionCode":  "APPS40",
        "sessionCodeNormalized":  "APPS40",
        "title":  "Consolidating infrastructure with Azure Kubernetes Service",
        "sortTitle":  "consolidating infrastructure with azure kubernetes service",
        "sortRank":  2147483647,
        "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907384",
        "speakerIds":  [
                           "721311"
                       ],
        "speakerNames":  [
                             "Jessica Deen"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86487,
                                   "title":  "Options for building and running your app in the cloud",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86486,
                                   "title":  "Options for data in the cloud",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86489,
                                   "title":  "Modernizing your application with containers",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86490,
                                   "title":  "Taking your app to the next level with monitoring, performance, and scaling",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86595",
        "sessionInstanceId":  "86595",
        "sessionCode":  "SOYS10",
        "sessionCodeNormalized":  "SOYS10",
        "title":  "Content collaboration and protection with SharePoint, OneDrive and Microsoft Teams",
        "sortTitle":  "content collaboration and protection with sharepoint, onedrive and microsoft teams",
        "sortRank":  2147483647,
        "description":  "SharePoint connects the workplace and powers content collaboration. OneDrive connects you with all your files in Office 365. Teams is the hub for teamwork. Together, SharePoint, OneDrive and Teams are greater than the sum of their parts. Join us for an overview of how these products interact with each other and learn about latest integrations we are working on to bring the richness of SharePoint directly into Teams experiences and vice versa. We\u0027ll explore new innovations for sharing and working together with data using SharePoint lists, and no-code productivity solutions that streamline business processes. Finally, weâ€™ll explore how to structure teams and projects with hub sites.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Content collaboration, Communication, and Engagement in the Intelligent Workplace",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907345",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86598,
                                   "title":  "Connect the organization and engage people with SharePoint, Yammer and Microsoft Stream",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Company leaders recognize the need to transform their workforce, and organizations where employees are truly engaged report improved employee retention, customer satisfaction, sales metrics, and overall profitability. Microsoft 365 delivers the modern workplace and solutions that help you engage employees across organizational boundaries, generations and geographies, so you can empower your people to achieve more. Learn how SharePoint, Yammer and Stream work together to empower leaders to connect with their organizations, to align people to common goals, and to drive cultural transformation. Dive into the latest innovations including live events, new Yammer experiences and integrations, the intelligent intranet featuring home sites.",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86596,
                                   "title":  "The intelligent intranet: Transform communications and digital employee experiences",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The intelligent intranet in Microsoft 365 connects the workplace to power collaboration, employee engagement, and knowledge management.  In this demo-heavy session, explore the latest innovations to help you transform your intranet into a rich, mobile-ready employee experiences that\u0027s dynamic, personalized, social and actionable. The session will explore new innovations for sites and portals, showcase common intranet scenarios, and provide actionable guidance toward optimal intranet architecture and governance.",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86600,
                                   "title":  "Harness collective knowledge with intelligent content services and Microsoft Search",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn about the most significant innovations ever unveiled for knowledge management and intelligent content services in Microsoft 365. Get the latest updates on Microsoft Search and other experiences that connect you with knowledge, insights, expertise, answers and actions, within your everyday experiences across Microsoft 365.",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86579",
        "sessionInstanceId":  "86579",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Content collaboration, communication, and engagement in the intelligent workplace",
        "sortTitle":  "content collaboration, communication, and engagement in the intelligent workplace",
        "sortRank":  2147483647,
        "description":  " Learn how the experiences in Microsoft 365 integrate to connect the intelligent workplace, powering collaboration, employee engagement and communication across devices, on the web, in desktop and mobile apps, and in Microsoft Teams.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Content collaboration, Communication, and Engagement in the Intelligent Workplace",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120800",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86595,
                                 "title":  "Content collaboration and protection with SharePoint, OneDrive and Microsoft Teams",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "SharePoint connects the workplace and powers content collaboration. OneDrive connects you with all your files in Office 365. Teams is the hub for teamwork. Together, SharePoint, OneDrive and Teams are greater than the sum of their parts. Join us for an overview of how these products interact with each other and learn about latest integrations we are working on to bring the richness of SharePoint directly into Teams experiences and vice versa. We\u0027ll explore new innovations for sharing and working together with data using SharePoint lists, and no-code productivity solutions that streamline business processes. Finally, weâ€™ll explore how to structure teams and projects with hub sites.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86598,
                                 "title":  "Connect the organization and engage people with SharePoint, Yammer and Microsoft Stream",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "703050"
                                                ],
                                 "speakerNames":  [
                                                      "Christopher McNulty"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Company leaders recognize the need to transform their workforce, and organizations where employees are truly engaged report improved employee retention, customer satisfaction, sales metrics, and overall profitability. Microsoft 365 delivers the modern workplace and solutions that help you engage employees across organizational boundaries, generations and geographies, so you can empower your people to achieve more. Learn how SharePoint, Yammer and Stream work together to empower leaders to connect with their organizations, to align people to common goals, and to drive cultural transformation. Dive into the latest innovations including live events, new Yammer experiences and integrations, the intelligent intranet featuring home sites.",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86596,
                                 "title":  "The intelligent intranet: Transform communications and digital employee experiences",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "The intelligent intranet in Microsoft 365 connects the workplace to power collaboration, employee engagement, and knowledge management.  In this demo-heavy session, explore the latest innovations to help you transform your intranet into a rich, mobile-ready employee experiences that\u0027s dynamic, personalized, social and actionable. The session will explore new innovations for sites and portals, showcase common intranet scenarios, and provide actionable guidance toward optimal intranet architecture and governance.",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86600,
                                 "title":  "Harness collective knowledge with intelligent content services and Microsoft Search",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "703050"
                                                ],
                                 "speakerNames":  [
                                                      "Christopher McNulty"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Join us to learn about the most significant innovations ever unveiled for knowledge management and intelligent content services in Microsoft 365. Get the latest updates on Microsoft Search and other experiences that connect you with knowledge, insights, expertise, answers and actions, within your everyday experiences across Microsoft 365.",
                                 "location":  "Sheikh Rashid Hall D"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86476",
        "sessionInstanceId":  "86476",
        "sessionCode":  "MOD40",
        "sessionCodeNormalized":  "MOD40",
        "title":  "Debugging and interacting with production applications",
        "sortTitle":  "debugging and interacting with production applications",
        "sortRank":  2147483647,
        "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907377",
        "speakerIds":  [
                           "712663"
                       ],
        "speakerNames":  [
                             "Laurent Bugnion"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86472,
                                   "title":  "Migrating web applications to Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86474,
                                   "title":  "Moving your database to Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86471,
                                   "title":  "Enhancing web applications with cloud intelligence",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86484,
                                   "title":  "Managing delivery of your app via DevOps",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85130",
        "sessionInstanceId":  "85130",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Deploying, managing, and servicing windows, office and all your devices",
        "sortTitle":  "deploying, managing, and servicing windows, office and all your devices",
        "sortRank":  2147483647,
        "description":  "Transition to a modern, productive environmentâ€”and simplify the process of keeping desktop and mobile devices secure and up to date with Microsoft Intune and System Center Configuration Manager.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120806",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:25:14.888+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86562,
                                 "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [
                                                    "683098"
                                                ],
                                 "speakerNames":  [
                                                      "Harjit Dhaliwal"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86561,
                                 "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "683098",
                                                    "712623"
                                                ],
                                 "speakerNames":  [
                                                      "Harjit Dhaliwal",
                                                      "Michael Niehaus"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86563,
                                 "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "683098",
                                                    "712623"
                                                ],
                                 "speakerNames":  [
                                                      "Harjit Dhaliwal",
                                                      "Michael Niehaus"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86546,
                                 "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "683098"
                                                ],
                                 "speakerNames":  [
                                                      "Harjit Dhaliwal"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86551,
                                 "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "683098"
                                                ],
                                 "speakerNames":  [
                                                      "Harjit Dhaliwal"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
                                 "location":  "Sheikh Maktoum Hall B"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86522",
        "sessionInstanceId":  "86522",
        "sessionCode":  "OPS40",
        "sessionCodeNormalized":  "OPS40",
        "title":  "Deployment practices for greater reliability",
        "sortTitle":  "deployment practices for greater reliability",
        "sortRank":  2147483647,
        "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907369",
        "speakerIds":  [
                           "722024"
                       ],
        "speakerNames":  [
                             "Hosam Kamel"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86508,
                                   "title":  "Building the foundation for modern ops: Monitoring",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722025"
                                                  ],
                                   "speakerNames":  [
                                                        "James Toulman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86506,
                                   "title":  "Responding to incidents",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86505,
                                   "title":  "Learning from failure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Incidents will happenâ€”thereâ€™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86524,
                                   "title":  "Preparing for growth: Capacity planning and scaling",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â€œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85145",
        "sessionInstanceId":  "85145",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Develop integrations and workflows for your productivity applications",
        "sortTitle":  "develop integrations and workflows for your productivity applications",
        "sortRank":  2147483647,
        "description":  "Integrate critical business processes into experiences across Microsoft 365 to transform productivity in your organization.آ ",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120803",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86604,
                                 "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [
                                                    "606930"
                                                ],
                                 "speakerNames":  [
                                                      "Kyle Marsh"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
                                 "location":  "Dubai C+D"
                             },
                             {
                                 "sessionId":  86605,
                                 "title":  "Microsoft Graph: a primer for developers",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702888"
                                                ],
                                 "speakerNames":  [
                                                      "Jakob Nielsen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
                                 "location":  "Dubai C+D"
                             },
                             {
                                 "sessionId":  86617,
                                 "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "704728"
                                                ],
                                 "speakerNames":  [
                                                      "Bill Ayers"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
                                 "location":  "Dubai C+D"
                             },
                             {
                                 "sessionId":  86619,
                                 "title":  "Transform everyday business processes with Microsoft 365 platform tools",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702888"
                                                ],
                                 "speakerNames":  [
                                                      "Jakob Nielsen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
                                 "location":  "Sheikh Rashid Hall A"
                             },
                             {
                                 "sessionId":  86618,
                                 "title":  "Windows 10: The developer platform, and modern application development",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "719772"
                                                ],
                                 "speakerNames":  [
                                                      "Giorgio Sardo"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
                                 "location":  "Sheikh Rashid Hall A"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85067",
        "sessionInstanceId":  "85067",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Developers guide to AI",
        "sortTitle":  "developers guide to ai",
        "sortRank":  2147483647,
        "description":  "Youâ€™ll start with basic data concepts, then explore Azure Cognitive Services before â€œgraduatingâ€‌ into machine learning for developers. By the end, youâ€™ll see how to deploy your machine learning model to production, allowing it be consumed by simple web services.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120813",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86614,
                                 "title":  "Making sense of your unstructured data with AI",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [
                                                    "717897"
                                                ],
                                 "speakerNames":  [
                                                      "Bernd Verst"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86451,
                                 "title":  "Using pre-built AI to solve business challenges",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86452,
                                 "title":  "Start Building Machine Learning Models Faster than You Think",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "698031"
                                                ],
                                 "speakerNames":  [
                                                      "Cassie Breviu"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86449,
                                 "title":  "Taking models to the next level with Azure Machine Learning best practices",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "697629"
                                                ],
                                 "speakerNames":  [
                                                      "Henk Boelman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86496,
                                 "title":  "Machine learning operations: Applying DevOps to data science",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "697629"
                                                ],
                                 "speakerNames":  [
                                                      "Henk Boelman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90735",
        "sessionInstanceId":  "90735",
        "sessionCode":  "THR30030",
        "sessionCodeNormalized":  "THR30030",
        "title":  "Developers guide to AI: A data story",
        "sortTitle":  "developers guide to ai: a data story",
        "sortRank":  2147483647,
        "description":  "In this theater session, we show the data science process and how to apply it. From exploration of datasets to deployment of services - all applied to an interesting data story. We also take you on a very brief tour of the Azure AI platform.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:20:00+00:00",
        "endDateTime":  "2020-02-10T06:35:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "702993"
                       ],
        "speakerNames":  [
                             "Mohamed Mostafa"
                         ],
        "speakerCompanies":  [
                                 "TechLabs London"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85064",
        "sessionInstanceId":  "85064",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Developing cloud native applications",
        "sortTitle":  "developing cloud native applications",
        "sortRank":  2147483647,
        "description":  "Want to learn how to build and deploy cloud applications that are easy to manage, reliable, cost-effective, and scale when you need them to?  Our worldwide experts will share tips, tools and best practices for building and scaling your applications on the cloud.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120814",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86487,
                                 "title":  "Options for building and running your app in the cloud",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [
                                                    "698031"
                                                ],
                                 "speakerNames":  [
                                                      "Cassie Breviu"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86486,
                                 "title":  "Options for data in the cloud",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715283"
                                                ],
                                 "speakerNames":  [
                                                      "Christian Nwamba"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86489,
                                 "title":  "Modernizing your application with containers",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "721311"
                                                ],
                                 "speakerNames":  [
                                                      "Jessica Deen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86488,
                                 "title":  "Consolidating infrastructure with Azure Kubernetes Service",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "721311"
                                                ],
                                 "speakerNames":  [
                                                      "Jessica Deen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86490,
                                 "title":  "Taking your app to the next level with monitoring, performance, and scaling",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "707101"
                                                ],
                                 "speakerNames":  [
                                                      "Tiberiu George Covaci"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
                                 "location":  "Sheikh Maktoum Hall D"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86434",
        "sessionInstanceId":  "86434",
        "sessionCode":  "AFUN30",
        "sessionCodeNormalized":  "AFUN30",
        "title":  "Discovering Azure tooling and utilities",
        "sortTitle":  "discovering azure tooling and utilities",
        "sortRank":  2147483647,
        "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907398",
        "speakerIds":  [
                           "719728"
                       ],
        "speakerNames":  [
                             "April Edwards"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86430",
        "sessionInstanceId":  "86430",
        "sessionCode":  "AFUN10",
        "sessionCodeNormalized":  "AFUN10",
        "title":  "Discovering Microsoft Azure",
        "sortTitle":  "discovering microsoft azure",
        "sortRank":  2147483647,
        "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907400",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€��� computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86547",
        "sessionInstanceId":  "86547",
        "sessionCode":  "SECO20",
        "sessionCodeNormalized":  "SECO20",
        "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
        "sortTitle":  "dive deep into microsoft 365 threat protection: see how we defend against threats like phishing and stop attacks in their tracks across your estate",
        "sortRank":  2147483647,
        "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Securing your organization",
        "level":  "Intermediate (200)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "Security",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907354",
        "speakerIds":  [
                           "697363"
                       ],
        "speakerNames":  [
                             "Milad Aslaner"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86549,
                                   "title":  "Secure your enterprise with a strong identity foundation",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717841"
                                                  ],
                                   "speakerNames":  [
                                                        "Subha Bhattacharyay"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86548,
                                   "title":  "End-to-end cloud security for all your XaaS resources",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719750"
                                                  ],
                                   "speakerNames":  [
                                                        "David Maskell"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86550,
                                   "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86559,
                                   "title":  "Top 10 best security practices for Azure today",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703851"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiander Turpijn"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86401",
        "sessionInstanceId":  "86401",
        "sessionCode":  "DYNA10",
        "sessionCodeNormalized":  "DYNA10",
        "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
        "sortTitle":  "dynamics 365 â€“ establish and administer a cross organization business applications strategy",
        "sortRank":  2147483647,
        "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907410",
        "speakerIds":  [
                           "714853"
                       ],
        "speakerNames":  [
                             "Mohamed Mahmoud"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86402,
                                   "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86400,
                                   "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702496"
                                                  ],
                                   "speakerNames":  [
                                                        "Antti Pajunen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86404,
                                   "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707057"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Al Chami"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86399,
                                   "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704342"
                                                  ],
                                   "speakerNames":  [
                                                        "Elena Djonova"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86565",
        "sessionInstanceId":  "86565",
        "sessionCode":  "COMP40",
        "sessionCodeNormalized":  "COMP40",
        "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
        "sortTitle":  "ediscovery and audit: harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
        "sortRank":  2147483647,
        "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907362",
        "speakerIds":  [
                           "669942"
                       ],
        "speakerNames":  [
                             "AMIT BHATIA"
                         ],
        "speakerCompanies":  [
                                 "MSFT"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86527,
                                   "title":  "Know your data: use intelligence to identify, protect and govern your important data",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86525,
                                   "title":  "Identify and take action on insider risks, threats and code of conduct violations",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86564,
                                   "title":  "Take control of your data explosion with intelligent Information Governance",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "716951"
                                                  ],
                                   "speakerNames":  [
                                                        "Rami Calache"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86566,
                                   "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715281"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Khairy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86417",
        "sessionInstanceId":  "86417",
        "sessionCode":  "POWA30",
        "sessionCodeNormalized":  "POWA30",
        "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
        "sortTitle":  "enable modern analytics and enterprise business intelligence using microsoft power bi",
        "sortRank":  2147483647,
        "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907404",
        "speakerIds":  [
                           "666688"
                       ],
        "speakerNames":  [
                             "Christopher Mark Wilcock"
                         ],
        "speakerCompanies":  [
                                 "Zomalex Ltd."
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86403,
                                   "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86415,
                                   "title":  "Intelligent automation with Microsoft Power Automate",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86416,
                                   "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86418,
                                   "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
                                   "location":  "Sheikh Rashid Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86403",
        "sessionInstanceId":  "86403",
        "sessionCode":  "POWA10",
        "sessionCodeNormalized":  "POWA10",
        "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
        "sortTitle":  "enabling everyone to digitize apps and processes with power apps and the power platform",
        "sortRank":  2147483647,
        "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907405",
        "speakerIds":  [
                           "666688"
                       ],
        "speakerNames":  [
                             "Christopher Mark Wilcock"
                         ],
        "speakerCompanies":  [
                                 "Zomalex Ltd."
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86415,
                                   "title":  "Intelligent automation with Microsoft Power Automate",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86417,
                                   "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86416,
                                   "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86418,
                                   "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
                                   "location":  "Sheikh Rashid Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86548",
        "sessionInstanceId":  "86548",
        "sessionCode":  "SECO30",
        "sessionCodeNormalized":  "SECO30",
        "title":  "End-to-end cloud security for all your XaaS resources",
        "sortTitle":  "end-to-end cloud security for all your xaas resources",
        "sortRank":  2147483647,
        "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Securing your organization",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907353",
        "speakerIds":  [
                           "719750"
                       ],
        "speakerNames":  [
                             "David Maskell"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86549,
                                   "title":  "Secure your enterprise with a strong identity foundation",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717841"
                                                  ],
                                   "speakerNames":  [
                                                        "Subha Bhattacharyay"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86547,
                                   "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697363"
                                                  ],
                                   "speakerNames":  [
                                                        "Milad Aslaner"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86550,
                                   "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86559,
                                   "title":  "Top 10 best security practices for Azure today",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703851"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiander Turpijn"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86471",
        "sessionInstanceId":  "86471",
        "sessionCode":  "MOD30",
        "sessionCodeNormalized":  "MOD30",
        "title":  "Enhancing web applications with cloud intelligence",
        "sortTitle":  "enhancing web applications with cloud intelligence",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907378",
        "speakerIds":  [
                           "712663"
                       ],
        "speakerNames":  [
                             "Laurent Bugnion"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86472,
                                   "title":  "Migrating web applications to Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86474,
                                   "title":  "Moving your database to Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86476,
                                   "title":  "Debugging and interacting with production applications",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86484,
                                   "title":  "Managing delivery of your app via DevOps",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86433",
        "sessionInstanceId":  "86433",
        "sessionCode":  "AFUN60",
        "sessionCodeNormalized":  "AFUN60",
        "title":  "Exploring containers and orchestration in Azure",
        "sortTitle":  "exploring containers and orchestration in azure",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907395",
        "speakerIds":  [
                           "726799"
                       ],
        "speakerNames":  [
                             "Hatim Nagarwala"
                         ],
        "speakerCompanies":  [
                                 "AppsWave"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90725",
        "sessionInstanceId":  "90725",
        "sessionCode":  "THR20000",
        "sessionCodeNormalized":  "THR20000",
        "title":  "FastTrack data migration services: How we can help",
        "sortTitle":  "fasttrack data migration services: how we can help",
        "sortRank":  2147483647,
        "description":  "Did you know that FastTrack can help migrate your data when you move to Microsoft 365? Come to this session to hear an overview of the migration service and how we migrate your email and file share data using best practices. Weâ€™ll also share new features that are coming to our service.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T13:40:00+00:00",
        "endDateTime":  "2020-02-10T13:55:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "719751"
                       ],
        "speakerNames":  [
                             "George Moussalem"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86450",
        "sessionInstanceId":  "86450",
        "sessionCode":  "AFUN95",
        "sessionCodeNormalized":  "AFUN95",
        "title":  "Figuring out Azure functions",
        "sortTitle":  "figuring out azure functions",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907392",
        "speakerIds":  [
                           "715283"
                       ],
        "speakerNames":  [
                             "Christian Nwamba"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86600",
        "sessionInstanceId":  "86600",
        "sessionCode":  "SOYS40",
        "sessionCodeNormalized":  "SOYS40",
        "title":  "Harness collective knowledge with intelligent content services and Microsoft Search",
        "sortTitle":  "harness collective knowledge with intelligent content services and microsoft search",
        "sortRank":  2147483647,
        "description":  "Join us to learn about the most significant innovations ever unveiled for knowledge management and intelligent content services in Microsoft 365. Get the latest updates on Microsoft Search and other experiences that connect you with knowledge, insights, expertise, answers and actions, within your everyday experiences across Microsoft 365.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Content collaboration, Communication, and Engagement in the Intelligent Workplace",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907342",
        "speakerIds":  [
                           "703050"
                       ],
        "speakerNames":  [
                             "Christopher McNulty"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86595,
                                   "title":  "Content collaboration and protection with SharePoint, OneDrive and Microsoft Teams",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint connects the workplace and powers content collaboration. OneDrive connects you with all your files in Office 365. Teams is the hub for teamwork. Together, SharePoint, OneDrive and Teams are greater than the sum of their parts. Join us for an overview of how these products interact with each other and learn about latest integrations we are working on to bring the richness of SharePoint directly into Teams experiences and vice versa. We\u0027ll explore new innovations for sharing and working together with data using SharePoint lists, and no-code productivity solutions that streamline business processes. Finally, weâ€™ll explore how to structure teams and projects with hub sites.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86598,
                                   "title":  "Connect the organization and engage people with SharePoint, Yammer and Microsoft Stream",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Company leaders recognize the need to transform their workforce, and organizations where employees are truly engaged report improved employee retention, customer satisfaction, sales metrics, and overall profitability. Microsoft 365 delivers the modern workplace and solutions that help you engage employees across organizational boundaries, generations and geographies, so you can empower your people to achieve more. Learn how SharePoint, Yammer and Stream work together to empower leaders to connect with their organizations, to align people to common goals, and to drive cultural transformation. Dive into the latest innovations including live events, new Yammer experiences and integrations, the intelligent intranet featuring home sites.",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86596,
                                   "title":  "The intelligent intranet: Transform communications and digital employee experiences",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The intelligent intranet in Microsoft 365 connects the workplace to power collaboration, employee engagement, and knowledge management.  In this demo-heavy session, explore the latest innovations to help you transform your intranet into a rich, mobile-ready employee experiences that\u0027s dynamic, personalized, social and actionable. The session will explore new innovations for sites and portals, showcase common intranet scenarios, and provide actionable guidance toward optimal intranet architecture and governance.",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86509",
        "sessionInstanceId":  "86509",
        "sessionCode":  "MSI20",
        "sessionCodeNormalized":  "MSI20",
        "title":  "Hybrid management technologies",
        "sortTitle":  "hybrid management technologies",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders has now migrated the majority of their server hosts from Windows Server 2008 R2 to Windows Server 2019. Now, they are interested in the Azure hybrid technologies that are readily available to them. \\r\\n\\r\\nIn this session, learn how Tailwind Traders began using Windows Admin Center to manage its fleet of Windows Server computers and integrated hybrid technologies, such as Azure File Sync, Azure Active Directory Password Protection, Azure Backup, and Windows Defender ATP, to improve deployment performance and manageability.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Migrating server infrastructure",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907374",
        "speakerIds":  [
                           "712734"
                       ],
        "speakerNames":  [
                             "Orin Thomas"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86504,
                                   "title":  "Migrating to Windows Server 2019",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712734"
                                                  ],
                                   "speakerNames":  [
                                                        "Orin Thomas"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has acquired Northwind, a large subsidiary company. Northwind currently has 1500 servers running Windows Server 2008 R2 -  either directly or virtually - on hardware at the midpoint of its operational lifespan. While Tailwind Traders will eventually move many of these workloads to Azure, Windows Server 2008 R2 end of life is quickly approaching. In this session, learn how Tailwind Tradersâ€™ used Azure hybrid management technologies to migrate servers, and the roles that they host, to Windows Server 2019.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86507,
                                   "title":  "Migrating IaaS workloads to Azure",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "724361"
                                                  ],
                                   "speakerNames":  [
                                                        "Pierre Roman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that the migration of their server hosts from Windows Server 2008 R2 to Windows Server 2019 is complete, Tailwind Traders wants to begin the process of â€œlift and shiftâ€‌: migrating some of their on-premises VMs theyâ€™ve been running in their datacenter.  \\r\\n\\r\\nIn this session, learn about how Tailwind Traders began the process of migrating some of their existing VM workloads to Azure and how this allowed them to retire aging server hardware and close datacenter and server rooms that were costing the organization a substantial amount of money.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86473",
        "sessionInstanceId":  "86473",
        "sessionCode":  "MCO10",
        "sessionCodeNormalized":  "MCO10",
        "title":  "IaaS VM operations",
        "sortTitle":  "iaas vm operations",
        "sortRank":  2147483647,
        "description":  "In recent months, Tailwind Traders has been having issues with keeping their sprawling IaaS VM deployment under control, leading to mismanaged resources and inefficient processes.  \\r\\nIn this session, look into how Tailwind Traders can ensure their VMs are properly managed and maintained with the same care in Azure as they were in Tailwind Trader\u0027s on-premises data centers.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Managing cloud operations",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907382",
        "speakerIds":  [
                           "724361"
                       ],
        "speakerNames":  [
                             "Pierre Roman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86475,
                                   "title":  "Azure governance and management",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Tradersâ€™ deployments are occurring in an ad hoc manner, primarily driven by lack of protocol and unapproved decisions by various operators or employees. Some deployments even violate the organization\u0027s compliance obligations, such as being deployed in an unencrypted manner without DR protection. After bringing their existing IaaS VM fleet under control, Tailwind Traders wants to ensure future deployments comply with policy and organizational requirements.  \\r\\n\\r\\nIn this session, walk through the processes and technologies that will keep Tailwind Tradersâ€™ deployments in good standing with the help of Azure Blueprints, Azure Policy, role-based access control (RBAC), and more.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86525",
        "sessionInstanceId":  "86525",
        "sessionCode":  "COMP20",
        "sessionCodeNormalized":  "COMP20",
        "title":  "Identify and take action on insider risks, threats and code of conduct violations",
        "sortTitle":  "identify and take action on insider risks, threats and code of conduct violations",
        "sortRank":  2147483647,
        "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "Advanced (300)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "Compliance",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907364",
        "speakerIds":  [
                           "669942"
                       ],
        "speakerNames":  [
                             "AMIT BHATIA"
                         ],
        "speakerCompanies":  [
                                 "MSFT"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86527,
                                   "title":  "Know your data: use intelligence to identify, protect and govern your important data",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86564,
                                   "title":  "Take control of your data explosion with intelligent Information Governance",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "716951"
                                                  ],
                                   "speakerNames":  [
                                                        "Rami Calache"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86565,
                                   "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86566,
                                   "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715281"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Khairy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85066",
        "sessionInstanceId":  "85066",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Improving reliability through modern operations practices",
        "sortTitle":  "improving reliability through modern operations practices",
        "sortRank":  2147483647,
        "description":  "The reliability of your systems, services and products has a direct impact on your success. Learn the modern operations principles and practices (and the Azure features that support them) that will help you achieve the level of reliability you need.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120812",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86508,
                                 "title":  "Building the foundation for modern ops: Monitoring",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "722025"
                                                ],
                                 "speakerNames":  [
                                                      "James Toulman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86506,
                                 "title":  "Responding to incidents",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86505,
                                 "title":  "Learning from failure",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "719728"
                                                ],
                                 "speakerNames":  [
                                                      "April Edwards"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Incidents will happenâ€”thereâ€™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86522,
                                 "title":  "Deployment practices for greater reliability",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "722024"
                                                ],
                                 "speakerNames":  [
                                                      "Hosam Kamel"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall D"
                             },
                             {
                                 "sessionId":  86524,
                                 "title":  "Preparing for growth: Capacity planning and scaling",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â���œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall D"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86415",
        "sessionInstanceId":  "86415",
        "sessionCode":  "POWA20",
        "sessionCodeNormalized":  "POWA20",
        "title":  "Intelligent automation with Microsoft Power Automate",
        "sortTitle":  "intelligent automation with microsoft power automate",
        "sortRank":  2147483647,
        "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907403",
        "speakerIds":  [
                           "714853"
                       ],
        "speakerNames":  [
                             "Mohamed Mahmoud"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86403,
                                   "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86417,
                                   "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86416,
                                   "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86418,
                                   "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
                                   "location":  "Sheikh Rashid Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86582",
        "sessionInstanceId":  "86582",
        "sessionCode":  "TMS20",
        "sessionCodeNormalized":  "TMS20",
        "title":  "Intelligent communications in Microsoft Teams",
        "sortTitle":  "intelligent communications in microsoft teams",
        "sortRank":  2147483647,
        "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907349",
        "speakerIds":  [
                           "702999"
                       ],
        "speakerNames":  [
                             "Diaundra Jones"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86583,
                                   "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86581,
                                   "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86585,
                                   "title":  "Managing Microsoft Teams effectively",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86580,
                                   "title":  "Streamline business processes with the Microsoft Teams development platform",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85139",
        "sessionInstanceId":  "85139",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "sortTitle":  "it administratorâ€™s guide to managing productivity in the cloud",
        "sortRank":  2147483647,
        "description":  "Learn how to navigate the latest updates in IT admin experiences to effectively manage your organizationâ€™s users, applications and devices.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120804",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86620,
                                 "title":  "Role-based access control in Microsoft 365: Improve your operations and security posture",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "707230"
                                                ],
                                 "speakerNames":  [
                                                      "Andrew Malone"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Role-based access control is essential for improving the security posture of your org, while providing IT with a focused experience based on permissions. In this session you will hear about how to use the centrally-managed, granular role-based access control in Microsoft 365 admin center.  We will dive into the new workload-specific admin roles and global reader role, showing you how to select the right administrator permissions and control who has access to your data.",
                                 "location":  "Sheikh Rashid Hall E"
                             },
                             {
                                 "sessionId":  86629,
                                 "title":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "707230"
                                                ],
                                 "speakerNames":  [
                                                      "Andrew Malone"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
                                 "location":  "Sheikh Rashid Hall E"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85132",
        "sessionInstanceId":  "85132",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Journey to Microsoft Teams",
        "sortTitle":  "journey to microsoft teams",
        "sortRank":  2147483647,
        "description":  "Build a collaborative workforce for your organization with Microsoft Teams bringing together everything in a shared workspace where you can chat, meet, share files, and integrate business applications.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120805",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86583,
                                 "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702999"
                                                ],
                                 "speakerNames":  [
                                                      "Diaundra Jones"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86582,
                                 "title":  "Intelligent communications in Microsoft Teams",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702999",
                                                    "717224"
                                                ],
                                 "speakerNames":  [
                                                      "Diaundra Jones",
                                                      "Ghouse Shariff"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86581,
                                 "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "717224"
                                                ],
                                 "speakerNames":  [
                                                      "Ghouse Shariff"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86585,
                                 "title":  "Managing Microsoft Teams effectively",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "697422"
                                                ],
                                 "speakerNames":  [
                                                      "Preethy Krishnamurthy"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86580,
                                 "title":  "Streamline business processes with the Microsoft Teams development platform",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "697422"
                                                ],
                                 "speakerNames":  [
                                                      "Preethy Krishnamurthy"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall C"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86447",
        "sessionInstanceId":  "86447",
        "sessionCode":  "AFUN70",
        "sessionCodeNormalized":  "AFUN70",
        "title":  "Keeping costs down in Azure",
        "sortTitle":  "keeping costs down in azure",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907394",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86527",
        "sessionInstanceId":  "86527",
        "sessionCode":  "COMP10",
        "sessionCodeNormalized":  "COMP10",
        "title":  "Know your data: use intelligence to identify, protect and govern your important data",
        "sortTitle":  "know your data: use intelligence to identify, protect and govern your important data",
        "sortRank":  2147483647,
        "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907365",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86525,
                                   "title":  "Identify and take action on insider risks, threats and code of conduct violations",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86564,
                                   "title":  "Take control of your data explosion with intelligent Information Governance",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "716951"
                                                  ],
                                   "speakerNames":  [
                                                        "Rami Calache"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86565,
                                   "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86566,
                                   "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715281"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Khairy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90723",
        "sessionInstanceId":  "90723",
        "sessionCode":  "THR10001",
        "sessionCodeNormalized":  "THR10001",
        "title":  "Learn How Microsoft Flow Is a the Perfect Automation Platform to Streamline Workflow Processes Across Your Entire IT Ecosystem",
        "sortTitle":  "learn how microsoft flow is a the perfect automation platform to streamline workflow processes across your entire it ecosystem",
        "sortRank":  2147483647,
        "description":  "TBD",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:50:00+00:00",
        "endDateTime":  "2020-02-11T08:05:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86505",
        "sessionInstanceId":  "86505",
        "sessionCode":  "OPS30",
        "sessionCodeNormalized":  "OPS30",
        "title":  "Learning from failure",
        "sortTitle":  "learning from failure",
        "sortRank":  2147483647,
        "description":  "Incidents will happenâ€”thereâ€™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907370",
        "speakerIds":  [
                           "719728"
                       ],
        "speakerNames":  [
                             "April Edwards"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86508,
                                   "title":  "Building the foundation for modern ops: Monitoring",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722025"
                                                  ],
                                   "speakerNames":  [
                                                        "James Toulman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86506,
                                   "title":  "Responding to incidents",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86522,
                                   "title":  "Deployment practices for greater reliability",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722024"
                                                  ],
                                   "speakerNames":  [
                                                        "Hosam Kamel"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86524,
                                   "title":  "Preparing for growth: Capacity planning and scaling",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â€œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86496",
        "sessionInstanceId":  "86496",
        "sessionCode":  "AIML50",
        "sessionCodeNormalized":  "AIML50",
        "title":  "Machine learning operations: Applying DevOps to data science",
        "sortTitle":  "machine learning operations: applying devops to data science",
        "sortRank":  2147483647,
        "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907388",
        "speakerIds":  [
                           "697629"
                       ],
        "speakerNames":  [
                             "Henk Boelman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86614,
                                   "title":  "Making sense of your unstructured data with AI",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86451,
                                   "title":  "Using pre-built AI to solve business challenges",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86452,
                                   "title":  "Start Building Machine Learning Models Faster than You Think",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86449,
                                   "title":  "Taking models to the next level with Azure Machine Learning best practices",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86614",
        "sessionInstanceId":  "86614",
        "sessionCode":  "AIML10",
        "sessionCodeNormalized":  "AIML10",
        "title":  "Making sense of your unstructured data with AI",
        "sortTitle":  "making sense of your unstructured data with ai",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907334",
        "speakerIds":  [
                           "717897"
                       ],
        "speakerNames":  [
                             "Bernd Verst"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86451,
                                   "title":  "Using pre-built AI to solve business challenges",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86452,
                                   "title":  "Start Building Machine Learning Models Faster than You Think",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86449,
                                   "title":  "Taking models to the next level with Azure Machine Learning best practices",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86496,
                                   "title":  "Machine learning operations: Applying DevOps to data science",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86418",
        "sessionInstanceId":  "86418",
        "sessionCode":  "POWA50",
        "sessionCodeNormalized":  "POWA50",
        "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
        "sortTitle":  "managing and supporting the power apps and microsoft power automate at scale",
        "sortRank":  2147483647,
        "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907401",
        "speakerIds":  [
                           "715251"
                       ],
        "speakerNames":  [
                             "Ali Jibran Sayed Mohammed"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86403,
                                   "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86415,
                                   "title":  "Intelligent automation with Microsoft Power Automate",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "714853"
                                                  ],
                                   "speakerNames":  [
                                                        "Mohamed Mahmoud"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86417,
                                   "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "666688"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher Mark Wilcock"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
                                   "location":  "Sheikh Rashid Hall B"
                               },
                               {
                                   "sessionId":  86416,
                                   "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715251"
                                                  ],
                                   "speakerNames":  [
                                                        "Ali Jibran Sayed Mohammed"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
                                   "location":  "Sheikh Rashid Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85069",
        "sessionInstanceId":  "85069",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Managing cloud operations",
        "sortTitle":  "managing cloud operations",
        "sortRank":  2147483647,
        "description":  "Learn how to define your organizationâ€™s governance, security, and policies within Azure Regulate and organize your Azure subscription, adhering to your compliance preferences and setup guard rails for cost and regional structure.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Managing cloud operations",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120811",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86473,
                                 "title":  "IaaS VM operations",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "724361"
                                                ],
                                 "speakerNames":  [
                                                      "Pierre Roman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In recent months, Tailwind Traders has been having issues with keeping their sprawling IaaS VM deployment under control, leading to mismanaged resources and inefficient processes.  \\r\\nIn this session, look into how Tailwind Traders can ensure their VMs are properly managed and maintained with the same care in Azure as they were in Tailwind Trader\u0027s on-premises data centers.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86475,
                                 "title":  "Azure governance and management",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Tradersâ€™ deployments are occurring in an ad hoc manner, primarily driven by lack of protocol and unapproved decisions by various operators or employees. Some deployments even violate the organization\u0027s compliance obligations, such as being deployed in an unencrypted manner without DR protection. After bringing their existing IaaS VM fleet under control, Tailwind Traders wants to ensure future deployments comply with policy and organizational requirements.  \\r\\n\\r\\nIn this session, walk through the processes and technologies that will keep Tailwind Tradersâ€™ deployments in good standing with the help of Azure Blueprints, Azure Policy, role-based access control (RBAC), and more.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86484",
        "sessionInstanceId":  "86484",
        "sessionCode":  "MOD50",
        "sessionCodeNormalized":  "MOD50",
        "title":  "Managing delivery of your app via DevOps",
        "sortTitle":  "managing delivery of your app via devops",
        "sortRank":  2147483647,
        "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907376",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86472,
                                   "title":  "Migrating web applications to Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86474,
                                   "title":  "Moving your database to Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86471,
                                   "title":  "Enhancing web applications with cloud intelligence",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86476,
                                   "title":  "Debugging and interacting with production applications",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86585",
        "sessionInstanceId":  "86585",
        "sessionCode":  "TMS40",
        "sessionCodeNormalized":  "TMS40",
        "title":  "Managing Microsoft Teams effectively",
        "sortTitle":  "managing microsoft teams effectively",
        "sortRank":  2147483647,
        "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907348",
        "speakerIds":  [
                           "697422"
                       ],
        "speakerNames":  [
                             "Preethy Krishnamurthy"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86583,
                                   "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86582,
                                   "title":  "Intelligent communications in Microsoft Teams",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999",
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones",
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86581,
                                   "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86580,
                                   "title":  "Streamline business processes with the Microsoft Teams development platform",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90724",
        "sessionInstanceId":  "90724",
        "sessionCode":  "THR10000",
        "sessionCodeNormalized":  "THR10000",
        "title":  "Meet Microsoft Surface",
        "sortTitle":  "meet microsoft surface",
        "sortRank":  2147483647,
        "description":  "Designed by Microsoft, the Surface portfolio is engineered to deliver the best Windows 10 and Microsoft 365 experiences at home and work. Together with our customers, we are leading to support world-class deployment, management and security as part of business and education transformation.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:05:00+00:00",
        "endDateTime":  "2020-02-10T12:20:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "668803"
                       ],
        "speakerNames":  [
                             "Pradeep Lingam"
                         ],
        "speakerCompanies":  [
                                 "Redington Middle East LLC"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85131",
        "sessionInstanceId":  "85131",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Meeting organizational compliance requirements",
        "sortTitle":  "meeting organizational compliance requirements",
        "sortRank":  2147483647,
        "description":  "Leverage the intelligent and integrated Microsoft solutions to help your organization achieve its compliance goals.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120808",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86527,
                                 "title":  "Know your data: use intelligence to identify, protect and govern your important data",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86525,
                                 "title":  "Identify and take action on insider risks, threats and code of conduct violations",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "669942"
                                                ],
                                 "speakerNames":  [
                                                      "AMIT BHATIA"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86564,
                                 "title":  "Take control of your data explosion with intelligent Information Governance",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "716951"
                                                ],
                                 "speakerNames":  [
                                                      "Rami Calache"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86565,
                                 "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "669942"
                                                ],
                                 "speakerNames":  [
                                                      "AMIT BHATIA"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
                                 "location":  "Sheikh Maktoum Hall C"
                             },
                             {
                                 "sessionId":  86566,
                                 "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715281"
                                                ],
                                 "speakerNames":  [
                                                      "Ahmed Khairy"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
                                 "location":  "Sheikh Maktoum Hall C"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85146",
        "sessionInstanceId":  "85146",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Microsoft Dynamics 365",
        "sortTitle":  "microsoft dynamics 365",
        "sortRank":  2147483647,
        "description":  "For those new to Dynamics 365, learn how to increase your organizations productivity across business groups â€“ enabling efficiencies and business processes that enable innovation, and personalized experiences.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Microsoft Dynamics 365",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120802",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86401,
                                 "title":  "Dynamics 365 â€“ Establish and administer a cross organization business applications strategy",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "714853"
                                                ],
                                 "speakerNames":  [
                                                      "Mohamed Mahmoud"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Dynamics 365 provides a complete platform of modular, intelligent, and connected SaaS business applications with inherent tooling that meet security and compliance requirements, ensure uptime, and streamline control and access. This session will outline how you can support data integration and governance, seamlessly manage authentication, and administer an interconnected set of business applications and automated processes throughout your organization.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86402,
                                 "title":  "Configuring and managing Dynamics 365 Sales and Dynamics 365 Marketing â€“ Establish connected Sales and Marketing",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702496"
                                                ],
                                 "speakerNames":  [
                                                      "Antti Pajunen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session, you will learn how to deploy, configure, manage, and connect Dynamics 365 Sales and Dynamics 365 Marketing, provide actionable insights across sales and marketing by integrating Insights applications and LinkedIn data, and gain an understanding of how you can enable mixed reality solutions across marketing and sales activities.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86400,
                                 "title":  "Configuring and managing Dynamics 365 Customer Service and Dynamics 365 Field Service â€“ Establish a proactive service organization",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "702496"
                                                ],
                                 "speakerNames":  [
                                                      "Antti Pajunen"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session, you will learn how to deploy, configure, and connect Dynamics 365 Customer Service and Dynamics 365 Field Service, provide actionable insights by integrating Insights applications, enable and support an omnichannel engagement strategy, leverage BoT and IoT to streamline case/ticket remediation, and gain an understanding of how you can enable mixed reality solutions in support of your field engineers productivity.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86404,
                                 "title":  "Configuring and managing Dynamics 365 Finance â€“ Modernize finance and supply chain",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "707057"
                                                ],
                                 "speakerNames":  [
                                                      "Ahmed Al Chami"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Learn how you can more thoroughly and completely support your finance and supply chain stakeholders with Dynamics 365 Finance and Operations.  In this session, you will learn how to deploy, configure, and manage Dynamics 365 Finance, gaining insights into how to support the establishment of efficient business process modelling and predictive analytics.",
                                 "location":  "Sheikh Maktoum Hall B"
                             },
                             {
                                 "sessionId":  86399,
                                 "title":  "Configuring and managing Dynamics 365 Retail - Enable connected retail",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "704342"
                                                ],
                                 "speakerNames":  [
                                                      "Elena Djonova"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session youâ€™ll learn how to deploy, configure and manage Dynamics 365 Retail in support of multi-channel commerce transactions. Across point of sales systems, product and inventory management, order and financial management as well as employee management and fraud protection, this session will provide you with the information you need to get started in establishing a connected retail ecosystem.",
                                 "location":  "Sheikh Maktoum Hall B"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86605",
        "sessionInstanceId":  "86605",
        "sessionCode":  "MDEV20",
        "sessionCodeNormalized":  "MDEV20",
        "title":  "Microsoft Graph: a primer for developers",
        "sortTitle":  "microsoft graph: a primer for developers",
        "sortRank":  2147483647,
        "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "Intermediate (200)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "Productivity",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907338",
        "speakerIds":  [
                           "702888"
                       ],
        "speakerNames":  [
                             "Jakob Nielsen"
                         ],
        "speakerCompanies":  [
                                 "Microsoft Corporation"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:30:15.208+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86604,
                                   "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "606930"
                                                  ],
                                   "speakerNames":  [
                                                        "Kyle Marsh"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86617,
                                   "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704728"
                                                  ],
                                   "speakerNames":  [
                                                        "Bill Ayers"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86619,
                                   "title":  "Transform everyday business processes with Microsoft 365 platform tools",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
                                   "location":  "Sheikh Rashid Hall A"
                               },
                               {
                                   "sessionId":  86618,
                                   "title":  "Windows 10: The developer platform, and modern application development",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719772"
                                                  ],
                                   "speakerNames":  [
                                                        "Giorgio Sardo"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
                                   "location":  "Sheikh Rashid Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "92250",
        "sessionInstanceId":  "92250",
        "sessionCode":  "WRK20004",
        "sessionCodeNormalized":  "WRK20004",
        "title":  "Microsoft Intelligent Intranet Accelerator Workshop",
        "sortTitle":  "microsoft intelligent intranet accelerator workshop",
        "sortRank":  2147483647,
        "description":  "Are you ready to create a connected workplace? An intelligent intranet can connect you, your teams, and your organization when applying the right communication, knowledge sharing and discovery tools. Weâ€™ll show you how, with the right content sharing and business solution resources, you can greatly enhance the employee experience. Join us for this hands-on workshop where we teach you how to prototype, which will help demonstrate the possibilities of an intelligent intranet and gain buy-in from your stakeholders. Youâ€™ll gain the knowledge and ability to show your team the value of a new connected workplace and share strategies on how to drive adoption. By participating in our workshop, youâ€™ll walk away with the tools and capabilities necessary to accelerate your time-to-value and prove the impact of the intelligent intranet. Get inspired, with the art of the possible at the Microsoft Intelligent Intranet Workshop",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  195,
        "sessionType":  "Workshop: 90 Minute",
        "sessionTypeLogical":  "Workshop: 120 Minute",
        "learningPath":  "",
        "level":  "Intermediate (200)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3108",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "712694"
                       ],
        "speakerNames":  [
                             "Ari Nadin"
                         ],
        "speakerCompanies":  [
                                 "Avanade"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86507",
        "sessionInstanceId":  "86507",
        "sessionCode":  "MSI30",
        "sessionCodeNormalized":  "MSI30",
        "title":  "Migrating IaaS workloads to Azure",
        "sortTitle":  "migrating iaas workloads to azure",
        "sortRank":  2147483647,
        "description":  "Now that the migration of their server hosts from Windows Server 2008 R2 to Windows Server 2019 is complete, Tailwind Traders wants to begin the process of â€œlift and shiftâ€‌: migrating some of their on-premises VMs theyâ€™ve been running in their datacenter.  \\r\\n\\r\\nIn this session, learn about how Tailwind Traders began the process of migrating some of their existing VM workloads to Azure and how this allowed them to retire aging server hardware and close datacenter and server rooms that were costing the organization a substantial amount of money.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Migrating server infrastructure",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907373",
        "speakerIds":  [
                           "724361"
                       ],
        "speakerNames":  [
                             "Pierre Roman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86504,
                                   "title":  "Migrating to Windows Server 2019",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712734"
                                                  ],
                                   "speakerNames":  [
                                                        "Orin Thomas"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has acquired Northwind, a large subsidiary company. Northwind currently has 1500 servers running Windows Server 2008 R2 -  either directly or virtually - on hardware at the midpoint of its operational lifespan. While Tailwind Traders will eventually move many of these workloads to Azure, Windows Server 2008 R2 end of life is quickly approaching. In this session, learn how Tailwind Tradersâ€™ used Azure hybrid management technologies to migrate servers, and the roles that they host, to Windows Server 2019.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86509,
                                   "title":  "Hybrid management technologies",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712734"
                                                  ],
                                   "speakerNames":  [
                                                        "Orin Thomas"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has now migrated the majority of their server hosts from Windows Server 2008 R2 to Windows Server 2019. Now, they are interested in the Azure hybrid technologies that are readily available to them. \\r\\n\\r\\nIn this session, learn how Tailwind Traders began using Windows Admin Center to manage its fleet of Windows Server computers and integrated hybrid technologies, such as Azure File Sync, Azure Active Directory Password Protection, Azure Backup, and Windows Defender ATP, to improve deployment performance and manageability.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85065",
        "sessionInstanceId":  "85065",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Migrating server infrastructure",
        "sortTitle":  "migrating server infrastructure",
        "sortRank":  2147483647,
        "description":  "For many organizations, cloud adoption starts with assessing your current environment and upgrading to Window Server 2019: a new hybrid ecosystem not previously available. See how to get started and simplify your Windows Server and SQL Server Azure migration.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Migrating server infrastructure",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120810",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86504,
                                 "title":  "Migrating to Windows Server 2019",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "712734"
                                                ],
                                 "speakerNames":  [
                                                      "Orin Thomas"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders has acquired Northwind, a large subsidiary company. Northwind currently has 1500 servers running Windows Server 2008 R2 -  either directly or virtually - on hardware at the midpoint of its operational lifespan. While Tailwind Traders will eventually move many of these workloads to Azure, Windows Server 2008 R2 end of life is quickly approaching. In this session, learn how Tailwind Tradersâ€™ used Azure hybrid management technologies to migrate servers, and the roles that they host, to Windows Server 2019.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86509,
                                 "title":  "Hybrid management technologies",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "712734"
                                                ],
                                 "speakerNames":  [
                                                      "Orin Thomas"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders has now migrated the majority of their server hosts from Windows Server 2008 R2 to Windows Server 2019. Now, they are interested in the Azure hybrid technologies that are readily available to them. \\r\\n\\r\\nIn this session, learn how Tailwind Traders began using Windows Admin Center to manage its fleet of Windows Server computers and integrated hybrid technologies, such as Azure File Sync, Azure Active Directory Password Protection, Azure Backup, and Windows Defender ATP, to improve deployment performance and manageability.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             },
                             {
                                 "sessionId":  86507,
                                 "title":  "Migrating IaaS workloads to Azure",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "724361"
                                                ],
                                 "speakerNames":  [
                                                      "Pierre Roman"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Now that the migration of their server hosts from Windows Server 2008 R2 to Windows Server 2019 is complete, Tailwind Traders wants to begin the process of â€œlift and shiftâ€‌: migrating some of their on-premises VMs theyâ€™ve been running in their datacenter.  \\r\\n\\r\\nIn this session, learn about how Tailwind Traders began the process of migrating some of their existing VM workloads to Azure and how this allowed them to retire aging server hardware and close datacenter and server rooms that were costing the organization a substantial amount of money.\\r\\n",
                                 "location":  "Sheikh Rashid Hall D"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86504",
        "sessionInstanceId":  "86504",
        "sessionCode":  "MSI10",
        "sessionCodeNormalized":  "MSI10",
        "title":  "Migrating to Windows Server 2019",
        "sortTitle":  "migrating to windows server 2019",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders has acquired Northwind, a large subsidiary company. Northwind currently has 1500 servers running Windows Server 2008 R2 -  either directly or virtually - on hardware at the midpoint of its operational lifespan. While Tailwind Traders will eventually move many of these workloads to Azure, Windows Server 2008 R2 end of life is quickly approaching. In this session, learn how Tailwind Tradersâ€™ used Azure hybrid management technologies to migrate servers, and the roles that they host, to Windows Server 2019.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Migrating server infrastructure",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907375",
        "speakerIds":  [
                           "712734"
                       ],
        "speakerNames":  [
                             "Orin Thomas"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86509,
                                   "title":  "Hybrid management technologies",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712734"
                                                  ],
                                   "speakerNames":  [
                                                        "Orin Thomas"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has now migrated the majority of their server hosts from Windows Server 2008 R2 to Windows Server 2019. Now, they are interested in the Azure hybrid technologies that are readily available to them. \\r\\n\\r\\nIn this session, learn how Tailwind Traders began using Windows Admin Center to manage its fleet of Windows Server computers and integrated hybrid technologies, such as Azure File Sync, Azure Active Directory Password Protection, Azure Backup, and Windows Defender ATP, to improve deployment performance and manageability.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86507,
                                   "title":  "Migrating IaaS workloads to Azure",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "724361"
                                                  ],
                                   "speakerNames":  [
                                                        "Pierre Roman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that the migration of their server hosts from Windows Server 2008 R2 to Windows Server 2019 is complete, Tailwind Traders wants to begin the process of â€œlift and shiftâ€‌: migrating some of their on-premises VMs theyâ€™ve been running in their datacenter.  \\r\\n\\r\\nIn this session, learn about how Tailwind Traders began the process of migrating some of their existing VM workloads to Azure and how this allowed them to retire aging server hardware and close datacenter and server rooms that were costing the organization a substantial amount of money.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86472",
        "sessionInstanceId":  "86472",
        "sessionCode":  "MOD10",
        "sessionCodeNormalized":  "MOD10",
        "title":  "Migrating web applications to Azure",
        "sortTitle":  "migrating web applications to azure",
        "sortRank":  2147483647,
        "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907380",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86474,
                                   "title":  "Moving your database to Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86471,
                                   "title":  "Enhancing web applications with cloud intelligence",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86476,
                                   "title":  "Debugging and interacting with production applications",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86484,
                                   "title":  "Managing delivery of your app via DevOps",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86561",
        "sessionInstanceId":  "86561",
        "sessionCode":  "DEP20",
        "sessionCodeNormalized":  "DEP20",
        "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
        "sortTitle":  "modern windows 10 and office 365 deployment with windows autopilot,آ desktop analytics, microsoft intune, and configuration manager",
        "sortRank":  2147483647,
        "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907359",
        "speakerIds":  [
                           "683098",
                           "712623"
                       ],
        "speakerNames":  [
                             "Harjit Dhaliwal",
                             "Michael Niehaus"
                         ],
        "speakerCompanies":  [
                                 "@Hoorge",
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86562,
                                   "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86563,
                                   "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86546,
                                   "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86551,
                                   "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85133",
        "sessionInstanceId":  "85133",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Modernizing web applications and data",
        "sortTitle":  "modernizing web applications and data",
        "sortRank":  2147483647,
        "description":  "Modernize workloads and migrate live databases to the cloud with minimal interruption. Learn how to auto scale your apps, use built-in database threat protection, and create pipelines that build and deploy solutions faster and more reliably.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120809",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86472,
                                 "title":  "Migrating web applications to Azure",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
                                 "location":  "Sheikh Rashid Hall E"
                             },
                             {
                                 "sessionId":  86474,
                                 "title":  "Moving your database to Azure",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
                                 "location":  "Sheikh Rashid Hall E"
                             },
                             {
                                 "sessionId":  86471,
                                 "title":  "Enhancing web applications with cloud intelligence",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "712663"
                                                ],
                                 "speakerNames":  [
                                                      "Laurent Bugnion"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
                                 "location":  "Sheikh Rashid Hall E"
                             },
                             {
                                 "sessionId":  86476,
                                 "title":  "Debugging and interacting with production applications",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "712663"
                                                ],
                                 "speakerNames":  [
                                                      "Laurent Bugnion"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
                                 "location":  "Sheikh Rashid Hall E"
                             },
                             {
                                 "sessionId":  86484,
                                 "title":  "Managing delivery of your app via DevOps",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [

                                                ],
                                 "speakerNames":  [

                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
                                 "location":  "Sheikh Rashid Hall E"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86489",
        "sessionInstanceId":  "86489",
        "sessionCode":  "APPS30",
        "sessionCodeNormalized":  "APPS30",
        "title":  "Modernizing your application with containers",
        "sortTitle":  "modernizing your application with containers",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907385",
        "speakerIds":  [
                           "721311"
                       ],
        "speakerNames":  [
                             "Jessica Deen"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86487,
                                   "title":  "Options for building and running your app in the cloud",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86486,
                                   "title":  "Options for data in the cloud",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86488,
                                   "title":  "Consolidating infrastructure with Azure Kubernetes Service",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86490,
                                   "title":  "Taking your app to the next level with monitoring, performance, and scaling",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90719",
        "sessionInstanceId":  "90719",
        "sessionCode":  "THR20001",
        "sessionCodeNormalized":  "THR20001",
        "title":  "Move to Windows 10 and Office 365 ProPlus with guidance from FastTrack",
        "sortTitle":  "move to windows 10 and office 365 proplus with guidance from fasttrack",
        "sortRank":  2147483647,
        "description":  "Explore how FastTrack can help your organization move to Windows 10 and Office 365 ProPlus, so your users can work securely from anywhere. Learn how to protect business data and devices by addressing essential security and compliance issues, and find out how FastTrack can help you address any application compatibility issues that you may encounter along the way.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T09:35:00+00:00",
        "endDateTime":  "2020-02-10T09:50:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "719751"
                       ],
        "speakerNames":  [
                             "George Moussalem"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86474",
        "sessionInstanceId":  "86474",
        "sessionCode":  "MOD20",
        "sessionCodeNormalized":  "MOD20",
        "title":  "Moving your database to Azure",
        "sortTitle":  "moving your database to azure",
        "sortRank":  2147483647,
        "description":  "Northwind kept the bulk of its data in an on-premises data center, which hosted servers running both SQL Server and MongoDB. After the acquisition, Tailwind Traders worked with the Northwind team to move their data center to Azure.  \\r\\n\\r\\nIn this session, see how to migrate an on-premises MongoDB database to Azure Cosmos DB and SQL Server database to an Azure SQL Server. From there, walk through performing the migration and ensuring minimal downtime while you switch over to the cloud-hosted providers.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Modernizing web applications and data",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907379",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86472,
                                   "title":  "Migrating web applications to Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When Tailwind Traders acquired Northwind earlier this year, they decided to consolidate their on-premises applications with Tailwind Tradersâ€™ current applications running on Azure. Their goal: vastly simplify the complexity that comes with an on-premises installation. \\r\\n\\r\\nIn this session, examine how a cloud architecture frees you up to focus on your applications, instead of your infrastructure. Then, see the options to â€œlift and shiftâ€‌ a web application to Azure, including: how to deploy, manage, monitor, and backup both a Node.js and .NET Core API, using Virtual Machines and Azure App Service.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86471,
                                   "title":  "Enhancing web applications with cloud intelligence",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has implemented development frameworks, deployment strategies, and server infrastructure for their apps. But now that they are on the cloud itâ€™s time to add cool features using simple scripts to access powerful services that automatically scale and run exactly where and when they need them. This includes language translation, image recognition, and other AI/ML features. \\r\\n\\r\\nIn this session, we create a set of routines that run on Azure Functions, respond to events in Azure Event Grid, and then orchestrate these functions and messages with Azure Logic Apps. We also use Azure Cognitive Services to add AI capabilities and Xamarin to implement AR features with a phone app.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86476,
                                   "title":  "Debugging and interacting with production applications",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "712663"
                                                  ],
                                   "speakerNames":  [
                                                        "Laurent Bugnion"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders is running fully on Azure, the developers must find ways to debug and interact with the production applications with minimal impact and maximal efficiency. Azure comes with a full set of tools and utilities that can be used to manage and monitor your applications.\\r\\n\\r\\nIn this session, see how streaming logs work to monitor the production application in real time. We also talk about deployment slots that enable easy A/B testing of new features and show how Snapshot Debugging can be used to live debug applications. From there, we explore how you can use other tools to manage your websites and containers live.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               },
                               {
                                   "sessionId":  86484,
                                   "title":  "Managing delivery of your app via DevOps",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, we show you how Tailwind Tradersâ€™ developer team works with its operations teams to safely automate tedious, manual tasks with reliable scripted routines and prepared services.  \\r\\n\\r\\nWe start with automating the building and deployment of a web application, backend web service and database with a few clicks. Then, we add automated operations that developers control like A/B testing and automated approval gates. We also discuss how Tailwind Traders can preserve their current investments in popular tools like Jenkins, while taking advantage of the best features of Azure DevOps.\\r\\n",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86629",
        "sessionInstanceId":  "86629",
        "sessionCode":  "ADM51",
        "sessionCodeNormalized":  "ADM51",
        "title":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
        "sortTitle":  "office 365 groups is the membership service that drives teamwork across microsoft 365. itâ€™s a core underpinning of teams, sharepoint, outlook, sharepoint, power bi, dynamics crm, and many other applications. in this session, youâ€™ll learn the fundamentals and new innovations in office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. we will also share the office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
        "sortRank":  2147483647,
        "description":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907332",
        "speakerIds":  [
                           "707230"
                       ],
        "speakerNames":  [
                             "Andrew Malone"
                         ],
        "speakerCompanies":  [
                                 "Quality Training (Scotland) Ltd"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86620,
                                   "title":  "Role-based access control in Microsoft 365: Improve your operations and security posture",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707230"
                                                  ],
                                   "speakerNames":  [
                                                        "Andrew Malone"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Role-based access control is essential for improving the security posture of your org, while providing IT with a focused experience based on permissions. In this session you will hear about how to use the centrally-managed, granular role-based access control in Microsoft 365 admin center.  We will dive into the new workload-specific admin roles and global reader role, showing you how to select the right administrator permissions and control who has access to your data.",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86523",
        "sessionInstanceId":  "86523",
        "sessionCode":  "ADM10",
        "sessionCodeNormalized":  "ADM10",
        "title":  "Onboarding and setup: Getting the most out of Microsoft 365",
        "sortTitle":  "onboarding and setup: getting the most out of microsoft 365",
        "sortRank":  2147483647,
        "description":  "Come and learn about the new onboarding experiences we\u0027ve built in the Microsoft 365 Admin Center. These experiences empower you to learn about and activate the different components of your subscription and to easily understand what to do next with intelligent recommendations. We also cover how you can take your Office 365 subscription to Microsoft 365 with our tailored setup experiences.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907367",
        "speakerIds":  [
                           "707230"
                       ],
        "speakerNames":  [
                             "Andrew Malone"
                         ],
        "speakerCompanies":  [
                                 "Quality Training (Scotland) Ltd"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86526,
                                   "title":  "Addressing top management issues with users and groups",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707230"
                                                  ],
                                   "speakerNames":  [
                                                        "Andrew Malone"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Efficient management of users, groups, and devices is core to ensuring your organization runs smoothly on Microsoft 365 services. Come learn tips and tricks on the best way to handle everyday challenges you face â€“ from ensuring a department sticks to their license budget, making sure youâ€™ve got access to those important emails when someone leaves, to setting up groups to enable modern teamwork.",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "92260",
        "sessionInstanceId":  "92260",
        "sessionCode":  "THR20017",
        "sessionCodeNormalized":  "THR20017",
        "title":  "One browser for modern and legacy web apps: Deploying Microsoft Edge and Internet Explorer mode",
        "sortTitle":  "one browser for modern and legacy web apps: deploying microsoft edge and internet explorer mode",
        "sortRank":  2147483647,
        "description":  "We have worked with numerous companies â€“ ranging from 1,000â€™s to 100,000â€™s of seats â€“ to move from multiple browser environments to a single browser environment. Weâ€™ll share lessons learned and best practices for piloting and deploying the next version of Microsoft Edge by leveraging our investments in Internet Explorer mode, Configuration Manager, and Intune",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:20:00+00:00",
        "endDateTime":  "2020-02-10T06:35:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "",
        "level":  "Intermediate (200)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "713875"
                       ],
        "speakerNames":  [
                             "Aditi Gangwar"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86487",
        "sessionInstanceId":  "86487",
        "sessionCode":  "APPS10",
        "sessionCodeNormalized":  "APPS10",
        "title":  "Options for building and running your app in the cloud",
        "sortTitle":  "options for building and running your app in the cloud",
        "sortRank":  2147483647,
        "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907386",
        "speakerIds":  [
                           "698031"
                       ],
        "speakerNames":  [
                             "Cassie Breviu"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86486,
                                   "title":  "Options for data in the cloud",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86489,
                                   "title":  "Modernizing your application with containers",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86488,
                                   "title":  "Consolidating infrastructure with Azure Kubernetes Service",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86490,
                                   "title":  "Taking your app to the next level with monitoring, performance, and scaling",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86486",
        "sessionInstanceId":  "86486",
        "sessionCode":  "APPS20",
        "sessionCodeNormalized":  "APPS20",
        "title":  "Options for data in the cloud",
        "sortTitle":  "options for data in the cloud",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907387",
        "speakerIds":  [
                           "715283"
                       ],
        "speakerNames":  [
                             "Christian Nwamba"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86487,
                                   "title":  "Options for building and running your app in the cloud",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86489,
                                   "title":  "Modernizing your application with containers",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86488,
                                   "title":  "Consolidating infrastructure with Azure Kubernetes Service",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86490,
                                   "title":  "Taking your app to the next level with monitoring, performance, and scaling",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86581",
        "sessionInstanceId":  "86581",
        "sessionCode":  "TMS30",
        "sessionCodeNormalized":  "TMS30",
        "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
        "sortTitle":  "plan and implement a successful upgrade from skype for business to microsoft teams",
        "sortRank":  2147483647,
        "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907347",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86583,
                                   "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86582,
                                   "title":  "Intelligent communications in Microsoft Teams",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999",
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones",
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86585,
                                   "title":  "Managing Microsoft Teams effectively",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86580,
                                   "title":  "Streamline business processes with the Microsoft Teams development platform",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85147",
        "sessionInstanceId":  "85147",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Power Platform",
        "sortTitle":  "power platform",
        "sortRank":  2147483647,
        "description":  "Learn how to build and manage innovative business solutions with the Power Platform. Easily connect all your data to analyze real-time business performance, act on data and insights with custom built apps, and automate workflows to continuously improve the processes you work on every day, no matter your technical expertise.",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120801",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86403,
                                 "title":  "Enabling everyone to digitize apps and processes with Power Apps and the Power Platform",
                                 "startDateTime":  "2020-02-10T06:45:00+00:00",
                                 "endDateTime":  "2020-02-10T07:45:00+00:00",
                                 "durationInMinutes":  60,
                                 "speakerIds":  [
                                                    "666688"
                                                ],
                                 "speakerNames":  [
                                                      "Christopher Mark Wilcock"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Learn how Power Apps and the Power Platform enable everyone in your organization to modernize and digitize apps and processes. You\u0027ll discover how your organization, IT Pros, and every developer within it can benefit from our low-code platform for rapid application development and process automation. This includes a fast-paced overview of pro-developer extensibility and DevOps, IT pro governance and security, as well as powerful capabilities to build intelligent web and mobile apps and portals.",
                                 "location":  "Sheikh Rashid Hall B"
                             },
                             {
                                 "sessionId":  86415,
                                 "title":  "Intelligent automation with Microsoft Power Automate",
                                 "startDateTime":  "2020-02-10T08:15:00+00:00",
                                 "endDateTime":  "2020-02-10T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "714853"
                                                ],
                                 "speakerNames":  [
                                                      "Mohamed Mahmoud"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Microsoft is modernizing business processes across applications â€“ bringing intelligent automation to everyone from end-users to advanced developers. Microsoft Power Automate is Microsoftâ€™s workflow and process automation platform with 270+ built-in connectors and can even connect to any custom apis. In this session we cover this vision in detail, both in terms of what is available today, such as the new AI Builder, and a roadmap of what is coming in the near future.",
                                 "location":  "Sheikh Rashid Hall B"
                             },
                             {
                                 "sessionId":  86417,
                                 "title":  "Enable modern analytics and enterprise business intelligence using Microsoft Power BI",
                                 "startDateTime":  "2020-02-10T10:00:00+00:00",
                                 "endDateTime":  "2020-02-10T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "666688"
                                                ],
                                 "speakerNames":  [
                                                      "Christopher Mark Wilcock"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Power BI is Microsoft\u0027s enterprise BI Platform that enables you to build comprehensive, enterprise-scale analytic solutions that deliver actionable insights. This session will dive into the latest capabilities and future roadmap. Various topics will be covered such as performance, scalability, management of Power BI artifacts, and monitoring. Learn how to use Power BI to create semantic models that are reused throughout large, enterprise organizations.",
                                 "location":  "Sheikh Rashid Hall B"
                             },
                             {
                                 "sessionId":  86416,
                                 "title":  "Connecting Power Apps, Microsoft Power Automate, Power BI, and the Common Data Service with data",
                                 "startDateTime":  "2020-02-10T11:15:00+00:00",
                                 "endDateTime":  "2020-02-10T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715251"
                                                ],
                                 "speakerNames":  [
                                                      "Ali Jibran Sayed Mohammed"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "In this session, we\u0027ll discuss how to use the Common Data Service, connectors, dataflows, and more to connect Power Apps, Microsoft Power Automate, and Power BI to your data.",
                                 "location":  "Sheikh Rashid Hall B"
                             },
                             {
                                 "sessionId":  86418,
                                 "title":  "Managing and supporting the Power Apps and Microsoft Power Automate at scale",
                                 "startDateTime":  "2020-02-10T12:30:00+00:00",
                                 "endDateTime":  "2020-02-10T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "715251"
                                                ],
                                 "speakerNames":  [
                                                      "Ali Jibran Sayed Mohammed"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Learn how administrators and IT-Pros can manage the enterprise adoption of Power Apps and Microsoft Power Automate. Discover the features, tools and practices to monitor, protect and support your organizations\u0027 data and innovations at scale. We\u0027ll share the top tips around governance, security, and monitoring requirements, as well as strategies employed by top customers to help you land low-code powered digital transformation in your organization.",
                                 "location":  "Sheikh Rashid Hall B"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86524",
        "sessionInstanceId":  "86524",
        "sessionCode":  "OPS50",
        "sessionCodeNormalized":  "OPS50",
        "title":  "Preparing for growth: Capacity planning and scaling",
        "sortTitle":  "preparing for growth: capacity planning and scaling",
        "sortRank":  2147483647,
        "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â€œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907368",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86508,
                                   "title":  "Building the foundation for modern ops: Monitoring",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722025"
                                                  ],
                                   "speakerNames":  [
                                                        "James Toulman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86506,
                                   "title":  "Responding to incidents",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86505,
                                   "title":  "Learning from failure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Incidents will happenâ€”thereâ€™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86522,
                                   "title":  "Deployment practices for greater reliability",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722024"
                                                  ],
                                   "speakerNames":  [
                                                        "Hosam Kamel"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86506",
        "sessionInstanceId":  "86506",
        "sessionCode":  "OPS20",
        "sessionCodeNormalized":  "OPS20",
        "title":  "Responding to incidents",
        "sortTitle":  "responding to incidents",
        "sortRank":  2147483647,
        "description":  "Your systems are down. Customers are calling. Every moment counts. What do you do? Handling incidents well is core to meeting your reliability goals. \\r\\n\\r\\nIn this session, explore incident management best practices - through the lens of Tailwind Traders - that will help you triage, remediate, and communicate as effectively as possible. We also walk through some of the tools Azure provides to get you back into a working state when time is of the essence.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T08:15:00+00:00",
        "endDateTime":  "2020-02-11T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Improving reliability through modern operations practices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907371",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86508,
                                   "title":  "Building the foundation for modern ops: Monitoring",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722025"
                                                  ],
                                   "speakerNames":  [
                                                        "James Toulman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Youâ€کre concerned about the reliability of your systems, services, and products. Where should you start? In this session, get an introduction to modern operations disciplines and a framework for reliability work. We jump into monitoring: the foundational practice you must tackle before you can make any headway with reliability. Using Tailwind Traders as an example, we demonstrate how to monitor your environment, including the right (and wrong) things to monitor â€“ and why. Youâ€™ll leave with the crucial tools and knowledge you need to discuss and improve reliability using objective data.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86505,
                                   "title":  "Learning from failure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Incidents will happenâ€”thereâ��™s no doubt about that. The key question is whether you treat them as a learning opportunity to make your operations practice better or just as a loss of time, money, and reputation.  \\r\\n\\r\\nIn this session, dive into one of the most important topics for improving reliability: how to learn from failure. We listen into one of Tailwind Traders post-incident reviews, often called a postmortem, and use that to learn how to shape and run this process to turn a failure into something actionable. After this session, youâ€™ll be able to build a key feedback loop in your organization that turns unplanned outages into opportunities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86522,
                                   "title":  "Deployment practices for greater reliability",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "722024"
                                                  ],
                                   "speakerNames":  [
                                                        "Hosam Kamel"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How software gets delivered to production and how infrastructure gets provisioned have a direct, material impact on your environmentâ€™s reliability. In this session, explore delivery and provisioning best practices that Tailwind Traders uses to prevent incidents before they happen. From the discussion and demos, youâ€™ll take away blueprints for these practices, an understanding of how they can be implemented using Azure, and ideas to apply them to your own apps and organization.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86524,
                                   "title":  "Preparing for growth: Capacity planning and scaling",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "When your growth or the demand for your systems exceeds, or is projected to exceed, your current capacity â€“ thatâ€™s a â€œgoodâ€‌ problem to have. However, this can be just as much of a threat to your systemâ€™s reliability as any other factor.  \\r\\n\\r\\nIn this session, dive into capacity planning and cost estimation basics, including the tools Azure provides to help with both. We wrap up with a discussion and demonstration of how Tailwind Traders judiciously applied Azure scaling features. Learn how to satisfy your customers and a growing demand, even when â€œchallengedâ€‌ by success.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86620",
        "sessionInstanceId":  "86620",
        "sessionCode":  "ADM31",
        "sessionCodeNormalized":  "ADM31",
        "title":  "Role-based access control in Microsoft 365: Improve your operations and security posture",
        "sortTitle":  "role-based access control in microsoft 365: improve your operations and security posture",
        "sortRank":  2147483647,
        "description":  "Role-based access control is essential for improving the security posture of your org, while providing IT with a focused experience based on permissions. In this session you will hear about how to use the centrally-managed, granular role-based access control in Microsoft 365 admin center.  We will dive into the new workload-specific admin roles and global reader role, showing you how to select the right administrator permissions and control who has access to your data.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "IT administratorâ€™s guide to managing productivity in the cloud",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907340",
        "speakerIds":  [
                           "707230"
                       ],
        "speakerNames":  [
                             "Andrew Malone"
                         ],
        "speakerCompanies":  [
                                 "Quality Training (Scotland) Ltd"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86629,
                                   "title":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707230"
                                                  ],
                                   "speakerNames":  [
                                                        "Andrew Malone"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Office 365 groups is the membership service that drives teamwork across Microsoft 365. Itâ€™s a core underpinning of Teams, SharePoint, Outlook, SharePoint, Power BI, Dynamics CRM, and many other applications. In this session, youâ€™ll learn the fundamentals and new innovations in Office 365 groups, including management and governance at scale, best practices for driving usage and adoption, and self-service. We will also share the Office 365 groups roadmap with you â€“ and how coming investments will help you drive new levels of collaboration.",
                                   "location":  "Sheikh Rashid Hall E"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86549",
        "sessionInstanceId":  "86549",
        "sessionCode":  "SECO10",
        "sessionCodeNormalized":  "SECO10",
        "title":  "Secure your enterprise with a strong identity foundation",
        "sortTitle":  "secure your enterprise with a strong identity foundation",
        "sortRank":  2147483647,
        "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Securing your organization",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907355",
        "speakerIds":  [
                           "717841"
                       ],
        "speakerNames":  [
                             "Subha Bhattacharyay"
                         ],
        "speakerCompanies":  [
                                 "Microsoft Corporation"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86547,
                                   "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697363"
                                                  ],
                                   "speakerNames":  [
                                                        "Milad Aslaner"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86548,
                                   "title":  "End-to-end cloud security for all your XaaS resources",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719750"
                                                  ],
                                   "speakerNames":  [
                                                        "David Maskell"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86550,
                                   "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86559,
                                   "title":  "Top 10 best security practices for Azure today",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703851"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiander Turpijn"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90734",
        "sessionInstanceId":  "90734",
        "sessionCode":  "THR30032",
        "sessionCodeNormalized":  "THR30032",
        "title":  "Securing Azure IaaS virtual machines",
        "sortTitle":  "securing azure iaas virtual machines",
        "sortRank":  2147483647,
        "description":  "In this session, learn the top five things that you can do to improve the security posture of your Azure IaaS VMs, including secure administration practices, security configuration management, as well as being notified of critical security events.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T09:05:00+00:00",
        "endDateTime":  "2020-02-10T09:20:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Managing Cloud Operations",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "724361"
                       ],
        "speakerNames":  [
                             "Pierre Roman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "85135",
        "sessionInstanceId":  "85135",
        "sessionCode":  "",
        "sessionCodeNormalized":  "",
        "title":  "Securing your organization",
        "sortTitle":  "securing your organization",
        "sortRank":  2147483647,
        "description":  "Learn how to protect your organizationâ€™s identities, data, applications, and devices across on-premises, cloud, and mobile - end to-end using the latest tools and guidance.آ ",
        "registrationLink":  "",
        "startDateTime":  null,
        "endDateTime":  null,
        "durationInMinutes":  0,
        "sessionType":  "Learning Path",
        "sessionTypeLogical":  "Learning Path",
        "learningPath":  "Securing your organization",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3301",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "120807",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [
                             {
                                 "sessionId":  86549,
                                 "title":  "Secure your enterprise with a strong identity foundation",
                                 "startDateTime":  "2020-02-11T07:00:00+00:00",
                                 "endDateTime":  "2020-02-11T07:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "717841"
                                                ],
                                 "speakerNames":  [
                                                      "Subha Bhattacharyay"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86547,
                                 "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
                                 "startDateTime":  "2020-02-11T08:15:00+00:00",
                                 "endDateTime":  "2020-02-11T09:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "697363"
                                                ],
                                 "speakerNames":  [
                                                      "Milad Aslaner"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86548,
                                 "title":  "End-to-end cloud security for all your XaaS resources",
                                 "startDateTime":  "2020-02-11T10:00:00+00:00",
                                 "endDateTime":  "2020-02-11T10:45:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "719750"
                                                ],
                                 "speakerNames":  [
                                                      "David Maskell"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86550,
                                 "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
                                 "startDateTime":  "2020-02-11T11:15:00+00:00",
                                 "endDateTime":  "2020-02-11T12:00:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "703050"
                                                ],
                                 "speakerNames":  [
                                                      "Christopher McNulty"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             },
                             {
                                 "sessionId":  86559,
                                 "title":  "Top 10 best security practices for Azure today",
                                 "startDateTime":  "2020-02-11T12:30:00+00:00",
                                 "endDateTime":  "2020-02-11T13:15:00+00:00",
                                 "durationInMinutes":  45,
                                 "speakerIds":  [
                                                    "703851"
                                                ],
                                 "speakerNames":  [
                                                      "Tiander Turpijn"
                                                  ],
                                 "speakerCompanies":  [

                                                      ],
                                 "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
                                 "location":  "Sheikh Maktoum Hall A"
                             }
                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90701",
        "sessionInstanceId":  "90701",
        "sessionCode":  "MDEV60",
        "sessionCodeNormalized":  "MDEV60",
        "title":  "Simplify sign in and authorization with the Microsoft identity platform",
        "sortTitle":  "simplify sign in and authorization with the microsoft identity platform",
        "sortRank":  2147483647,
        "description":  "Building a secure and usable authentication experience has been difficult and time-consuming. Whether youâ€™re building an app to reach consumers or enterprises, the Microsoft identity platform is here to help. In this session, learn how to authenticate personal Microsoft or Azure Active Directory accounts, and securely access APIs in your apps. Once integrated with the Microsoft identity platform, see how you can start accessing data in Microsoft Graph to build richer applications.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "606930"
                       ],
        "speakerNames":  [
                             "Kyle Marsh"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86452",
        "sessionInstanceId":  "86452",
        "sessionCode":  "AIML30",
        "sessionCodeNormalized":  "AIML30",
        "title":  "Start Building Machine Learning Models Faster than You Think",
        "sortTitle":  "start building machine learning models faster than you think",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907390",
        "speakerIds":  [
                           "698031"
                       ],
        "speakerNames":  [
                             "Cassie Breviu"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86614,
                                   "title":  "Making sense of your unstructured data with AI",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86451,
                                   "title":  "Using pre-built AI to solve business challenges",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86449,
                                   "title":  "Taking models to the next level with Azure Machine Learning best practices",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86496,
                                   "title":  "Machine learning operations: Applying DevOps to data science",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86429",
        "sessionInstanceId":  "86429",
        "sessionCode":  "AFUN50",
        "sessionCodeNormalized":  "AFUN50",
        "title":  "Storing data in Azure",
        "sortTitle":  "storing data in azure",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907396",
        "speakerIds":  [
                           "717897"
                       ],
        "speakerNames":  [
                             "Bernd Verst"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86616,
                                   "title":  "What you need to know about governance in Azure",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86563",
        "sessionInstanceId":  "86563",
        "sessionCode":  "DEP30",
        "sessionCodeNormalized":  "DEP30",
        "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
        "sortTitle":  "streamline and stay current with windows 10 and office 365 proplus",
        "sortRank":  2147483647,
        "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907358",
        "speakerIds":  [
                           "683098",
                           "712623"
                       ],
        "speakerNames":  [
                             "Harjit Dhaliwal",
                             "Michael Niehaus"
                         ],
        "speakerCompanies":  [
                                 "@Hoorge",
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86562,
                                   "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86561,
                                   "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86546,
                                   "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86551,
                                   "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86580",
        "sessionInstanceId":  "86580",
        "sessionCode":  "TMS50",
        "sessionCodeNormalized":  "TMS50",
        "title":  "Streamline business processes with the Microsoft Teams development platform",
        "sortTitle":  "streamline business processes with the microsoft teams development platform",
        "sortRank":  2147483647,
        "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907346",
        "speakerIds":  [
                           "697422"
                       ],
        "speakerNames":  [
                             "Preethy Krishnamurthy"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86583,
                                   "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86582,
                                   "title":  "Intelligent communications in Microsoft Teams",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999",
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones",
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86581,
                                   "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86585,
                                   "title":  "Managing Microsoft Teams effectively",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86546",
        "sessionInstanceId":  "86546",
        "sessionCode":  "DEP40",
        "sessionCodeNormalized":  "DEP40",
        "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
        "sortTitle":  "supercharge pc and mobile device management: attachآ configuration manager to microsoft intune and the microsoft 365 cloud",
        "sortRank":  2147483647,
        "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907357",
        "speakerIds":  [
                           "683098"
                       ],
        "speakerNames":  [
                             "Harjit Dhaliwal"
                         ],
        "speakerCompanies":  [
                                 "@Hoorge"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86562,
                                   "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86561,
                                   "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86563,
                                   "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86551,
                                   "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86566",
        "sessionInstanceId":  "86566",
        "sessionCode":  "COMP50",
        "sessionCodeNormalized":  "COMP50",
        "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
        "sortTitle":  "supercharge your ability to simplify it compliance and reduce risk with microsoft compliance score",
        "sortRank":  2147483647,
        "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "Advanced (300)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "Productivity",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907361",
        "speakerIds":  [
                           "715281"
                       ],
        "speakerNames":  [
                             "Ahmed Khairy"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:35:16.309+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86527,
                                   "title":  "Know your data: use intelligence to identify, protect and govern your important data",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86525,
                                   "title":  "Identify and take action on insider risks, threats and code of conduct violations",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86564,
                                   "title":  "Take control of your data explosion with intelligent Information Governance",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "716951"
                                                  ],
                                   "speakerNames":  [
                                                        "Rami Calache"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86565,
                                   "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86564",
        "sessionInstanceId":  "86564",
        "sessionCode":  "COMP30",
        "sessionCodeNormalized":  "COMP30",
        "title":  "Take control of your data explosion with intelligent Information Governance",
        "sortTitle":  "take control of your data explosion with intelligent information governance",
        "sortRank":  2147483647,
        "description":  "As data explodes in the modern workplace organizations recognize data is an asset but also a liability. Learn how Microsoft 365 can help your customers establish a comprehensive information governance strategy to intelligently manage your data lifecycle, keep what is important and delete what isn\u0027t.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Meeting organizational compliance requirements",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907363",
        "speakerIds":  [
                           "716951"
                       ],
        "speakerNames":  [
                             "Rami Calache"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86527,
                                   "title":  "Know your data: use intelligence to identify, protect and govern your important data",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Knowing your data, where it is stored, what is business critical, what is sensitive and needs to be protected, what should be kept and what can be deleted is an absolute priority.  In this session you will gain a deeper understanding of the new intelligent capabilities to assess the risks you face and how to reduce that risk by automatically classifying, labeling and protecting and governing data where it lives across your environment, endpoints, apps and services.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86525,
                                   "title":  "Identify and take action on insider risks, threats and code of conduct violations",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Insider threats and policy violations are a major risk for all companies and can easily go undetected until it is too late.  Proactively managing these risks and threats can provide you with a game changing advantage.  Gain a deeper understanding of how to gain visibility into and take action on insider threats, data leakage and policy violations.  Come learn about how the new Microsoft 365 Insider Risk Management and Communication Compliance solutions correlate multiple signals, from activities to communications, to give you a proactive view into potential threats and take remediate actions as appropriate.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86565,
                                   "title":  "eDiscovery and Audit: Harnessing intelligent and end-to-end solutions to improve results and lower costsâ€‹",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "669942"
                                                  ],
                                   "speakerNames":  [
                                                        "AMIT BHATIA"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Organizations are required often to quickly find relevant information related to investigations, litigation or regulatory requests.  However, discovering relevant information an organization needs when it is needed is both difficult and expensive.  Our Advanced e-discovery, Data Investigations and Audit capabilities enable you to quickly find relevant data and respond efficiently.  Come find our how you can reduce risk, time and cost in data discovery and remediation processes.  Itâ€™s applicable in a variety of scenarios, including litigations, internal investigations, privacy regulations and beyond.",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86566,
                                   "title":  "Supercharge your ability to simplify IT compliance and reduce risk with Microsoft Compliance Score",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715281"
                                                  ],
                                   "speakerNames":  [
                                                        "Ahmed Khairy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Continuously assessing, improving and monitoring the effectiveness of your security and privacy controls is a top priority for all companies today. The new Compliance Score can automatically assess controls implemented in your system and get recommended actions and tools to improve your risk profile on an ongoing basis. Come find out how Compliance Score can help you demystify compliance and make you the hero admins to help your organization manage risks and compliance. You will also see the updated Microsoft 365 compliance center with improved admin experience to help you discover solutions and get started easily.",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86449",
        "sessionInstanceId":  "86449",
        "sessionCode":  "AIML40",
        "sessionCodeNormalized":  "AIML40",
        "title":  "Taking models to the next level with Azure Machine Learning best practices",
        "sortTitle":  "taking models to the next level with azure machine learning best practices",
        "sortRank":  2147483647,
        "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T11:15:00+00:00",
        "endDateTime":  "2020-02-10T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907389",
        "speakerIds":  [
                           "697629"
                       ],
        "speakerNames":  [
                             "Henk Boelman"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86614,
                                   "title":  "Making sense of your unstructured data with AI",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86451,
                                   "title":  "Using pre-built AI to solve business challenges",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86452,
                                   "title":  "Start Building Machine Learning Models Faster than You Think",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86496,
                                   "title":  "Machine learning operations: Applying DevOps to data science",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86490",
        "sessionInstanceId":  "86490",
        "sessionCode":  "APPS50",
        "sessionCodeNormalized":  "APPS50",
        "title":  "Taking your app to the next level with monitoring, performance, and scaling",
        "sortTitle":  "taking your app to the next level with monitoring, performance, and scaling",
        "sortRank":  2147483647,
        "description":  "Making sense of application logs and metrics has been a challenge at Tailwind Traders. Some of the most common questions getting asked within the company are: â€œHow do we know what we\u0027re looking for? Do we look at logs? Metrics? Both?â€‌ Using Azure Monitor and Application Insights helps Tailwind Traders elevate their application logs to something a bit more powerful: telemetry. In session, youâ€™ll learn how the team wired up Application Insights to their public-facing website and fixed a slow-loading home page. Then, we expand this concept of telemetry to determine how Tailwind Tradersâ€™ CosmosDB  performance could be improved. Finally, weâ€™ll look into capacity planning and scale with powerful yet easy services like Azure Front Door.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developing cloud native applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907383",
        "speakerIds":  [
                           "707101"
                       ],
        "speakerNames":  [
                             "Tiberiu George Covaci"
                         ],
        "speakerCompanies":  [
                                 "Cloudeon A/S"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86487,
                                   "title":  "Options for building and running your app in the cloud",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Weâ€™ll show you how Tailwind Traders avoided a single point of failure using cloud services to deploy their company website to multiple regions. Weâ€™ll cover all the options they considered, explain how and why they made their decisions, then dive into the components of their implementation.    In this session, youâ€™ll see how they used Microsoft technologies like VS Code, Azure Portal, and Azure CLI to build a secure application that runs and scales on Linux and Windows VMs and Azure Web Apps with a companion phone app.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86486,
                                   "title":  "Options for data in the cloud",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is a large retail corporation with a dangerous single point of failure: sales, fulfillment, monitoring, and telemetry data is centralized across its online and brick and mortar outlets. We review structured databases, unstructured data, real-time data, file storage considerations, and share tips on balancing performance, cost, and operational impacts.   In this session, learn how Tailwind Traders created a flexible data strategy using multiple Azure services, such as Azure SQL, Azure Search, the Azure Cosmos DB API for MongoDB, the Gremlin API for Cosmos DB, and more â€“ and how to overcome common challenges and find the right storage option.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86489,
                                   "title":  "Modernizing your application with containers",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders recently moved one of its core applications from a virtual machine into containers, gaining deployment flexibility and repeatable builds.  In this session, youâ€™ll learn how to manage containers for deployment, options for container registries, and ways to manage and scale deployed containers. Youâ€™ll also learn how Tailwind Traders uses Azure Key Vault service to store application secrets and make it easier for their applications to securely access business critical data.",
                                   "location":  "Sheikh Maktoum Hall D"
                               },
                               {
                                   "sessionId":  86488,
                                   "title":  "Consolidating infrastructure with Azure Kubernetes Service",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "721311"
                                                  ],
                                   "speakerNames":  [
                                                        "Jessica Deen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Kubernetes is the open source container orchestration system that supercharges applications with scaling and reliability and unlocks advanced features, like A/B testing, Blue/Green deployments, canary builds, and dead-simple rollbacks.    In this session, see how Tailwind Traders took a containerized application and deployed it to Azure Kubernetes Service (AKS). Youâ€™ll walk away with a deep understanding of major Kubernetes concepts and how to put it all to use with industry standard tooling.",
                                   "location":  "Sheikh Maktoum Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86596",
        "sessionInstanceId":  "86596",
        "sessionCode":  "SOYS30",
        "sessionCodeNormalized":  "SOYS30",
        "title":  "The intelligent intranet: Transform communications and digital employee experiences",
        "sortTitle":  "the intelligent intranet: transform communications and digital employee experiences",
        "sortRank":  2147483647,
        "description":  "The intelligent intranet in Microsoft 365 connects the workplace to power collaboration, employee engagement, and knowledge management.  In this demo-heavy session, explore the latest innovations to help you transform your intranet into a rich, mobile-ready employee experiences that\u0027s dynamic, personalized, social and actionable. The session will explore new innovations for sites and portals, showcase common intranet scenarios, and provide actionable guidance toward optimal intranet architecture and governance.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:00:00+00:00",
        "endDateTime":  "2020-02-10T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Content collaboration, Communication, and Engagement in the Intelligent Workplace",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907343",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86595,
                                   "title":  "Content collaboration and protection with SharePoint, OneDrive and Microsoft Teams",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint connects the workplace and powers content collaboration. OneDrive connects you with all your files in Office 365. Teams is the hub for teamwork. Together, SharePoint, OneDrive and Teams are greater than the sum of their parts. Join us for an overview of how these products interact with each other and learn about latest integrations we are working on to bring the richness of SharePoint directly into Teams experiences and vice versa. We\u0027ll explore new innovations for sharing and working together with data using SharePoint lists, and no-code productivity solutions that streamline business processes. Finally, weâ€™ll explore how to structure teams and projects with hub sites.\\r\\n",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86598,
                                   "title":  "Connect the organization and engage people with SharePoint, Yammer and Microsoft Stream",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Company leaders recognize the need to transform their workforce, and organizations where employees are truly engaged report improved employee retention, customer satisfaction, sales metrics, and overall profitability. Microsoft 365 delivers the modern workplace and solutions that help you engage employees across organizational boundaries, generations and geographies, so you can empower your people to achieve more. Learn how SharePoint, Yammer and Stream work together to empower leaders to connect with their organizations, to align people to common goals, and to drive cultural transformation. Dive into the latest innovations including live events, new Yammer experiences and integrations, the intelligent intranet featuring home sites.",
                                   "location":  "Sheikh Rashid Hall D"
                               },
                               {
                                   "sessionId":  86600,
                                   "title":  "Harness collective knowledge with intelligent content services and Microsoft Search",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn about the most significant innovations ever unveiled for knowledge management and intelligent content services in Microsoft 365. Get the latest updates on Microsoft Search and other experiences that connect you with knowledge, insights, expertise, answers and actions, within your everyday experiences across Microsoft 365.",
                                   "location":  "Sheikh Rashid Hall D"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86604",
        "sessionInstanceId":  "86604",
        "sessionCode":  "MDEV10",
        "sessionCodeNormalized":  "MDEV10",
        "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
        "sortTitle":  "the perfectly tailored productivity suite starts with the microsoft 365 platform",
        "sortRank":  2147483647,
        "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907339",
        "speakerIds":  [
                           "606930"
                       ],
        "speakerNames":  [
                             "Kyle Marsh"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86605,
                                   "title":  "Microsoft Graph: a primer for developers",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86617,
                                   "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704728"
                                                  ],
                                   "speakerNames":  [
                                                        "Bill Ayers"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86619,
                                   "title":  "Transform everyday business processes with Microsoft 365 platform tools",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
                                   "location":  "Sheikh Rashid Hall A"
                               },
                               {
                                   "sessionId":  86618,
                                   "title":  "Windows 10: The developer platform, and modern application development",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719772"
                                                  ],
                                   "speakerNames":  [
                                                        "Giorgio Sardo"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
                                   "location":  "Sheikh Rashid Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86559",
        "sessionInstanceId":  "86559",
        "sessionCode":  "SECO50",
        "sessionCodeNormalized":  "SECO50",
        "title":  "Top 10 best security practices for Azure today",
        "sortTitle":  "top 10 best security practices for azure today",
        "sortRank":  2147483647,
        "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T12:30:00+00:00",
        "endDateTime":  "2020-02-11T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Securing your organization",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907351",
        "speakerIds":  [
                           "703851"
                       ],
        "speakerNames":  [
                             "Tiander Turpijn"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86549,
                                   "title":  "Secure your enterprise with a strong identity foundation",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717841"
                                                  ],
                                   "speakerNames":  [
                                                        "Subha Bhattacharyay"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86547,
                                   "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697363"
                                                  ],
                                   "speakerNames":  [
                                                        "Milad Aslaner"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86548,
                                   "title":  "End-to-end cloud security for all your XaaS resources",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719750"
                                                  ],
                                   "speakerNames":  [
                                                        "David Maskell"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86550,
                                   "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703050"
                                                  ],
                                   "speakerNames":  [
                                                        "Christopher McNulty"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "92261",
        "sessionInstanceId":  "92261",
        "sessionCode":  "THR10049",
        "sessionCodeNormalized":  "THR10049",
        "title":  "Top 10 reasons why youâ€™ll choose the next version of Microsoft Edge",
        "sortTitle":  "top 10 reasons why youâ€™ll choose the next version of microsoft edge",
        "sortRank":  2147483647,
        "description":  "We\u0027re on a mission to create the best browser for the enterprise. We believe the next version of Microsoft Edge is that browser and in this session, we will share the top 10 reasons why. You wonâ€™t believe reason #4!",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T06:30:00+00:00",
        "endDateTime":  "2020-02-11T06:45:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "",
        "level":  "Foundational (100)",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "713875"
                       ],
        "speakerNames":  [
                             "Aditi Gangwar"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90731",
        "sessionInstanceId":  "90731",
        "sessionCode":  "THR30033",
        "sessionCodeNormalized":  "THR30033",
        "title":  "Top five new features of Windows Server 2019",
        "sortTitle":  "top five new features of windows server 2019",
        "sortRank":  2147483647,
        "description":  "Windows Server 2019 is Microsoft\u0027s most rapidly adopted server operating system. With Windows Server 2008 and 2008 R2 end of support upon us, learn about some of the amazing new features included in the latest version of the Windows Server operating system. In this session, learn about the top new features in Windows Server 2019 including Windows Admin Center, Storage Migration Service, hyperconverged storage improvements, System Insights, Cluster Sets, Azure integration, Linux Containers and Kubernetes integration.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T10:50:00+00:00",
        "endDateTime":  "2020-02-10T11:05:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Migrating server infrastructure",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "712734"
                       ],
        "speakerNames":  [
                             "Orin Thomas"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "90722",
        "sessionInstanceId":  "90722",
        "sessionCode":  "THR20002",
        "sessionCodeNormalized":  "THR20002",
        "title":  "Top ten tips to securely rolling out Microsoft PowerApps and Microsoft Flow to your organization",
        "sortTitle":  "top ten tips to securely rolling out microsoft powerapps and microsoft flow to your organization",
        "sortRank":  2147483647,
        "description":  "Get ahead of common issues with broader enterprise adoption of Microsoft PowerApps and Microsoft Flow. We share the top tips to common governance blockers, security questions, and monitoring requirements, as well as strategies employed by top customers of the platform.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:50:00+00:00",
        "endDateTime":  "2020-02-11T11:05:00+00:00",
        "durationInMinutes":  15,
        "sessionType":  "Theater: 15 Minute",
        "sessionTypeLogical":  "Theater: 15 Minute",
        "learningPath":  "Power Platform",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3114",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "",
        "speakerIds":  [
                           "707167"
                       ],
        "speakerNames":  [
                             "Jasjit Chopra"
                         ],
        "speakerCompanies":  [
                                 "Penthara Technologies"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [

                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86619",
        "sessionInstanceId":  "86619",
        "sessionCode":  "MDEV40",
        "sessionCodeNormalized":  "MDEV40",
        "title":  "Transform everyday business processes with Microsoft 365 platform tools",
        "sortTitle":  "transform everyday business processes with microsoft 365 platform tools",
        "sortRank":  2147483647,
        "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907335",
        "speakerIds":  [
                           "702888"
                       ],
        "speakerNames":  [
                             "Jakob Nielsen"
                         ],
        "speakerCompanies":  [
                                 "Microsoft Corporation"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86604,
                                   "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "606930"
                                                  ],
                                   "speakerNames":  [
                                                        "Kyle Marsh"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86605,
                                   "title":  "Microsoft Graph: a primer for developers",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86617,
                                   "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704728"
                                                  ],
                                   "speakerNames":  [
                                                        "Bill Ayers"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86618,
                                   "title":  "Windows 10: The developer platform, and modern application development",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719772"
                                                  ],
                                   "speakerNames":  [
                                                        "Giorgio Sardo"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
                                   "location":  "Sheikh Rashid Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86550",
        "sessionInstanceId":  "86550",
        "sessionCode":  "SECO40",
        "sessionCodeNormalized":  "SECO40",
        "title":  "Understanding how the latest Microsoft Information Protection solutions help protect your sensitive data",
        "sortTitle":  "understanding how the latest microsoft information protection solutions help protect your sensitive data",
        "sortRank":  2147483647,
        "description":  "Learn about the key Microsoft Information Protection capabilities and integrations that help you better protect your sensitive data, through its lifecycle. The exponential growth of data and increasing compliance requirements makes protecting your most important and sensitive data more challenging then ever. We\u0027ll walk you through the latest capabilities to discover, classify \u0026 label, protect and monitor your sensitive data, across devices, apps, cloud services and on-premises. We\u0027ll discuss configuration and management experiences that makes it easier for security admins, as well as end-user experiences that help balance security and productivity. Our latest capabilities help provide a more consistent and comprehensive experience across Office applications, Azure Information Protection, Office 365 Data Loss Prevention,  Microsoft Cloud App Security, Windows and beyond.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Securing your organization",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907352",
        "speakerIds":  [
                           "703050"
                       ],
        "speakerNames":  [
                             "Christopher McNulty"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86549,
                                   "title":  "Secure your enterprise with a strong identity foundation",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717841"
                                                  ],
                                   "speakerNames":  [
                                                        "Subha Bhattacharyay"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With identity as the control plane, you can have greater visibility and control over who is accessing your organizationâ€™s applications and data and under which conditions. Come learn how Azure Active Directory can help you enable seamless access, strong authentication, and identity-driven security and governance for your users. This will be relevant to not only organizations considering modernizing their identity solutions, but also existing Azure Active Directory customers looking to see demos of the latest capabilities.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86547,
                                   "title":  "Dive deep into Microsoft 365 Threat Protection: See how we defend against threats like phishing and stop attacks in their tracks across your estate",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697363"
                                                  ],
                                   "speakerNames":  [
                                                        "Milad Aslaner"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "At Microsoft Ignite 2018 we introduced our big vision for Microsoft Threat Protection, an integrated solution providing security across multiple attack vectors including; identities, endpoints, email and data, cloud apps, and infrastructure. In 2019, weâ€™re excited to showcase features now in production that you can begin using in your environment. Weâ€™ll cover the very latest, including the ability to correlate incidents across your estate,  advanced hunting capabilities, and new automated incident response capabilities, as well as where we are in our journey with Microsoft Threat Protection and our forward-looking roadmap.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86548,
                                   "title":  "End-to-end cloud security for all your XaaS resources",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719750"
                                                  ],
                                   "speakerNames":  [
                                                        "David Maskell"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Today, in most organizations, there exists an abundance of security solutions and yet what will actually make you secure remains obscure. Come to this session to get your much-needed answers on the steps you can quickly take to protect yourself against the most prevelant current and emerging threats!\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86559,
                                   "title":  "Top 10 best security practices for Azure today",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "703851"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiander Turpijn"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With more computing environments moving to the cloud, the need for stronger cloud security has never been greater. But what constitutes effective cloud security for Azure, and what best practices should you be following?آ In this overview session, learn about five Azure security best practices, discover the latest Azure security innovations, listen to insights from a partner, and real-life security principles from an Azure customer.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86451",
        "sessionInstanceId":  "86451",
        "sessionCode":  "AIML20",
        "sessionCodeNormalized":  "AIML20",
        "title":  "Using pre-built AI to solve business challenges",
        "sortTitle":  "using pre-built ai to solve business challenges",
        "sortRank":  2147483647,
        "description":  "As a data-driven company, Tailwind Traders understands the importance of using artificial intelligence to improve business processes and delight customers. Before investing in an AI team, their existing developers were able to demonstrate some quick wins using pre-built AI technologies.  \\r\\n\\r\\nIn this session, we show how you can use Azure Cognitive Services to extract insights from retail data and go into the neural networks behind computer vision. Learn how it works and how to augment the pre-built AI with your own images for custom image recognition applications.\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T08:15:00+00:00",
        "endDateTime":  "2020-02-10T09:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Developers guide to AI",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907391",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86614,
                                   "title":  "Making sense of your unstructured data with AI",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders has a lot of legacy data that theyâ€™d like their developers to leverage in their apps â€“ from various sources, both structured and unstructured, and including images, forms, and several others. In this session, you\u0027ll learn how the team used Azure Cognitive Search to make sense of this data in a short amount of time and with amazing success. We\u0027ll discuss tons of AI concepts, like the ingest-enrich-explore pattern, search skillsets, cognitive skills, natural language processing, computer vision, and beyond.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86452,
                                   "title":  "Start Building Machine Learning Models Faster than You Think",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "698031"
                                                  ],
                                   "speakerNames":  [
                                                        "Cassie Breviu"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders uses custom machine learning models without requiring their teams to code. How? Azure Machine Learning Visual Interface.  In this session, learn the data science process that Tailwind Traders uses and get an introduction to Azure Machine Learning Visual Interface. See how to find, import, and prepare data, selecting a machine learning algorithm, training and testing the model, and how to deploy a complete model to an API. Lastly, we discuss how to avoid common data science beginner mistakes, providing additional resources for you to continue your machine learning journey.",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86449,
                                   "title":  "Taking models to the next level with Azure Machine Learning best practices",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Tradersâ€™ data science team uses natural language processing (NLP), and recently discovered how to fine tune and build a baseline models with Automated ML. \\r\\n\\r\\nIn this session, learn what Automated ML is and why itâ€™s so powerful, then dive into how to improve upon baseline models using examples from the NLP best practices repository. We highlight Azure Machine Learning key features and how you can apply them to your organization, including: low priority compute instances, distributed training with auto scale, hyperparameter optimization, collaboration, logging, and deployment.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               },
                               {
                                   "sessionId":  86496,
                                   "title":  "Machine learning operations: Applying DevOps to data science",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697629"
                                                  ],
                                   "speakerNames":  [
                                                        "Henk Boelman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Many companies have adopted DevOps practices to improve their software delivery, but these same techniques are rarely applied to machine learning projects. Collaboration between developers and data scientists can be limited and deploying models to production in a consistent, trustworthy way is often a pipe dream. \\r\\n\\r\\nIn this session, learn how Tailwind Traders applied DevOps practices to their machine learning projects using Azure DevOps and Azure Machine Learning Service. We show automated training, scoring, and storage of versioned models, wrap the models in Docker containers, and deploy them to Azure Container Instances or Azure Kubernetes Service. We even collect continuous feedback on model behavior so we know when to retrain.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall A"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86616",
        "sessionInstanceId":  "86616",
        "sessionCode":  "AFUN80",
        "sessionCodeNormalized":  "AFUN80",
        "title":  "What you need to know about governance in Azure",
        "sortTitle":  "what you need to know about governance in azure",
        "sortRank":  2147483647,
        "description":  "Tailwind Traders wants to make sure that their current and future Azure workloads adhere to a strict set of deployment and configuration guidelines. In this session, you\u0027ll learn how Tailwind Traders implements Azure governance technologies and best practices, like role-based access controls, to meet its compliance obligations and goals.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T10:00:00+00:00",
        "endDateTime":  "2020-02-11T10:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Azure fundamentals",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907337",
        "speakerIds":  [

                       ],
        "speakerNames":  [

                         ],
        "speakerCompanies":  [

                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86430,
                                   "title":  "Discovering Microsoft Azure",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "New developers at Tailwind Traders have a saying about learning our technology platform: \\"it\u0027s like drinking from a firehose.\\" Indeed, learning all Microsoft Azure services can seem overwhelming â€“ especially if you\u0027re unfamiliar with Azure or the cloud in general. In this session, we start at the beginning, introducing Azure and the core concepts that are foundational to our cloud platform. We start with a discussion of what cloud computing is and what Azure offers you and your team. We then take a look at basic services and features, setting up an account and subscription along the way. Finally, we tour the Azure Portal and do a quick overview of the resources available and what they do.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86431,
                                   "title":  "Azure networking basics",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715291"
                                                  ],
                                   "speakerNames":  [
                                                        "Bradley Stewart"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Now that Tailwind Traders has decided to take the journey into the cloud, they need to understand how their applications and services communicate with each other, the internet, and on-premises networks. In this session, we cover the basics of Azure networking: what it is, how it differs from on-premises, and how to take full advantage of its capabilities. We then learn how the virtual machines in your new network can communicate with each other over the internet and our on-premises network, using Virtual Network Peering, site-to-site VPN, and Azure ExpressRoute. Finally, we discuss how you to optimize, using Azure Traffic Manager.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86434,
                                   "title":  "Discovering Azure tooling and utilities",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719728"
                                                  ],
                                   "speakerNames":  [
                                                        "April Edwards"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Azure allows you to build your applications with the full power and resilience of the cloud. But, how do you do that? In this session, we show you the tools that Tailwind Traders uses on a daily basis, including the Visual Studio Code editor and its Azure extension. We also introduce you to the Azure Cloud Shell, which allows you to work with Azure resources - without the need for the Portal. Finally, we show you how Azure Resource Management (ARM) templates save you time and help you automate infrastructure, reducing the chance of errors that come with manual human input.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86432,
                                   "title":  "Azure security fundamentals",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "707101"
                                                  ],
                                   "speakerNames":  [
                                                        "Tiberiu George Covaci"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to improve the security of their workloads that are running in the cloud. In this session, learn how to use: Azure Security Center to determine how to configure Azure resources (using security best practices), Azure Sentinel to locate and respond to suspicious activity, and Azure Bastion for secure administrative connections into Azure.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86429,
                                   "title":  "Storing data in Azure",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717897"
                                                  ],
                                   "speakerNames":  [
                                                        "Bernd Verst"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders deals with gigantic amounts of data, continually pouring in from sources such as sales, marketing, and fulfillment. In the past, the only choice they had was to put it all into a relational database in a data center. However, by moving to Microsoft Azure, they can now optimize their data storage with increased scalability and resilience. In this session, we will introduce the various storage options available on Azure, from blob to SQL databases. Youâ€™ll learn about Azure Cosmos DB, a globally distributed, multi-model database, as well as SQL Data Warehouse and Data Factory.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86433,
                                   "title":  "Exploring containers and orchestration in Azure",
                                   "startDateTime":  "2020-02-11T07:00:00+00:00",
                                   "endDateTime":  "2020-02-11T07:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "726799"
                                                  ],
                                   "speakerNames":  [
                                                        "Hatim Nagarwala"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is in the process of moving from pure virtual machine workloads to using containers to run their apps. In this session, youâ€™ll learn the ins and outs of containers versus VMs (and when to use one over the other) and get an overview of Azure Container Service, including container orchestration with Azure Kubernetes Service. \\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86447,
                                   "title":  "Keeping costs down in Azure",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [

                                                  ],
                                   "speakerNames":  [

                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders wants to keep the costs of running their workloads in Azure predictable and within the organization\u0027s spending limits. In this session, you\u0027ll learn about the factors that go into Azure costs and hear some tips and tools to keep costs manageable - from using Azure calculators and setting spending limits and quotas to utilizing tagging to identify cost owners.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86448,
                                   "title":  "Azure identity fundamentals",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "719747"
                                                  ],
                                   "speakerNames":  [
                                                        "Roelf Zomerman"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Identity is the core of most workloads in Azure, and Tailwind Traders wants to implement Azure Active Directory in a way that correctly meshes their on-premises identities with those required in the cloud. In this session, learn the difference between authentication and authorization, as well as different identity models. Then, dive into the benefits of conditional access and multi-factor authentication (MFA) and wrap up with a demo showing you how to implement these types of extra protection.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               },
                               {
                                   "sessionId":  86450,
                                   "title":  "Figuring out Azure functions",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "715283"
                                                  ],
                                   "speakerNames":  [
                                                        "Christian Nwamba"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Tailwind Traders is curious about the concept behind â€œserverlessâ€‌ computing â€“ the idea that they can run small pieces of code in the cloud, without having to worry about the underlying infrastructure. In this session, weâ€™ll cover the world of Azure Functions, starting with an explanation of the servers behind serverless, exploring the languages and integrations available, and ending with a demo of when to use Logic Apps and Microsoft Flow.\\r\\n",
                                   "location":  "Sheikh Rashid Hall F"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86583",
        "sessionInstanceId":  "86583",
        "sessionCode":  "TMS10",
        "sessionCodeNormalized":  "TMS10",
        "title":  "What\u0027s new with Microsoft Teams: The hub for teamwork in Microsoft 365",
        "sortTitle":  "what\u0027s new with microsoft teams: the hub for teamwork in microsoft 365",
        "sortRank":  2147483647,
        "description":  "Join us to learn how Microsoft Teams, the hub for collaboration and intelligent communications, is transforming the way people work at Contoso. We showcase some of the big feature innovations weâ€™ve made in the last year and give you a sneak peek at some of the exciting new innovations coming to Microsoft Teams. This demo-rich session highlights the best Teams has to offer!\\r\\n",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T07:00:00+00:00",
        "endDateTime":  "2020-02-11T07:45:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Journey to Microsoft Teams",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907350",
        "speakerIds":  [
                           "702999"
                       ],
        "speakerNames":  [
                             "Diaundra Jones"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86582,
                                   "title":  "Intelligent communications in Microsoft Teams",
                                   "startDateTime":  "2020-02-11T08:15:00+00:00",
                                   "endDateTime":  "2020-02-11T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702999",
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Diaundra Jones",
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Microsoft Teams solves the communication needs of a diverse workforce. Calling and meeting experiences in Teams support more productive collaboration and foster teamwork across Contoso. Join us to learn more about the latest intelligent communications features along with the most recent additions to our device portfolio.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86581,
                                   "title":  "Plan and implement a successful upgrade from Skype for Business to Microsoft Teams",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "717224"
                                                  ],
                                   "speakerNames":  [
                                                        "Ghouse Shariff"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Explore the end-to-end Skype for Business to Teams upgrade experience, inclusive of technical and user readiness considerations.آ This session provides guidance for a successful upgrade and sharesآ learnings from enterprisesآ that have already successfully upgraded.آ  Learn more about the rich productivity and communicationآ capabilities ofآ Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86585,
                                   "title":  "Managing Microsoft Teams effectively",
                                   "startDateTime":  "2020-02-11T11:15:00+00:00",
                                   "endDateTime":  "2020-02-11T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "With simple and granular management capabilities, Microsoft Teams empowers Contoso administrators with the controls they need to provide the best experience possible to users while protecting company data and meeting business requirements. Join us to learn more about the latest security and administration capabilities of Microsoft Teams.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               },
                               {
                                   "sessionId":  86580,
                                   "title":  "Streamline business processes with the Microsoft Teams development platform",
                                   "startDateTime":  "2020-02-11T12:30:00+00:00",
                                   "endDateTime":  "2020-02-11T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "697422"
                                                  ],
                                   "speakerNames":  [
                                                        "Preethy Krishnamurthy"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join us to learn how Microsoft Teams can integrate applications and streamline business processes at Contoso. Teams can become your productivity hub by embedding the apps you are already using or deploying custom-built solutions using the latest dev tools. We show you how to leverage the Microsoft Power Platform to automate routine tasks like approvals and create low code apps for your Teams users.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall C"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86551",
        "sessionInstanceId":  "86551",
        "sessionCode":  "DEP50",
        "sessionCodeNormalized":  "DEP50",
        "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
        "sortTitle":  "why microsoft 365 device management is essential to your zero-trust strategy",
        "sortRank":  2147483647,
        "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T12:30:00+00:00",
        "endDateTime":  "2020-02-10T13:15:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907356",
        "speakerIds":  [
                           "683098"
                       ],
        "speakerNames":  [
                             "Harjit Dhaliwal"
                         ],
        "speakerCompanies":  [
                                 "@Hoorge"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86562,
                                   "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86561,
                                   "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86563,
                                   "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86546,
                                   "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86562",
        "sessionInstanceId":  "86562",
        "sessionCode":  "DEP10",
        "sessionCodeNormalized":  "DEP10",
        "title":  "Why Windows 10 Enterprise and Office 365 ProPlus? Security, privacy, and a great user experience",
        "sortTitle":  "why windows 10 enterprise and office 365 proplus? security, privacy, and a great user experience",
        "sortRank":  2147483647,
        "description":  "Windows 10 Enterprise and Microsoft Office 365 ProPlus are the best releases of Windows 10 and Office for enterprise customersâ€”as well as many small to midsize organizations. Learn about our enhanced investments across security, management, and privacy with a focus on end user productivity.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-10T06:45:00+00:00",
        "endDateTime":  "2020-02-10T07:45:00+00:00",
        "durationInMinutes":  60,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Deploying, managing, and servicing windows, office and all your devices",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907360",
        "speakerIds":  [
                           "683098"
                       ],
        "speakerNames":  [
                             "Harjit Dhaliwal"
                         ],
        "speakerCompanies":  [
                                 "@Hoorge"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86561,
                                   "title":  "Modern Windows 10 and Office 365 deployment with Windows Autopilot,آ Desktop Analytics, Microsoft Intune, and Configuration Manager",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "The process of deploying Windows 10 and Office 365 continues to evolve. Learn how to utilize Windows Autopilot, Desktop Analytics, and the Office Customization Toolkitâ€”all within your existing System Center Configuration Manager (SCCM) infrastructureâ€”to implement modern deployment practices that are zero touch and hyper efficient.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86563,
                                   "title":  "Streamline and stay current with Windows 10 and Office 365 ProPlus",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098",
                                                      "712623"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal",
                                                        "Michael Niehaus"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Why build a regular rhythm of Windows 10 and Microsoft Office 365 ProPlus updates across your environment? Join this session to learn specific, sustainable, yet scalable servicing strategies to drive enhanced security, reduced costs, and improved productivity. We dive into the latest update delivery technologies to reduce network infrastructure strain, and help you create an updated experience that is both smooth and seamless for end users. Come for the demos and stay for the scripts and best practices.\\r\\n",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86546,
                                   "title":  "Supercharge PC and mobile device management: Attachآ Configuration Manager to Microsoft Intune and the Microsoft 365 cloud",
                                   "startDateTime":  "2020-02-10T11:15:00+00:00",
                                   "endDateTime":  "2020-02-10T12:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Are you ready to transform to Microsoft 365 device management with a cloud-attached approach, but donâ€™t know where to start? Learn how the latest Configuration Managerâ€¯and Microsoft Intune innovations provide a clear path that can help you transform the way you manage devices while eliminating risk and delivering an employee experience that exceeds expectations. This session shows IT decision makers and IT professionals alike how to leverage the converged power of the Microsoft 365 cloud, Intune, and Configuration Manager and benefit from reduced costs, enhanced security, and improved productivity.",
                                   "location":  "Sheikh Maktoum Hall B"
                               },
                               {
                                   "sessionId":  86551,
                                   "title":  "Why Microsoft 365 device management is essential to your zero-trust strategy",
                                   "startDateTime":  "2020-02-10T12:30:00+00:00",
                                   "endDateTime":  "2020-02-10T13:15:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "683098"
                                                  ],
                                   "speakerNames":  [
                                                        "Harjit Dhaliwal"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Is your security model blocking remote access, collaboration, and productivity? Get the technical details on how organizations are using Microsoft 365 and Microsoft Intune to build a true defense-in-depth model to better protect their assets and intellectual property on PC and mobile devices.",
                                   "location":  "Sheikh Maktoum Hall B"
                               }
                           ]
    },
    {
        "@search.score":  1.0,
        "sessionId":  "86618",
        "sessionInstanceId":  "86618",
        "sessionCode":  "MDEV50",
        "sessionCodeNormalized":  "MDEV50",
        "title":  "Windows 10: The developer platform, and modern application development",
        "sortTitle":  "windows 10: the developer platform, and modern application development",
        "sortRank":  2147483647,
        "description":  "How do you build modern applications on Windows 10? What are some of the Windows 10 features that can make applications even better for users, and how can developers take advantage of these features from existing desktop applications? In this demo-focused and info-packed session, weâ€™ll cover the modern technologies for building applications on or for Windows, the different app models, how to take advantage of platform tools and features, and more. Weâ€™ll use Win32/.net apps, XAML, Progressive Web Apps (PWA) using JavaScript, Edge, packaging with MSIX, the modern command line, the Windows Subsystem for Linux and more.",
        "registrationLink":  "",
        "startDateTime":  "2020-02-11T11:15:00+00:00",
        "endDateTime":  "2020-02-11T12:00:00+00:00",
        "durationInMinutes":  45,
        "sessionType":  "Module: 45 Minute",
        "sessionTypeLogical":  "Module: 45 Minute",
        "learningPath":  "Develop integrations and workflows for your productivity applications",
        "level":  "",
        "products":  [

                     ],
        "format":  "",
        "topic":  "",
        "sessionTypeId":  "3107",
        "isMandatory":  false,
        "visibleToAnonymousUsers":  true,
        "visibleInSessionListing":  true,
        "techCommunityDiscussionId":  "907336",
        "speakerIds":  [
                           "719772"
                       ],
        "speakerNames":  [
                             "Giorgio Sardo"
                         ],
        "speakerCompanies":  [
                                 "Microsoft"
                             ],
        "sessionLinks":  [

                         ],
        "marketingCampaign":  [

                              ],
        "links":  "",
        "lastUpdate":  "2020-01-15T11:40:15.543+00:00",
        "techCommunityUrl":  "",
        "childModules":  [

                         ],
        "siblingModules":  [
                               {
                                   "sessionId":  86604,
                                   "title":  "The perfectly tailored productivity suite starts with the Microsoft 365 platform",
                                   "startDateTime":  "2020-02-10T06:45:00+00:00",
                                   "endDateTime":  "2020-02-10T07:45:00+00:00",
                                   "durationInMinutes":  60,
                                   "speakerIds":  [
                                                      "606930"
                                                  ],
                                   "speakerNames":  [
                                                        "Kyle Marsh"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "In this session, discover how developers and partners can use the Microsoft 365 platform to extend their solutions into familiar experiences across Microsoft 365 to tailor and enhance the productivity of tens of millions of people â€“ every day. We show you the tools and technology weâ€™ve created to help you enrich communications, elevate data analysis and streamline workflows across Microsoft 365. We also give you a preview of the next wave of extensibility solutions taking shape back in Redmond.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86605,
                                   "title":  "Microsoft Graph: a primer for developers",
                                   "startDateTime":  "2020-02-10T08:15:00+00:00",
                                   "endDateTime":  "2020-02-10T09:00:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Join this session to get a deeper understanding of the Microsoft Graph.آ We start with an origins story, and demonstrate just how deeply Microsoft Graph is woven into the fabric of everyday Microsoft 365 experiences. From there, we look at examples of partners who use the Microsoft Graph APIs to extend many of the same Microsoft Graph-powered experiences into their apps, and close by showing you how easy it is to get started building Microsoft Graph-powered apps of your own.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86617,
                                   "title":  "Building modern enterprise-grade collaboration solutions with Microsoft Teams and SharePoint",
                                   "startDateTime":  "2020-02-10T10:00:00+00:00",
                                   "endDateTime":  "2020-02-10T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "704728"
                                                  ],
                                   "speakerNames":  [
                                                        "Bill Ayers"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "SharePoint is the bedrock of enterprise intranets, while Microsoft Teams is the new collaboration tool on the block. In this session we look at each product individually, then show you how they can work together. We start with an overview of the SharePoint Framework and modern, cross-platform intranet development. We pivot to an overview of Microsoft Teams extensibility and demonstrate how to increase the speed relevance of collaboration in your organization. Finally, we put the two together â€“ with a little help from Microsoft Graph - and show you how a single application can run in both applications.",
                                   "location":  "Dubai C+D"
                               },
                               {
                                   "sessionId":  86619,
                                   "title":  "Transform everyday business processes with Microsoft 365 platform tools",
                                   "startDateTime":  "2020-02-11T10:00:00+00:00",
                                   "endDateTime":  "2020-02-11T10:45:00+00:00",
                                   "durationInMinutes":  45,
                                   "speakerIds":  [
                                                      "702888"
                                                  ],
                                   "speakerNames":  [
                                                        "Jakob Nielsen"
                                                    ],
                                   "speakerCompanies":  [

                                                        ],
                                   "description":  "Even the smallest gaps between people and systems in your organization can cost time and money. The Microsoft 365 platform has powerful solutions for professional and citizen developers that can close those gaps. We begin this session by showing you some low- and no-code business process automation scenarios using Microsoft PowerApps, Microsoft Flow and Excel. From there, we show you how adaptive cards and actionable messages can increase the velocity, efficiency, and productivity of your business. Finally, we demonstrate how to remain engaged with other software tools without switching context using Office add-ins.",
                                   "location":  "Sheikh Rashid Hall A"
                               }
                           ]
    }
]

''';
