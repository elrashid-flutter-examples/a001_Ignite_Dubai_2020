import 'package:co_elrashid_ignite/learning_path.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class LearningPathWidget extends StatelessWidget {
  final Session session;

  LearningPathWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var str = session.learningPath.length > 0 ? session.learningPath : "Genral";
    Widget _widget;
    _widget = InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LearningPathSessionsWidget(
                    learningPath: session.learningPath,
                  )),
        );
      },
      child: Container(
        decoration: new BoxDecoration(
          color: getRandomColor(learningPathKey, str),
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
      ),
    );
    return _widget;
  }
}
