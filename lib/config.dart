import 'dart:collection';

enum Config {

  intervalExercise,
  intervalRest,
  intervalSets,
  intervalRecovery,
  intervalCycles,
  pomodoroFocus,
  pomodoroShortBreak,
  pomodoroLongBreak,
}

extension ConfigExtensions on Config {

  int get defaultValue {
    SplayTreeMap values = SplayTreeMap<int, int>();
    values[Config.intervalExercise.index] = 20;
    values[Config.intervalRest.index] = 10;
    values[Config.intervalSets.index] = 8;
    values[Config.intervalRecovery.index] = 60;
    values[Config.intervalCycles.index] = 3;
    values[Config.pomodoroFocus.index] = 25;
    values[Config.pomodoroShortBreak.index] = 5;
    values[Config.pomodoroLongBreak.index] = 15;
    return values[this.index];
  }

  String get cacheKey {
    SplayTreeMap keys = SplayTreeMap<int, String>();
    keys[Config.intervalExercise.index] = "interval_exercise";
    keys[Config.intervalRest.index] = "interval_rest";
    keys[Config.intervalSets.index] = "interval_sets";
    keys[Config.intervalRecovery.index] = "interval_recovery";
    keys[Config.intervalCycles.index] = "interval_cycles";
    keys[Config.pomodoroFocus.index] = "pomodoro_focus";
    keys[Config.pomodoroShortBreak.index] = "pomodoro_short_break";
    keys[Config.pomodoroLongBreak.index] = "pomodoro_long_break";
    return keys[this.index];
  }
}