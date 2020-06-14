import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'task.dart';
import 'tasks.dart';
import 'task_type.dart';

class Pomodoro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PomodoroState();
  }
}

class _PomodoroState extends State<Pomodoro> with SingleTickerProviderStateMixin {

  Tasks _pomodoro = Tasks(25, 5, 15, 4, 1);
  AnimationController _animationController;
  String _pomodoroTimeLabel = "23:59";

  @override
  void initState() {
    super.initState();
    _setupAnimationController();
    _updatePomodoroTimerLabel();
  }

  List<Widget> _progressIndicators() {
    List<Widget> _indicators = [];

    for (int i=0; i<_pomodoro.count(); i++) {
      double value = (i < _pomodoro.currentTaskIndex() ? 1.0 : (i > _pomodoro.currentTaskIndex() ? 0.0 : _animationController.value));

      _indicators.add(Expanded(
        child: Container(
          child: _progressIndicator(_pomodoro.task(i), value),
          padding: EdgeInsets.symmetric(horizontal: 1.0),
        ),
      ));
    }

    return _indicators;
  }

  LinearProgressIndicator _progressIndicator(Task task, double value) {
    return LinearProgressIndicator(
      backgroundColor: task.type.backgroundColor,
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(task.type.foregroundColor),
    );
  }

  void _setupAnimationController() {
    _animationController = AnimationController(
      duration: Duration(minutes: _pomodoro.currentTaskDuration()),
      vsync: this,
    );

    _animationController.reset();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _refreshAnimatioNController();
      }
      _updatePomodoroTimerLabel();
      setState(() {});
    });
  }

  void _updatePomodoroTimerLabel() {
    int duration = _pomodoro.currentTaskDuration() * 60;
    double progress = _animationController.upperBound - _animationController.value;
    int left = (progress * duration).floor();
    int minutes = (left / 60).floor();
    int seconds = left % 60;
    _pomodoroTimeLabel = "${minutes}:${seconds.toString().padLeft(2, '0')}";
  }

  void _refreshAnimatioNController() {
    _animationController.stop();
    _pomodoro.next();
    _animationController.duration = Duration(minutes: _pomodoro.currentTaskDuration());
    _animationController.value = _animationController.lowerBound;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                  _pomodoroTimeLabel,
                  style: TextStyle(
                    fontFamily: 'Teko',
                    fontSize: 150,
                  ),
                ),
                Row(
                  children: _progressIndicators(),
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.play_arrow),
                              Text("Start"),
                            ],
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            _animationController.forward();
                            setState(() {});
                          },
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                      ),
                      visible: !_animationController.isAnimating,
                    ),
                    Visibility(
                      child: Container(
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.pause),
                              Text("Pause"),
                            ],
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            _animationController.stop();
                            setState(() {});
                          },
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                      ),
                      visible: _animationController.isAnimating,
                    ),
                    Container(
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text("Skip"),
                            Icon(Icons.skip_next),
                          ],
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          _refreshAnimatioNController();
                          setState(() {});
                        },
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                  ],
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