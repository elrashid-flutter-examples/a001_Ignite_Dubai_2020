import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                var url1 = "https://twitter.com/ElrashidCo";
                var url2 =
                    "https://gist.github.com/Elrashid/208e79c7b257ff98c7d2bdad2e525fd5";
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("By $url1")),
                                    IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(
                                            new ClipboardData(text: url1));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.open_in_browser),
                                      onPressed: () async {
                                        if (await canLaunch(url1)) {
                                          await launch(url1);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text("Privacy Policy $url2")),
                                    IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(
                                            new ClipboardData(text: url2));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.open_in_browser),
                                      onPressed: () async {
                                        if (await canLaunch(url2)) {
                                          await launch(url2);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
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
    );
  }
}
