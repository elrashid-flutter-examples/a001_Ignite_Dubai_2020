import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SessionCoverWidget extends StatelessWidget {
  SessionCoverWidget(this.session);

  final Session session;
  @override
  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(session.startDateTime);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          session.dateStr,
                        ),
                        Text(
                          "${date.day}/${date.month < 10 ? '0' + date.month.toString() : date.month.toString()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SesstionWidget(session),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ],
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
