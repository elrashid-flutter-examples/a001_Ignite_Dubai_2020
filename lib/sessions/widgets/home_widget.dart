
import 'package:co_elrashid_ignite/sessions/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
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
