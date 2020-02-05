
import 'package:co_elrashid_ignite/sessions/models/session.dart';

class SessionGroup {
  String startDateTime;
  String endDateTime;
  SessionGroup(
    this.startDateTime,
    this.endDateTime,
  );

  String get dateStr {
    var _startDateLocal = DateTime.parse(startDateTime).toLocal();
    var _endDateLocal = DateTime.parse(endDateTime).toLocal();

    var _dateStr2 =
        "${_formatTime(_startDateLocal)}\n${_formatTime(_endDateLocal)}";
    var _dateStr = "${_formatTime(_startDateLocal)}";

    return _dateStr;
  }

  String _formatTime(DateTime time) {
    return "${_formatNumber(time.hour)}:${_formatNumber(time.minute)}";
  }

  String _formatNumber(int _number) {
    String _numberStr;
    if (_number < 10) {
      _numberStr = "0${_number}";
    } else {
      _numberStr = "${_number}";
    }
    return _numberStr;
  }

  List<Session> sessions;

  @override
  bool operator ==(other) {
    // Dart ensures that operator== isn't called with null
    if (other == null) {
      return false;
    }
    if (other is! SessionGroup) {
      return false;
    }
    return (startDateTime == (other as SessionGroup).startDateTime) &&
        (endDateTime == (other as SessionGroup).endDateTime);
  }

  int _hashCode;
  @override
  int get hashCode {
    if (_hashCode == null) {
      _hashCode = (startDateTime + endDateTime).hashCode;
    }
    return _hashCode;
  }
}
