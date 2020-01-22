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
      home: MyApp2(),
    );
  }
}

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  ConferenceDay _day01;
  @override
  Widget build(BuildContext context) {
    _day01 = getConferenceDay01(_filters);

    return buildScaffold(context, _day01);
  }

  refresh() {
    _day01 = getConferenceDay01(_filters);
    print("refresh");
    setState(() {});
  }

  Scaffold buildScaffold(BuildContext context, ConferenceDay _day01) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ignite"),
      ),
      body: filterWidget(context, _day01),
      floatingActionButton: _floatingActionButtonWidget(context),
    );
  }

  List<SesstionFilterEntry> _getFilters() {
    List<SesstionFilterEntry> _filters = List();
    _assgindColors1.forEach((k, v) => _filters.add(SesstionFilterEntry(k, v)));

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
              return CastFilter(
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

  Widget filterWidget(
    BuildContext _context,
    ConferenceDay _conferenceDay,
  ) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[],
        ),
        Expanded(child: conferenceDayWidget(_context, _conferenceDay)),
      ],
    );
  }

  Widget conferenceDayWidget(
    BuildContext _context,
    ConferenceDay _conferenceDay,
  ) {
    var widgets = <Widget>[];
    for (var _sessionGroup in _conferenceDay.sessionsGroups) {
      widgets.add(
        sessionGroupWidget(_context, _sessionGroup),
      );
      widgets.add(Divider(
        color: Colors.black.withOpacity(0.5),
      ));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget sessionGroupWidget(
    BuildContext _context,
    SessionGroup _sessionGroup,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              _sessionGroup.dateStr,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sesstionsWidget(context, _sessionGroup.sessions),
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
        sesstionWidget(context, _session),
      );
    }
    return widgets;
  }

  Widget sesstionWidget(BuildContext context, Session _session) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _session.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Text(
            _session.speakerNames.join(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Text(
            _session.speakerCompanies.join(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Table(
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: xxx2(_session)),
                  Align(alignment: Alignment.centerLeft, child: xxx1(_session)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget xxx0(Session _session) {
  //   var str =
  //       _session.learningPath.length > 0 ? _session.learningPath : "keynote";

  //   return ClipRect(
  //     child: Container(
  //       color: color(str),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(str,
  //             style: TextStyle(
  //               fontSize: 10,
  //               color: Colors.black.withOpacity(0.8),
  //             )),
  //       ),
  //     ),
  //   );
  // }

  Widget xxx1(Session _session) {
    var str =
        _session.learningPath.length > 0 ? _session.learningPath : "keynote";
    Widget _widget;
    _widget = Chip(
      // onDeleted: () {
      //   _filtters.add(_widget);
      //   setState(() {});
      // },
      deleteIconColor: Colors.black.withOpacity(0.45),
      backgroundColor: color1(str),
      labelStyle: TextStyle(
        fontSize: 10,
        color: Colors.black.withOpacity(0.8),
      ),
      label: Text(
        str,
      ),
    );
    return _widget;
  }

  Widget xxx2(Session _session) {
    var str =
        _session.siblingModules != null && _session.siblingModules.length > 0
            ? _session.siblingModules?.first?.location
            : "main hall";
    return Chip(
      avatar: Icon(
        Icons.location_on,
        color: Colors.black.withOpacity(0.45),
      ),
      backgroundColor: color2(str),
      labelStyle: TextStyle(
        fontSize: 10,
        color: Colors.black.withOpacity(0.8),
      ),
      label: Text(
        str,
      ),
    );
  }

  // Widget xxx3(Session _session) {
  //   var str = _session.durationInMinutes > 0
  //       ? _session.durationInMinutes.toString()
  //       : "⏳";

  //   return Chip(
  //     backgroundColor: color(str),
  //     labelStyle: TextStyle(
  //       fontSize: 10,
  //       color: Colors.black.withOpacity(0.8),
  //     ),
  //     label: Text(
  //       str,
  //     ),
  //   );
  // }

  var _assgindColors1 = <String, Color>{};
  Color color1(String str) {
    if (_assgindColors1[str] == null) {
      _assgindColors1[str] =
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(0.3);
    }
    return _assgindColors1[str];
  }
}

var _assgindColors2 = <String, Color>{};
Color color2(String str) {
  if (_assgindColors2[str] == null) {
    _assgindColors2[str] =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(0.3);
  }
  return _assgindColors2[str];
}

class SesstionFilterEntry {
  const SesstionFilterEntry(this.name, this.color);
  final String name;
  final Color color;
}

class CastFilter extends StatefulWidget {
  @override
  State createState() => CastFilterState();
  final Function() notifyParent;

  final List<SesstionFilterEntry> filters;
  CastFilter({Key key, @required this.filters, this.notifyParent})
      : super(key: key);
}

List<String> _filters = <String>[];

class CastFilterState extends State<CastFilter> {
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
