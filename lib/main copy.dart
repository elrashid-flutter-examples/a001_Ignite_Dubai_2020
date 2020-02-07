import 'dart:convert';
import 'dart:math';

import 'package:co_elrashid_ignite/notes.dart';
import 'package:co_elrashid_ignite/sessions/data/day/conference_day.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:flutter/material.dart';
import 'dart:core';
 import 'package:flutter/services.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
          _widgets[index] = StickyHeaderBuilder(
            builder: (context, value) {
              return Container(
                height: 0.0,
                transform: Matrix4.translationValues(0.0, 52.0, 0.0),
                child: OverflowBox(
                  minHeight: 80.0,
                  maxHeight: 80.0,
                  child: Container(
                    // color: Colors.red,
                    // color: Colors.blueGrey[700],
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _day.sessionsGroups[index].dateStr,
                          ),
                        ),
                        // Text(
                        //   // "${index + 1 < 10 ? '0' + (index + 1).toString() : index + 1}|${_day.sessionsGroups.length}",
                        //   // "${index + 1 < 10 ? '0' + (index + 1).toString() : index + 1} ",
                        //   "${value < 1.0 ? '🗓 ' + _day.day.toString() : ''}" +
                        //       // "\n ${index + 1 < 10 ? '0' + (index + 1).toString() : index + 1}" +
                        //       "\n${(0.0 < value && value > 1.0) ? '⦿ ' + (index + 1 < 10 ? '0' + (index + 1).toString() : (index + 1).toString()) : ''}" +
                        //       "\n${value < 1.0 ? '◉ ' + _day.sessionsGroups.length.toString() : ''}",

                        //   textAlign: TextAlign.center,
                        //   maxLines: 4,
                        //   style: const TextStyle(color: Colors.black54),
                        // ),
                        Text(
                          "${'🗓 ' + _day.day.toString()}" +
                              "\n${'⦿ ' + (index + 1 < 10 ? '0' + (index + 1).toString() : (index + 1).toString())}" +
                              "\n${'◉ ' + _day.sessionsGroups.length.toString()}",
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    // transform: Matrix4.translationValues(0.0, 92.0, 0.0),
                  ),
                ),
              );
            },
            content: Container(
              child: SessionGroupWidget(
                sessionGroup: _day.sessionsGroups[index],
              ),
              // transform: Matrix4.translationValues(0.0, -92.0, 0.0),
            ),
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
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  sessionGroup.dateStr,
                  style: TextStyle(
                    // color: Colors.black.withOpacity(0.8),
                    color: Colors.white,
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
          Divider()
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

class SesstionWidget extends StatefulWidget {
  final Session session;

  SesstionWidget(this.session);

  @override
  _SesstionWidgetState createState() => _SesstionWidgetState();
}

class _SesstionWidgetState extends State<SesstionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    widget.session.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
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
                LearningPathWidget(widget.session),
                LocationWidget(widget.session),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(
                            text:
                                "${widget.session.title} by ${widget.session.speakerNames[0]} from ${widget.session.speakerCompanies[0]} "));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAppx()),
                        );
                      },
                    ),
                  ],
                ),
                // for (var speakerId in session.speakerIds)
                //   Image.asset('assets/i/no-bg/$speakerId.png',
                //       color: Colors.blueGrey, colorBlendMode: BlendMode.modulate),
                // for (var speakerId in session.speakerIds)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 50),
                //     child: Container(
                //       decoration: new BoxDecoration(
                //         color: Colors.blue[500],
                //         borderRadius: new BorderRadius.all(
                //           const Radius.circular(80.0),
                //         ),
                //       ),
                //       child: Container(
                //         width: 120,
                //         child: Column(
                //           children: <Widget>[
                //             // Transform.rotate(
                //             //   angle: pi/-4,
                //             //   child: Image.asset(
                //             //     'assets/i/no-bg/$speakerId.png',
                //             //     color: Colors.blue[100],
                //             //     colorBlendMode: BlendMode.modulate,
                //             //     // fit: BoxFit.cover,
                //             //   ),
                //             // ),
                //             Image.asset(
                //               'assets/i/no-bg/$speakerId.png',
                //               color: Colors.blue[100],
                //               colorBlendMode: BlendMode.modulate,
                //               // fit: BoxFit.cover,
                //             ),
                //             // Text(
                //             //   session.speakerNames.join(),
                //             //   style: TextStyle(
                //             //     // fontSize: 12,
                //             //     color: Colors.black.withOpacity(0.6),
                //             //     fontWeight: FontWeight.bold,
                //             //   ),
                //             //   textWidthBasis: TextWidthBasis.longestLine,
                //             //   maxLines: 1,
                //             //   overflow: TextOverflow.ellipsis,
                //             // ),
                //             Text(
                //               session.speakerNames.join().replaceAll(" ", "\n"),
                //               textAlign: TextAlign.center,
                //               overflow: TextOverflow.ellipsis,
                //               softWrap: false,
                //               maxLines: 2,
                //               style: TextStyle(
                //                 // fontWeight: FontWeight.bold,
                //                 height: 1.5,
                //               ),
                //             ),
                //             Text(
                //               session.speakerNames.join().replaceAll(" ", "\n"),
                //               textAlign: TextAlign.center,
                //               overflow: TextOverflow.ellipsis,
                //               softWrap: false,
                //               maxLines: 2,
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 height: 1.5,
                //               ),
                //             ),
                //           ],
                //         ),
                //         transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                //       ),
                //     ),
                //   ),

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
          ),
          Column(
            children: <Widget>[
              for (var speakerId in widget.session.speakerIds)
                Transform.scale(
                  // scale: 1 ,
                  // scale: .75 / session.speakerIds.length,
                  scale: .75,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(80.0),
                        ),
                      ),
                      child: Container(
                        width: 120,
                        child: Column(
                          children: <Widget>[
                            // Transform.rotate(
                            //   angle: pi/-4,
                            //   child: Image.asset(
                            //     'assets/i/no-bg/$speakerId.png',
                            //     color: Colors.blue[100],
                            //     colorBlendMode: BlendMode.modulate,
                            //     // fit: BoxFit.cover,
                            //   ),
                            // ),
                            Image.asset(
                              'assets/i/no-bg/$speakerId.png',
                              color: Colors.blue[100],
                              colorBlendMode: BlendMode.modulate,
                              // fit: BoxFit.cover,
                            ),
                            // Text(
                            //   session.speakerNames.join(),
                            //   style: TextStyle(
                            //     // fontSize: 12,
                            //     color: Colors.black.withOpacity(0.6),
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   textWidthBasis: TextWidthBasis.longestLine,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            if (widget.session.speakerIds.length == 1)
                              Text(
                                widget.session.speakerNames
                                    .join()
                                    .replaceAll(" ", "\n"),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            if (widget.session.speakerIds.length == 1)
                              Text(
                                widget.session.speakerCompanies
                                    .join()
                                    .replaceAll(" ", "\n"),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
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
                ),
            ],
          )
        ],
      ),
    );
  }
}

