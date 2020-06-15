import 'package:flutter/material.dart';

import 'package:app/config_data.dart';

class Configuration extends StatefulWidget {
  List<ConfigData> _data = [];

  Configuration() {
    _data.add(ConfigData(Colors.red, 'Work Out', 'work_out', 1, 99));
    _data.add(ConfigData(Colors.blue, 'Rest', 'rest', 1, 99));
    _data.add(ConfigData(Colors.green, 'Long Rest', 'long_rest', 1, 99));
  }

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationState(_data);
  }
}

class _ConfigurationState extends State<Configuration> {

  List<ConfigData> _data;

  _ConfigurationState(this._data);

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
                  onPressed: () {},
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
              SizedBox(
                child: Text(
                  "88",
                  style: TextStyle(
                    fontFamily: 'Teko',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: 50,
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
                  onPressed: () {},
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
    return Container(
      child: Padding(
        child: Column(
          children: _configurationWidgets(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      color: Colors.white70,
    );
  }
}
