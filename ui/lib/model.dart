import 'sheepstate.dart';

class ListyEnum {
  const ListyEnum();

  static Iterable<ListyEnum> iterable() {
    return [];
  }

  static ListyEnum from(String label) {
    return ListyEnum();
  }

  String label() {
    return "";
  }
}

class TimeValue implements ListyEnum {
  final int value;

  const TimeValue(this.value);

  static const ONE = TimeValue(1);
  static const TWO = TimeValue(2);
  static const THREE = TimeValue(3);
  static const FOUR = TimeValue(4);
  static const FIVE = TimeValue(5);
  static const TEN = TimeValue(10);
  static const TWENTY = TimeValue(20);
  static const ONE_HUNDRED = TimeValue(100);

  static var labelMap = {
    TimeValue.ONE: '1',
    TimeValue.TWO: '2',
    TimeValue.THREE: '3',
    TimeValue.FOUR: '4',
    TimeValue.FIVE: '5',
    TimeValue.TEN: '10',
    TimeValue.TWENTY: '20',
    TimeValue.ONE_HUNDRED: '100',
  };

  static var valueMap = {
    TimeValue.ONE: 1,
    TimeValue.TWO: 2,
    TimeValue.THREE: 3,
    TimeValue.FOUR: 4,
    TimeValue.FIVE: 5,
    TimeValue.TEN: 10,
    TimeValue.TWENTY: 20,
    TimeValue.ONE_HUNDRED: 100
  };

  static Iterable<TimeValue> iterable() {
    return labelMap.keys;
  }

  static TimeValue from(String? label) {
    return valueMap.keys.firstWhere((k) => labelMap[k] == label);
  }

  String label() {
    return labelMap[this]!;
  }
}

class TimeUnit implements ListyEnum {
  final Duration duration;

  const TimeUnit(this.duration);

  static const SECONDS = TimeUnit(Duration(seconds: 1));
  static const MINUTES = TimeUnit(Duration(minutes: 1));
  static const HOURS = TimeUnit(Duration(hours: 1));
  static const DAYS = TimeUnit(Duration(days: 1));
  static const WEEKS = TimeUnit(Duration(days: 7));

  static const _partialLabelMap = {
    TimeUnit.MINUTES: 'minutes',
    TimeUnit.HOURS: 'hours',
    TimeUnit.DAYS: 'days',
    TimeUnit.WEEKS: 'weeks',
  };
  static const _fullLabelMap = {
    TimeUnit.SECONDS: 'secs',
    TimeUnit.MINUTES: 'minutes',
    TimeUnit.HOURS: 'hours',
    TimeUnit.DAYS: 'days',
    TimeUnit.WEEKS: 'weeks',
  };

  static const durationMap = {
    TimeUnit.SECONDS: Duration(seconds: 1),
    TimeUnit.MINUTES: Duration(minutes: 1),
    TimeUnit.HOURS: Duration(hours: 1),
    TimeUnit.DAYS: Duration(days: 1),
    TimeUnit.WEEKS: Duration(days: 7),
  };

  static Iterable<TimeUnit> iterable() {
    return SheepState.ALLOW_SECONDS
        ? _fullLabelMap.keys
        : _partialLabelMap.keys;
  }

  static TimeUnit from(String? label) {
    return _fullLabelMap.keys.firstWhere((k) => _fullLabelMap[k] == label,
        orElse: () => TimeUnit.DAYS);
  }

  String label() {
    return _fullLabelMap[this]!;
  }
}

class Destination implements ListyEnum {
  final String destination;

  const Destination(this.destination);

  static const HOME = Destination('Home screen');
  static const LOCK = Destination('Lock screen');
  static const BOTH_TOGETHER = Destination('Both together');
  static const BOTH_SEPARATE = Destination('Both separately');

  static const labelMap = {
    Destination.HOME: 'Home screen',
    Destination.LOCK: 'Lock screen',
    Destination.BOTH_TOGETHER: 'Both together',
    Destination.BOTH_SEPARATE: 'Both separately',
  };

  // map to the native android codes
  static const locationMap = {
    Destination.HOME: 1,
    Destination.LOCK: 2,
    Destination.BOTH_TOGETHER: 3,
  };

  static Iterable<Destination> iterable() {
    return labelMap.keys;
  }

  static Destination from(String label) {
    return labelMap.keys.firstWhere((k) => labelMap[k] == label);
  }

  String label() {
    return labelMap[this]!;
  }

  int location() {
    return locationMap[this]!;
  }
}
