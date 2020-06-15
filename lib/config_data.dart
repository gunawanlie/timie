import 'package:flutter/material.dart';

import 'config.dart';

class ConfigData {

  final Color color;
  final String title;
  final Config config;
  final int minValue;
  final int maxValue;

  const ConfigData(this.color, this.title, this.config, this.minValue, this.maxValue);
}