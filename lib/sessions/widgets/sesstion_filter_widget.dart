import 'package:co_elrashid_ignite/sessions/utilities/utilities.dart';
import 'package:flutter/material.dart';

List<String> _filters = <String>[];

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
