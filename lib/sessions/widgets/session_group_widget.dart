
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
