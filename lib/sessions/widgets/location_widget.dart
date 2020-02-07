import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:core';


class LocationWidget extends StatelessWidget {
  final Session session;

  LocationWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var str = session.location;
    Widget _widget;

    _widget = Container(
      decoration: new BoxDecoration(
        color: getRandomColor(locationPathKey, str),
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
