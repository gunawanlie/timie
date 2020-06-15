import 'package:flutter/material.dart';

class ConfigData {

  final Color color;
  final String title;
  final String cacheKey;
  final int minValue;
  final int maxValue;

  const ConfigData(this.color, this.title, this.cacheKey, this.minValue, this.maxValue);
}