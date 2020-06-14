import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PomodoroState();
  }
}

class _PomodoroState extends State<Pomodoro> {

  List<Widget> _progressIndicators = [];

  int taskIndex = 0;

  LinearProgressIndicator _setupProgressIndicator(int index) {
    Color backgroundColor = Color(0x660000FF);
    Color valueColor = Color(0xFF0000FF);

    if (index % 2 == 0) {
      backgroundColor = Color(0x66FF0000);
      valueColor = Color(0xFFFF0000);
    } else if (index < 7) {
      backgroundColor = Color(0x66228B22);
      valueColor = Color(0xFF228B22);
    }

    return LinearProgressIndicator(
      backgroundColor: backgroundColor,
      value: 0.5,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
    );
  }

  FlatButton _playButton = FlatButton(
    child: Row(
      children: <Widget>[
        Icon(Icons.play_arrow),
        Text("Start"),
      ],
    ),
    color: Colors.blue,
    onPressed: () {

    },
  );

  FlatButton _nextButton = FlatButton(
    child: Row(
      children: <Widget>[
        Text("Skip"),
        Icon(Icons.skip_next),
      ],
    ),
    color: Colors.blue,
    onPressed: () {

    },
  );

  List<Widget> _buttons = [];

  @override
  void initState() {
    super.initState();
    _setupProgressIndicators();
    _setupButtons();
  }

  void _setupProgressIndicators() {
    for (int i=0; i<8; i++) {
      _progressIndicators.add(Expanded(
        child: Container(
          child: _setupProgressIndicator(i),
          padding: EdgeInsets.symmetric(horizontal: 1.0),
        ),
      ));
    }
  }

  void _setupButtons() {
    _buttons.add(Container(
      child: _playButton,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
    ));
    _buttons.add(Container(
      child: _nextButton,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Column(
        children: <Widget>[
          IntrinsicWidth(
            child: Column(
              children: <Widget>[
                Text(
                  "23:59",
                  style: TextStyle(
                    fontFamily: 'Teko',
                    fontSize: 150,
                  ),
                ),
                Row(
                  children: _progressIndicators,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  children: _buttons,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    );
  }
}