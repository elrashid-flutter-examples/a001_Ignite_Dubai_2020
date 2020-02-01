import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  bool showMenu = true;
  while (showMenu) {
    showMenu = await mainMenu();
  }
  return 0;
}

Future<bool> mainMenu() async {
  // for (int i = 0; i < stdout.terminalLines; i++) {
  //   stdout.writeln();
  // }
  print("Choose an option:");
  print(" 1) getFacetFromApiToDisk");
  print(" 2) getSessionsCountFromApi");
  print(" 3) getPagesCountFromApi");
  print(" 4) getSearchPagesFromApiToDisk");
  print(" 5) combineSearchPagesFiles");
  print(" 6) getSessionsDetailsFromApiToDisk");
  print(" 7) combineSessionsFiles");
  print(" 8) getSpeakersDetailsFromApiToDisk");
  print(" 9) combineSpeakersFiles");
  print("10) getSpeakersImagesFromApiToDisk");
  print("11) convertSpeakersImagestoBase64 [don't used]");
  print("12) copyToAssets");
  print(" 0) Exit");
  print("\r\nSelect an option: ");

  switch (stdin.readLineSync(encoding: Encoding.getByName('utf-8'))) {
    // case true:
    //   print("\r\n");
    //   continue continue1;
    // continue1:
    case "1":
      getFacetFromApiToDisk();
      return true;
    case "2":
      await getSessionsCountFromApi();
      return true;
    case "3":
      await getPagesCountFromApi();
      return true;
    case "4":
      await getSearchPagesFromApiToDisk();
      return true;
    case "5":
      await combineSearchPagesFiles();
      return true;
    case "6":
      await getSessionsDetailsFromApiToDisk();
      return true;
    case "7":
      await combineSessionsFiles();
      return true;
    case "8":
      await getSpeakersDetailsFromApiToDisk();
      return true;
    case "9":
      await combineSpeakersFiles();
      return true;
    case "10":
      await getSpeakersImagesFromApiToDisk();
      return true;
    case "11":
      // await convertSpeakersImagestoBase64();
      return true;
    case "12":
      await copyToAssets();
      return true;
    case "0":
      return false;
    default:
      return true;
  }
}

var itemsPerPage = 10;
var jwt = r'''your_jwt_optinal''';

var speakersfileName = "speakers/speakers.json";
var sessionsfileName = "sessions/sessions.json";

Future getFacetFromApiToDisk() async {
  var url =
      'https://api-dubai.myignitetour.techcommunity.microsoft.com/api/session/facet';

  print("\n");
  print("requesting => $url");
  print("\n");

  var response = await HttpClient()
      .getUrl(Uri.parse(url))
      .then((request) => request.close());

  String reply = await response.transform(utf8.decoder).join();
  JsonEncoder encoder = new JsonEncoder.withIndent(' ');
  String json = encoder.convert(jsonDecode(reply));

  print("\n");
  print("saving => facet/facet.json");
  print("\n");

  Directory("facet").createSync(recursive: true);
  new File("facet/facet.json").writeAsString(json);
}

Future<int> getSessionsCountFromApi() async {
  var file = new File("facet/facet.json");
  if (!file.existsSync()) {
    await getFacetFromApiToDisk();
  } else {
    print("\n");
    print("facet/facet.json exists reading from disk");
    print("\n");
  }
  var reply = await file.readAsString();
  Iterable json = jsonDecode(reply);
  var count = json.where((w) => w["key"] == "format").toList()[0]["value"]
      ["filters"][0]["count"];
  print("\n");
  print("sessions count from api is : $count");
  print("\n");
  return count;
}

Future<int> getPagesCountFromApi() async {
  var count = await getSessionsCountFromApi();
  var pages = (count ~/ itemsPerPage) + (count % itemsPerPage > 0 ? 1 : 0);
  print("\n");
  print("pages count from api is : $pages");
  print("\n");
  return pages;
}

Future getSearchPagesFromApiToDisk() async {
  var pages = await getPagesCountFromApi();
  for (var page = 1; page < pages + 1; page++) {
    print("\n");
    print("getting page $page from $pages pages");
    print("\n");
    await getSearchPageFromApiToDisk(
        itemsPerPage: itemsPerPage, searchPage: page);
  }
}

