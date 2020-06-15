import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'task.dart';
import 'task_list.dart';
import 'task_type.dart';

class Pomodoro extends StatefulWidget {

  _PomodoroState _state = _PomodoroState();

  @override
  State<StatefulWidget> createState() => _state;

  refreshPomodoro() {
    _state.getPomodoro().then(_state.updatePomodoro);
  }
}

class _PomodoroState extends State<Pomodoro> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  TaskList _pomodoro = TaskList(25, 5, 15, 4, 1);
  String _pomodoroTimeLabel = "";

  @override
  void initState() {
    _initAnimationController();
    _setupTask();
    getPomodoro().then(updatePomodoro);
    super.initState();
  }

  void _initAnimationController() {
    _animationController = AnimationController(
      duration: Duration(minutes: 25),
      vsync: this,
    );

    _animationController.reset();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _setupNextTask();
      }
      setState(() {
        _updatePomodoroTimerLabel();
      });
    });
  }

  Future<TaskList> getPomodoro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int focus = sharedPreferences.getInt(Config.pomodoroFocus.cacheKey) ?? Config.pomodoroFocus.defaultValue;
    int shortBreak = sharedPreferences.getInt(Config.pomodoroShortBreak.cacheKey) ?? Config.pomodoroShortBreak.defaultValue;
    int longBreak = sharedPreferences.getInt(Config.pomodoroLongBreak.cacheKey) ?? Config.pomodoroLongBreak.defaultValue;
    return TaskList(focus, shortBreak, longBreak, 4, 1);
  }

  void updatePomodoro(TaskList pomodoro) {
    setState(() {
      _pomodoro = pomodoro;
      _setupTask();
    });
  }

  void _setupNextTask() {
    _animationController.stop();
    _pomodoro.next();
    _setupTask();
  }

  void _setupTask() {
    _animationController.duration = Duration(minutes: _pomodoro.currentTaskDuration());
    _animationController.value = _animationController.lowerBound;
    _updatePomodoroTimerLabel();
  }

  void _updatePomodoroTimerLabel() {
    int duration = _pomodoro.currentTaskDuration() * 60;
    double progress = _animationController.upperBound - _animationController.value;
    int left = (progress * duration).floor();
    int minutes = (left / 60).floor();
    int seconds = left % 60;
    _pomodoroTimeLabel = "${minutes}:${seconds.toString().padLeft(2, '0')}";
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
                  children: _progressIndicators(_pomodoro),
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
                            setState(() {
                              _animationController.forward();
                            });
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
                            setState(() {
                              _animationController.stop();
                            });
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
                          setState(() {
                            _setupNextTask();
                          });
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

  List<Widget> _progressIndicators(TaskList pomodoro) {
    List<Widget> _indicators = [];

    for (int i=0; i<pomodoro.count(); i++) {
      double value = (i < pomodoro.currentTaskIndex() ? 1.0 : (i > pomodoro.currentTaskIndex() ? 0.0 : _animationController.value));

      _indicators.add(Expanded(
        child: Container(
          child: _progressIndicator(pomodoro.task(i), value),
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
}