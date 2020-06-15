import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/config_data.dart';

class Configuration extends StatefulWidget {
  String _title;
  String _timeSymbol;
  List<ConfigData> _data;

  Configuration(this._title, this._timeSymbol, this._data);

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationState(_title, _timeSymbol, _data);
  }
}

class _ConfigurationState extends State<Configuration> {

  String _title;
  String _timeSymbol;
  List<ConfigData> _data;

  _ConfigurationState(this._title, this._timeSymbol, this._data);

  List<Widget> _configurationWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < _data.length; i++) {
      ConfigData d = _data[i];

      widgets.add(
        Padding(
          child: Row(
            children: <Widget>[
              SizedBox(
                child: Container(
                  color: d.color,
                ),
                height: 30,
                width: 10,
              ),
              Expanded(
                child: Padding(
                  child: Text(d.title),
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
                    _updateValue(d, -1);
                  },
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
              FutureBuilder(
                future: _cacheValue(d),
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
                    _updateValue(d, 1);
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

  Future<int> _cacheValue(ConfigData config) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(config.cacheKey) ?? config.defaultValue;
  }

  void _updateValue(ConfigData config, int adjustment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int value = sharedPreferences.getInt(config.cacheKey) ?? config.defaultValue;
    int newValue = min(config.maxValue, max(config.minValue, value + adjustment));
    await sharedPreferences.setInt(config.cacheKey, newValue);
    setState(() {});
  }
}