Future getSearchPageFromApiToDisk(
    {int itemsPerPage = 10, int searchPage = 1}) async {
  String url =
      'https://api-dubai.myignitetour.techcommunity.microsoft.com/api/session/search';

  print("\n");
  print("requesting => $url");
  print("\n");

  Map jsonMap = {
    "itemsPerPage": itemsPerPage,
    "searchText": "*",
    "searchPage": searchPage,
    "sortOption": "ASC",
    "searchFacets": {
      "facets": [],
      "personalizationFacets": [],
      "dateFacet": [
        {
          "startDateTime": "2020-02-10T04:30:00.000Z",
          "endDateTime": "2020-02-10T14:59:59.000Z"
        },
        {
          "startDateTime": "2020-02-11T04:30:00.000Z",
          "endDateTime": "2020-02-11T14:59:59.000Z"
        }
      ]
    },
    "recommendedItemIds": [],
    "favoritesIds": [],
    "mustHaveOnDemandVideo": false
  };

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  // check the response statusCode
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');
  var replyJson = encoder.convert(jsonDecode(reply));

  var fileName = "searches/search.$searchPage.json";

  print("\n");
  print("saving => $fileName");
  print("\n");

  Directory("searches").createSync(recursive: true);
  new File(fileName).writeAsString(replyJson);
}

Future combineSearchPagesFiles() async {
  var pages = await getPagesCountFromApi();
  List searches = [];

  for (var page = 1; page < pages + 1; page++) {
    var fileName = "searches/search.$page.json";

    var file = new File(fileName);
    if (!file.existsSync()) {
      await await getSearchPageFromApiToDisk(
          itemsPerPage: itemsPerPage, searchPage: page);
    } else {
      print("\n");
      print("$fileName exists reading from disk");
      print("\n");
    }

    var reply = await file.readAsString();
    Iterable search = (jsonDecode(reply))["data"];
    searches.addAll(search);
  }

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');

  String json = encoder.convert(searches);

  var searchesfileName = "searches/searches.json";
  print("\n");
  print("saving => $searchesfileName");
  print("\n");

  await new File(searchesfileName).writeAsString(json);
}

Future getSessionsDetailsFromApiToDisk() async {
  var searchesfileName = "searches/searches.json";
  var searchesfile = new File(searchesfileName);
  if (!searchesfile.existsSync()) {
    await combineSearchPagesFiles();
  } else {
    print("\n");
    print("$searchesfileName exists reading from disk");
    print("\n");
  }

  var searchs =
      (jsonDecode(await searchesfile.readAsString()) as Iterable).toList();

  var client = HttpClient();

  for (var i = 0; i < searchs.length; i++) {
    var sessionId = searchs[i]["sessionId"];
    await getSessionDetailsFromApiToDisk(sessionId, client);
  }
}

Future getSessionDetailsFromApiToDisk(sessionId, HttpClient client) async {
  var url =
      'https://api-dubai.myignitetour.techcommunity.microsoft.com/api/session/' +
          sessionId;

  print("\n");
  print("requesting => $url");
  print("\n");

  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  if (jwt != "your_jwt_optinal") request.headers.set('x-jwt', jwt);

  print(request.headers.toString());
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  client.close();

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');
  String json = encoder.convert(jsonDecode(reply));
  Directory("sessions").createSync(recursive: true);
  var fileName = "sessions/session$sessionId.json";

  print("\n");
  print("saving => $fileName");
  print("\n");

  await new File(fileName).writeAsString(json);
}

Future combineSessionsFiles() async {
  var searchesfileName = "searches/searches.json";
  var searchesfile = new File(searchesfileName);
  if (!searchesfile.existsSync()) {
    await combineSearchPagesFiles();
  } else {
    print("\n");
    print("$searchesfileName exists reading from disk");
    print("\n");
  }

  var searchs =
      (jsonDecode(await searchesfile.readAsString()) as Iterable).toList();

  var client = HttpClient();
  List sessions = [];

  for (var i = 0; i < searchs.length; i++) {
    var sessionId = searchs[i]["sessionId"];
    var fileName = "sessions/session$sessionId.json";
    var file = new File(fileName);
    if (!file.existsSync()) {
      await getSessionDetailsFromApiToDisk(sessionId, client);
    } else {
      print("\n");
      print("$fileName exists reading from disk");
      print("\n");
    }

    var reply = await file.readAsString();
    var session = jsonDecode(reply);
    sessions.add(session);
  }

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');

  String json = encoder.convert(sessions);

  print("\n");
  print("saving => $sessionsfileName");
  print("\n");

  await new File(sessionsfileName).writeAsString(json);
}

