import 'package:co_elrashid_ignite/hide_personal_information.dart';
import 'package:co_elrashid_ignite/session_notes_widget.dart';
import 'package:co_elrashid_ignite/sessions/models/models.dart';
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:co_elrashid_ignite/speaker.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/services.dart';

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
                          MaterialPageRoute(
                              builder: (context) =>
                                  SessionNotesWidget(session: widget.session)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              for (var speakerId in widget.session.speakerIds)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeakerWidget(
                                speakerId: speakerId,
                              )),
                    );
                  },
                  child: Transform.scale(
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
                              Image.asset(
                                'assets/i/no-bg/$speakerId.png',
                                color: Colors.blue[100],
                                // colorBlendMode: BlendMode.modulate,
                                //for screenshoot srcIn or srcATop for store submtion
                                // colorBlendMode: BlendMode.srcIn,
                                // colorBlendMode: BlendMode.srcATop,
                                colorBlendMode: hidePersonalInformation
                                    ? BlendMode.srcIn
                                    : BlendMode.modulate,
                              ),
                              if (widget.session.speakerIds.length == 1)
                                Text(
                                  hidePersonalInformation
                                      ? "Speaker\nName"
                                      : widget.session.speakerNames
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
                                  hidePersonalInformation
                                      ? "Speaker\nCompany"
                                      : widget.session.speakerCompanies
                                          .join()
                                          .replaceAll(" ", "\n"),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                  style: TextStyle(
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
                ),
            ],
          ),
        ],
      ),
    );
  }
}
