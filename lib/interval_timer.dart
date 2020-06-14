import 'package:flutter/material.dart';

import 'task.dart';
import 'tasks.dart';
import 'task_type.dart';

class IntervalTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntervalTimerState();
  }
}

class _IntervalTimerState extends State<IntervalTimer> with SingleTickerProviderStateMixin {

  Tasks _interval = Tasks(30, 10, 30, 6, 4);
  AnimationController _animationController;
  String _timerLabel = "88";

  @override
  void initState() {
    super.initState();
    _setupAnimationController();
    _updateTimerLabel();
  }

  void _setupAnimationController() {
    _animationController = AnimationController(
      duration: Duration(seconds: _interval.currentTaskDuration()),
      vsync: this,
    );

    _animationController.reset();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _refreshAnimatioNController();
        if (_interval.currentTaskIndex() != 0) {
          _animationController.forward();
        }
      }
      _updateTimerLabel();
      setState(() {});
    });
  }

  void _updateTimerLabel() {
    int duration = _interval.currentTaskDuration();
    double progress = _animationController.upperBound - _animationController.value;
    int left = (progress * duration + 0.20).floor();
    _timerLabel = "$left";
  }

  void _refreshAnimatioNController() {
    _animationController.stop();
    _interval.next();
    _animationController.duration = Duration(seconds: _interval.currentTaskDuration());
    _animationController.value = _animationController.lowerBound;
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
                      if (_interval.currentTaskIndex() != 0) {
                        _animationController.forward();
                      }
                      setState(() {});
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