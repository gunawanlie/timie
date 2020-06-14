import 'package:flutter/material.dart';

enum TaskType {
  task,
  shortRest,
  longRest,
}

extension TaskTypeExtensions on TaskType {

  Color get backgroundColor {
    switch (this) {
      case TaskType.task:
        return Color(0x66FF0000);
        break;
      case TaskType.shortRest:
        return Color(0x66228B22);
        break;
      case TaskType.longRest:
        return Color(0x660000FF);
        break;
    }
    return null;
  }

  Color get foregroundColor {
    switch (this) {
      case TaskType.task:
        return Color(0xFFFF0000);
        break;
      case TaskType.shortRest:
        return Color(0xFF228B22);
        break;
      case TaskType.longRest:
        return Color(0xFF0000FF);
        break;
    }
    return null;
  }
}