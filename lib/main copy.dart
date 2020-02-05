import 'package:co_elrashid_ignite/sessions/data/day/conference_day.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabBarDemo(),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Day 01",
                ),
                Tab(
                  text: "Day 02",
                ),
              ],
            ),
            title: Text('Ignite'),
          ),
          body: TabBarView(
            children: [
              DayWidget(
                day: 10,
              ),
              DayWidget(
                day: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayWidget extends StatefulWidget {
  final int day;
  DayWidget({Key key, @required this.day}) : super(key: key);
  @override
  _DayWidgetState createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  ConferenceDay _day;

  refresh() async {
    print("refresh");
    setState(() {});
  }

  refreshData() async {
    _day = await getConferenceDay(widget.day);
    print("refreshData");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: refreshData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildScaffold();
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        });
  }

  Scaffold buildScaffold() {
    return Scaffold(
      body: conferenceDayWidget(),
      floatingActionButton: _floatingActionButtonWidget(),
    );
  }

  List<SesstionFilterEntry> _getFilters() {
    List<SesstionFilterEntry> _filters = List();
    if (_assgindColors[_learningPathKey] != null) {
      _assgindColors[_learningPathKey]
          .forEach((k, v) => _filters.add(SesstionFilterEntry(k, v)));
    }

    return _filters;
  }

  FloatingActionButton _floatingActionButtonWidget() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            context: context,
            builder: (context) {
              // return Container(
              //   color: Colors.red,
              // );
              return SesstionFilterWidget(
                filters: _getFilters(),
                notifyParent: refresh,
              );
            });
      },
      child: IconButton(
        icon: Icon(
          Icons.filter_list,
        ),
      ),
    );
  }

  Map<int, Widget> _widgets;

  Widget conferenceDayWidget() {
    print("conferenceDayWidget");
    _widgets = <int, Widget>{};
    return ListView.builder(
      itemCount: _day.sessionsGroups.length,
      itemBuilder: (context, index) {
        print(_widgets.keys.join(","));
        if (_widgets[index] == null) {
          _widgets[index] = SessionGroupWidget(
            sessionGroup: _day.sessionsGroups[index],
          );
        }
        return _widgets[index];
      },
    );
  }
}

List<String> _filters = <String>[];

class SesstionFilterEntry {
  const SesstionFilterEntry(this.name, this.color);
  final String name;
  final Color color;
}

class SesstionFilterWidget extends StatefulWidget {
  @override
  _SesstionFilterWidgetState createState() => _SesstionFilterWidgetState();
  final Function() notifyParent;

  final List<SesstionFilterEntry> filters;
  SesstionFilterWidget({Key key, @required this.filters, this.notifyParent})
      : super(key: key);
}

class _SesstionFilterWidgetState extends State<SesstionFilterWidget> {
  Iterable<Widget> get filterWidgets sync* {
    for (SesstionFilterEntry filter in widget.filters) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(filter.name),
          selected: _filters.contains(filter.name),
          elevation: _filters.contains(filter.name) ? 10 : 0,
          backgroundColor: filter.color,
          selectedColor: filter.color,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(filter.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == filter.name;
                });
              }
            });
            widget.notifyParent();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Paths'),
              Wrap(
                children: filterWidgets.toList(),
              ),
              // Text('Look for: ${_filters.join(', ')}'),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionGroupWidget extends StatelessWidget {
  SessionGroupWidget({this.sessionGroup});

  final SessionGroup sessionGroup;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              sessionGroup.dateStr,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sesstionsWidget(context, sessionGroup.sessions),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> sesstionsWidget(BuildContext context, List<Session> _sessions) {
    var widgets = <Widget>[];
    for (var _session in _sessions) {
      widgets.add(
        SesstionWidget(_session),
      );
    }
    return widgets;
  }
}

class SesstionWidget extends StatelessWidget {
  final Session session;

