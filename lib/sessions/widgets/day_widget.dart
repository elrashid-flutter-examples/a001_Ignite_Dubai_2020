import 'package:co_elrashid_ignite/sessions/data/day/conference_day.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/utilities/utilities.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
      // floatingActionButton: _floatingActionButtonWidget(),
    );
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
                filters: getFilters(),
                notifyParent: refresh,
              );
            });
      },
      child: IconButton(
        icon: Icon(
          Icons.filter_list,
        ),
        onPressed: null,
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
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _day.sessionsGroups[index].dateStr,
                          ),
                        ),
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
                  ),
                ),
              );
            },
            content: Container(
              child: SessionGroupWidget(
                sessionGroup: _day.sessionsGroups[index],
              ),
            ),
          );
        }
        return _widgets[index];
      },
    );
  }
}
