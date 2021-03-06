import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sheepstate.dart';
import 'wallpaperer.dart';

class MrBackground {
  static void bookAlarmCall(SheepState sheepState) {
    AndroidAlarmManager.cancel(sheepState.alarmId)
        .whenComplete(() => _scheduleAlarm(sheepState));
  }

  static void _onAlarmCall() async {
    await SharedPreferences.getInstance().then((sharedPreferences) async {
      await sharedPreferences.reload().then((_) {
        var sheepState = SheepState.from(sharedPreferences);
        sheepState.log("Alarm fired", "Isn't that nice?");
        Wallpaperer.changeWallpaper(
            700, //MediaQuery.of(context).size.width,
            700, //MediaQuery.of(context).size.height,
            sheepState,
            () => bookAlarmCall(sheepState));

        sheepState.log(
            "Alarm scheduled.", "Will do a sanity check in 1 minute.");

        monitorAlarmState(sheepState, 5);
      });
    });
  }

  static void monitorAlarmState(SheepState sheepState, int retries) {
    if (retries == 0) {
      sheepState.log("Alarm checking abandoned.", "Too many retries.");
    }

    Future.delayed(Duration(minutes: 1), () {
      if (sheepState.nextChangeIsInThePast()) {
        sheepState.log("Alarm update missing ($retries).",
            "Alarm ${sheepState.nextChangeText} is in the past");
        monitorAlarmState(sheepState, retries - 1);
      } else {
        sheepState.log("Alarm is good.", "Scheduled for future, which is good");
      }
    });
  }

  static void _scheduleAlarm(SheepState sheepState) async {
    int count = sheepState.timeValue.value;
    Duration duration = sheepState.timeUnit.duration;
    DateTime target = DateTime.now().add(duration * count);

    print("Alarm target: $target");

    // has been observed to throw error with message: 'Attempted to start a duplicate background isolate'

    await AndroidAlarmManager.oneShotAt(
            target, sheepState.alarmId, _onAlarmCall,
            alarmClock: true,
            exact: true,
            wakeup: true,
            allowWhileIdle: true,
            rescheduleOnReboot: true)
        .then((wasScheduledOk) {
      if (wasScheduledOk) {
        sheepState.setNextChangeTimestamp(target);
        sheepState.log('Scheduled a wakeup call',
            'Alarm set for ${sheepState.nextChangeText}');
      } else {
        sheepState.log(
            'Failed to schedule a wakeup call', 'Because of reasons.');
      }
      return wasScheduledOk;
    }).catchError((e) {
      sheepState.log('Failed to schedule alarm', '${e.toString()}');
      sheepState.clearNextChangeTimestamp();
      return false;
    });
  }
}
