import 'package:flutter/material.dart';

import 'config.dart';

class TaskConfig {

  final Color color;
  final String title;
  final Config config;
  final int minValue;
  final int maxValue;

  const TaskConfig(this.color, this.title, this.config, this.minValue, this.maxValue);
}