  SesstionWidget(this.session);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            session.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          // Text(
          //   session.speakerNames.join(),
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     height: 1.5,
          //   ),
          // ),
          // Text(
          //   session.speakerCompanies.join(),
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     height: 1.5,
          //   ),
          // ),
          LearningPathWidget(session),
          LocationWidget(session),
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(new ClipboardData(
                  text:
                      "${session.title} by ${session.speakerNames[0]} from ${session.speakerCompanies[0]} "));
            },
          ),
          // for (var speakerId in session.speakerIds)
          //   Image.asset('assets/i/no-bg/$speakerId.png',
          //       color: Colors.blueGrey, colorBlendMode: BlendMode.modulate),
          for (var speakerId in session.speakerIds)
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.blue[500],
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(80.0),
                  ),
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/i/no-bg/$speakerId.png',
                        color: Colors.blue[100],
                        colorBlendMode: BlendMode.modulate,
                        // fit: BoxFit.cover,
                      ),
                      Text(
                        session.speakerNames.join(),
                        style: TextStyle(
                          ),
                      ),
                      Text(
                        session.speakerCompanies.join(),
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                ),
              ),
            ),

          // for (var speakerId in session.speakerIds)
          //   for (var bm in BlendMode.values)
          //     Image.asset('assets/i/no-bg/$speakerId.png',
          //         color: Colors.red, colorBlendMode: bm),
          //  for (var speakerId in session.speakerIds)
          //       ColorFiltered(
          //         colorFilter:
          //             ColorFilter.mode(Colors.blueAccent, BlendMode.modulate),
          //         child: Image.asset('assets/i/no-bg/$speakerId.png'),
          //       ),
          // for (var speakerId in session.speakerIds)
          //   FutureBuilder(
          //       future:
          //           DefaultAssetBundle.of(context).load('assets/i/$speakerId'),
          //       builder: (BuildContext context, AsyncSnapshot snapshot) {
          //         if (snapshot.connectionState == ConnectionState.done &&
          //             snapshot.hasData) {
          //           var _data = snapshot.data;
          //           var uint8List = _data.buffer
          //               .asUint8List(_data.offsetInBytes, _data.lengthInBytes);
          //           // var listInt = uint8List.cast<int>();

          //           return ShaderMask(
          //             shaderCallback: (Rect bounds) {
          //               return RadialGradient(
          //                 center: Alignment.center,
          //                 radius: 1.0,
          //                 colors: <Color>[Colors.blue, Colors.white],
          //                 tileMode: TileMode.mirror,
          //               ).createShader(bounds);
          //             },
          //             child: Image.memory(
          //               uint8List,
          //             ),
          //           );
          //         } else {
          //           return new CircularProgressIndicator();
          //         }
          //       }),

          // Image(
          //   image: AssetImage('assets/i/$speakerId'),
          // ),
          //  Image.asset('assets/i/$speakerId',),
          // if (session.speakerIds.length > 0)
          //   Image.asset('assets/i/${session.speakerIds[0]}')
        ],
      ),
    );
  }
}

Widget speakers(Session session) {}
var _learningPathKey = "LearningPath";

class LearningPathWidget extends StatelessWidget {
  final Session session;

  LearningPathWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var str = session.learningPath.length > 0 ? session.learningPath : "Genral";
    Widget _widget;
    _widget = Container(
      decoration: new BoxDecoration(
        color: getRandomColor(_learningPathKey, str),
        borderRadius: new BorderRadius.all(
          const Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.verified_user,
              size: 10,
            ),
            Flexible(
              child: Text(
                str,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
    return _widget;
  }
}

class LocationWidget extends StatelessWidget {
  final Session session;

  LocationWidget(this.session);

  @override
  Widget build(BuildContext context) {
    // var str =
    //     session.siblingModules != null && session.siblingModules.length > 0
    //         ? session.siblingModules?.first?.location
    //         : "main hall";
    var str = session.location;
    Widget _widget;

    _widget = Container(
      decoration: new BoxDecoration(
        color: getRandomColor("Location", str),
        borderRadius: new BorderRadius.all(
          const Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 12,
            ),
            Flexible(
              child: Text(
                str,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
    return _widget;
  }
}

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
