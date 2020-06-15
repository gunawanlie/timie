import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'config_data.dart';

class Configuration extends StatefulWidget {

  final Function() _notification;
  String _title;
  String _timeSymbol;
  List<ConfigData> _configsData;

  Configuration(this._notification, this._title, this._timeSymbol, this._configsData);

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationState(_notification, _title, _timeSymbol, _configsData);
  }
}

class _ConfigurationState extends State<Configuration> {

  final Function() _notification;
  String _title;
  String _timeSymbol;
  List<ConfigData> _configsData;

  _ConfigurationState(this._notification, this._title, this._timeSymbol, this._configsData);

  List<Widget> _configurationWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < _configsData.length; i++) {
      ConfigData configData = _configsData[i];

      widgets.add(
        Padding(
          child: Row(
            children: <Widget>[
              SizedBox(
                child: Container(
                  color: configData.color,
                ),
                height: 30,
                width: 10,
              ),
              Expanded(
                child: Padding(
                  child: Text(configData.title),
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
                    _updateValue(configData, -1);
                  },
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
              FutureBuilder(
                future: _cacheValue(configData),
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
                    _updateValue(configData, 1);
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

  Future<int> _cacheValue(ConfigData configData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(configData.config.cacheKey) ?? configData.config.defaultValue;
  }

  void _updateValue(ConfigData configData, int adjustment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int value = sharedPreferences.getInt(configData.config.cacheKey) ?? configData.config.defaultValue;
    int newValue = min(configData.maxValue, max(configData.minValue, value + adjustment));
    await sharedPreferences.setInt(configData.config.cacheKey, newValue);
    _notification();
    setState(() {});
  }
}
