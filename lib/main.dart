import 'package:co_elrashid_ignite/sessions.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math' as math;

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
      home: Day01lWidget(),
    );
  }
}

class Day01lWidget extends StatefulWidget {
  @override
  _Day01lWidgetState createState() => _Day01lWidgetState();
}

class _Day01lWidgetState extends State<Day01lWidget> {
  ConferenceDay _day01;

  refresh() {
    _day01 = getConferenceDay01(_filters);
    print("refresh");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _day01 = getConferenceDay01(_filters);
    return buildScaffold(context, _day01);
  }

  Scaffold buildScaffold(BuildContext context, ConferenceDay _day01) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ignite"),
      ),
      body: conferenceDayWidget(context, _day01),
      floatingActionButton: _floatingActionButtonWidget(context),
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

  FloatingActionButton _floatingActionButtonWidget(BuildContext _context) {
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

  Widget conferenceDayWidget(
    BuildContext _context,
    ConferenceDay _conferenceDay,
  ) {
    print("conferenceDayWidget");
    _widgets = <int, Widget>{};
    return ListView.builder(
      itemCount: _conferenceDay.sessionsGroups.length,
      itemBuilder: (context, index) {
        print(_widgets.keys.join(","));
        if (_widgets[index] == null) {
          _widgets[index] = SessionGroupWidget(
            sessionGroup: _conferenceDay.sessionsGroups[index],
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
          Text(
            session.speakerNames.join(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Text(
            session.speakerCompanies.join(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          LearningPathWidget(session),
          LocationWidget(session),
        ],
      ),
    );
  }
}

var _learningPathKey = "LearningPath";

class LearningPathWidget extends StatelessWidget {
  final Session session;

  LearningPathWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var str =
        session.learningPath.length > 0 ? session.learningPath : "keynote";
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
    var str =
        session.siblingModules != null && session.siblingModules.length > 0
            ? session.siblingModules?.first?.location
            : "main hall";

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
