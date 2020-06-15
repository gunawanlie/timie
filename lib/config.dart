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
    switch (this) {
      case Config.intervalExercise:
        return 20;
        break;
      case Config.intervalRest:
        return 10;
        break;
      case Config.intervalSets:
        return 8;
        break;
      case Config.intervalRecovery:
        return 60;
        break;
      case Config.intervalCycles:
        return 3;
        break;
      case Config.pomodoroFocus:
        return 25;
        break;
      case Config.pomodoroShortBreak:
        return 5;
        break;
      case Config.pomodoroLongBreak:
        return 15;
        break;
    }
    return null;
  }

  String get cacheKey {
    switch (this) {
      case Config.intervalExercise:
        return "interval_exercise";
        break;
      case Config.intervalRest:
        return "interval_rest";
        break;
      case Config.intervalSets:
        return "interval_sets";
        break;
      case Config.intervalRecovery:
        return "interval_recovery";
        break;
      case Config.intervalCycles:
        return "interval_cycles";
        break;
      case Config.pomodoroFocus:
        return "pomodoro_focus";
        break;
      case Config.pomodoroShortBreak:
        return "pomodoro_short_break";
        break;
      case Config.pomodoroLongBreak:
        return "pomodoro_long_break";
        break;
    }
    return null;
  }
}