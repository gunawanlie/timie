import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'task.dart';
import 'tasks.dart';
import 'task_type.dart';

class IntervalTimer extends StatefulWidget {

  _IntervalTimerState _state = _IntervalTimerState();

  @override
  State<StatefulWidget> createState() => _state;

  refreshInterval() {
    _state.getInterval().then(_state.updateInterval);
  }
}

class _IntervalTimerState extends State<IntervalTimer> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Tasks _interval = Tasks(20, 10, 60, 6, 3);
  String _timerLabel = "";

  @override
  void initState() {
    _initAnimationController();
    _setupTask();
    getInterval().then(updateInterval);
    super.initState();
  }

  void _initAnimationController() {
    _animationController = AnimationController(
      duration: Duration(seconds: _interval.currentTaskDuration()),
      vsync: this,
    );

    _animationController.reset();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _setupNextTask();
        if (_interval.currentTaskIndex() != 0) {
          _animationController.forward();
        }
      }
      setState(() {
        _updateTimerLabel();
      });
    });
  }

  Future<Tasks> getInterval() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int exercise = sharedPreferences.getInt(Config.intervalExercise.cacheKey) ?? Config.intervalExercise.defaultValue;
    int rest = sharedPreferences.getInt(Config.intervalRest.cacheKey) ?? Config.intervalRest.defaultValue;
    int recovery = sharedPreferences.getInt(Config.intervalRecovery.cacheKey) ?? Config.intervalRecovery.defaultValue;
    int sets = sharedPreferences.getInt(Config.intervalSets.cacheKey) ?? Config.intervalSets.defaultValue;
    int cycles = sharedPreferences.getInt(Config.intervalCycles.cacheKey) ?? Config.intervalCycles.defaultValue;
    return Tasks(exercise, rest, recovery, sets, cycles);
  }

  void updateInterval(Tasks interval) {
    setState(() {
      _interval = interval;
      _setupTask();
    });
  }

  void _setupNextTask() {
    _animationController.stop();
    _interval.next();
    _setupTask();
  }

  void _setupTask() {
    _animationController.duration = Duration(seconds: _interval.currentTaskDuration());
    _animationController.value = _animationController.lowerBound;
    _updateTimerLabel();
  }

  void _updateTimerLabel() {
    int duration = _interval.currentTaskDuration();
    double progress = _animationController.upperBound - _animationController.value;
    int left = (progress * duration + 0.20).floor();
    _timerLabel = "$left";
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> _circularProgressIndicators() {
    Task currentTask = _interval.task(_interval.currentTaskIndex());
    Color currentTaskColor = currentTask.type.foregroundColor;
    double currentTaskValue = _animationController.upperBound - _animationController.value;

    int nextTaskIndex = (_interval.currentTaskIndex() + 1) % _interval.count();
    Task nextTask = _interval.task(nextTaskIndex);
    Color nextTaskColor = nextTask.type.backgroundColor;

    int lastTaskIndex = _interval.count() - 1;
    Task lastTask = _interval.task(lastTaskIndex);
    Color lastTaskColor = lastTask.type.backgroundColor;
    Color thirdRingColor = _interval.currentTaskIndex() == _interval.count() - 3 ? lastTaskColor : Colors.black12;

    List<Widget> widgets = [
      Container(
        child: Text(
          _timerLabel,
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 150,
          ),
        ),
        padding: EdgeInsets.only(top: 20),
      ),
      SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 20.0,
          value: currentTaskValue,
          valueColor: AlwaysStoppedAnimation<Color>(currentTaskColor),
        ),
        height: 300,
        width: 300,
      ),
      Visibility(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 20.0,
            value: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>(nextTaskColor),
          ),
          height: 250,
          width: 250,
        ),
        visible: nextTaskIndex > _interval.currentTaskIndex(),
      ),
      Visibility(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 20.0,
            value: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>(thirdRingColor),
          ),
          height: 200,
          width: 200,
        ),
        visible: _interval.count() - _interval.currentTaskIndex() > 2,
      ),
    ];

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: _circularProgressIndicators(),
          ),
          Container(
            child: Row(
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
                        if (_interval.currentTaskIndex() != 0) {
                          _animationController.forward();
                        }
                      });
                    },
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            padding: EdgeInsets.only(top: 20.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      color: Colors.white70,
    );
  }
}