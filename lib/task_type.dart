import 'dart:collection';

import 'package:flutter/material.dart';

enum TaskType {

  task,
  shortRest,
  longRest,
}

extension TaskTypeExtensions on TaskType {

  Color get backgroundColor {
    SplayTreeMap colors = SplayTreeMap<int, Color>();
    colors[TaskType.task.index] = Color(0x66FF0000);
    colors[TaskType.shortRest.index] = Color(0x66228B22);
    colors[TaskType.longRest.index] = Color(0x660000FF);
    return colors[this.index];
  }

  Color get foregroundColor {
    SplayTreeMap colors = SplayTreeMap<int, Color>();
    colors[TaskType.task.index] = Color(0xFFFF0000);
    colors[TaskType.shortRest.index] = Color(0xFF228B22);
    colors[TaskType.longRest.index] = Color(0xFF0000FF);
    return colors[this.index];
  }
}