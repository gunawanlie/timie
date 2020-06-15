import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'task_config.dart';

class Configuration extends StatefulWidget {

  final Function() _notification;
  String _title;
  String _timeSymbol;
  List<TaskConfig> _taskConfigs;

  Configuration(this._notification, this._title, this._timeSymbol, this._taskConfigs);

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationState(_notification, _title, _timeSymbol, _taskConfigs);
  }
}

class _ConfigurationState extends State<Configuration> {

  final Function() _notification;
  String _title;
  String _timeSymbol;
  List<TaskConfig> _taskConfigs;

  _ConfigurationState(this._notification, this._title, this._timeSymbol, this._taskConfigs);

  List<Widget> _configurationWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < _taskConfigs.length; i++) {
      TaskConfig taskConfig = _taskConfigs[i];

      widgets.add(
        Padding(
          child: Row(
            children: <Widget>[
              SizedBox(
                child: Container(
                  color: taskConfig.color,
                ),
                height: 30,
                width: 10,
              ),
              Expanded(
                child: Padding(
                  child: Text(taskConfig.title),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                ),
              ),
              SizedBox(
                child: RawMaterialButton(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 15,
                  ),
                  elevation: 2,
                  fillColor: Colors.blue,
                  onPressed: () {
                    _updateValue(taskConfig, -1);
                  },
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
              FutureBuilder(
                future: _cacheValue(taskConfig),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      child: Text(
                        "${snapshot.data}$_timeSymbol",
                        style: TextStyle(
                          fontFamily: 'Teko',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      width: 50,
                    );
                  }

                  return SizedBox(
                    width: 50,
                  );
                },
              ),
              SizedBox(
                child: RawMaterialButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                  elevation: 2,
                  fillColor: Colors.blue,
                  onPressed: () {
                    _updateValue(taskConfig, 1);
                  },
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          padding: EdgeInsets.only(top: 20.0)),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Padding(
        child: Column(
          children: _configurationWidgets(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
    );
  }

  Future<int> _cacheValue(TaskConfig taskConfig) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(taskConfig.config.cacheKey) ?? taskConfig.config.defaultValue;
  }

  void _updateValue(TaskConfig taskConfig, int adjustment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int value = sharedPreferences.getInt(taskConfig.config.cacheKey) ?? taskConfig.config.defaultValue;
    int newValue = min(taskConfig.maxValue, max(taskConfig.minValue, value + adjustment));
    await sharedPreferences.setInt(taskConfig.config.cacheKey, newValue);
    _notification();
    setState(() {});
  }
}