getSpeakerIdsFormSessions() async {
  var sessionsfileName = "sessions/sessions.json";
  var sessionsfile = new File(sessionsfileName);
  if (!sessionsfile.existsSync()) {
    await combineSessionsFiles();
  } else {
    print("\n");
    print("$sessionsfileName exists reading from disk");
    print("\n");
  }

  var sessions =
      (jsonDecode(await sessionsfile.readAsString()) as Iterable).toList();

  var speakerIds = [];

  for (var i = 0; i < sessions.length; i++) {
    var sessionSpeakerIds = sessions[i]["speakerIds"] as List;
    for (var ii = 0; ii < sessionSpeakerIds.length; ii++) {
      speakerIds.add(sessionSpeakerIds[ii]);
    }
  }

  speakerIds = speakerIds.toSet().toList();
  speakerIds.sort((s1, s2) => int.parse(s1) - int.parse(s2));

  print("\n");
  print("Speakers Count is ${speakerIds.length}");
  print("\n");

  return speakerIds;
}

getSpeakersDetailsFromApiToDisk() async {
  var speakerIds = await getSpeakerIdsFormSessions() as List<int>;
  var client = await HttpClient();

  for (var i = 0; i < speakerIds.length; i++) {
    var speakerId = speakerIds[i];
    await getSpeakerDetailFromApiToDisk(speakerId, client);
  }
}

Future getSpeakerDetailFromApiToDisk(speakerId, HttpClient client) async {
  var url =
      'https://api-dubai.myignitetour.techcommunity.microsoft.com/api/speaker/$speakerId';

  print("\n");
  print("requesting => $url");
  print("\n");

  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  if (jwt != "your_jwt_optinal") request.headers.set('x-jwt', jwt);

  print(request.headers.toString());
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  client.close();

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');
  String json = encoder.convert(jsonDecode(reply));
  Directory("speakers").createSync(recursive: true);
  var fileName = "speakers/speaker$speakerId.json";

  print("\n");
  print("saving => $fileName");
  print("\n");

  await new File(fileName).writeAsString(json);
}

combineSpeakersFiles() async {
  var speakerIds = await getSpeakerIdsFormSessions() as List;
  List speakers = [];
  var client = HttpClient();

  for (var i = 0; i < speakerIds.length; i++) {
    var speakerId = speakerIds[i];
    var fileName = "speakers/speaker$speakerId.json";

    var file = new File(fileName);
    if (!file.existsSync()) {
      await getSpeakerDetailFromApiToDisk(speakerId, client);
    } else {
      print("\n");
      print("$fileName exists reading from disk");
      print("\n");
    }

    var fileText = await file.readAsString();
    var speaker = jsonDecode(fileText);
    speakers.add(speaker);
  }

  JsonEncoder encoder = new JsonEncoder.withIndent(' ');

  String json = encoder.convert(speakers);

  print("\n");
  print("saving => $speakersfileName");
  print("\n");

  await new File(speakersfileName).writeAsString(json);
}

getSpeakersImagesFromApiToDisk() async {
  var speakerIds = await getSpeakerIdsFormSessions() as List;

  for (var i = 0; i < speakerIds.length; i++) {
    var speakerId = speakerIds[i];
    var speaker =
        await new File("speakers/speaker$speakerId.json").readAsString();
    var url = (jsonDecode(speaker))["photo"];
    Directory("speakersI").createSync(recursive: true);
    var fileName = "speakersI/$speakerId";

    print("\n");
    print("requesting => $url");
    print("saving Bytes stream to => $fileName");
    print("\n");

    var file = new File(fileName);
    await new HttpClient()
        .getUrl(Uri.parse(url))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) => response.pipe(file.openWrite()));
  }
}

convertSpeakersImagestoBase64() async {
  var speakerIds = await getSpeakerIdsFormSessions() as List;
  Directory("speakersI/b").createSync(recursive: true);

  for (var i = 0; i < speakerIds.length; i++) {
    var speakerId = speakerIds[i];
    var fileName = "speakersI/$speakerId";
    var file = new File(fileName);
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    new File("speakersI/b/$speakerId").writeAsStringSync(base64Image);
  }
}

copyToAssets() async {
  var sessionsfile = new File(sessionsfileName);
  sessionsfile.copySync(path.normalize(path.join(
      path.current, "../assets/" + path.basename(sessionsfile.path))));

  var speakersfile = new File(speakersfileName);
  speakersfile.copySync(path.normalize(path.join(
      path.current, "../assets/" + path.basename(speakersfile.path))));

  var speakerIds = await getSpeakerIdsFormSessions() as List;
  for (var i = 0; i < speakerIds.length; i++) {
    var speakerId = speakerIds[i];
    var imageFileName = "speakersI/$speakerId";
    var imageFile = new File(imageFileName);
    Directory(path.normalize(path.join(path.current, "../assets/i/")))
        .createSync(recursive: true);

    imageFile.copySync(path.normalize(path.join(
        path.current, "../assets/i/" + path.basename(imageFile.path))));
  }
}
