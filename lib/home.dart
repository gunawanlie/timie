import 'package:app/task_type.dart';
import 'package:flutter/material.dart';

import 'configuration.dart';
import 'config_data.dart';
import 'config.dart';
import 'interval_timer.dart';
import 'pomodoro.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  PageController _pageController = PageController();

  int _widgetIndex = 0;
  Pomodoro _pomodoro = Pomodoro();
  IntervalTimer _intervalTimer = IntervalTimer();

  final List<BottomNavigationBarItem> _navigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.access_alarm),
      title: Text("Pomodoro")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.timer),
      title: Text("Interval")
    ),
  ];

  Configuration _configuration() {
    switch (_widgetIndex) {
      case 0:
        List<ConfigData> _configs = [
          ConfigData(TaskType.task.foregroundColor, 'Focus', Config.pomodoroFocus, 1, 99),
          ConfigData(TaskType.shortRest.foregroundColor, 'Short Break', Config.pomodoroShortBreak, 1, 99),
          ConfigData(TaskType.longRest.foregroundColor, 'Long Break', Config.pomodoroLongBreak, 1, 99),
        ];
        return Configuration(_pomodoro.refreshPomodoro, "Pomodoro", " m", _configs);
        break;
      case 1:
        List<ConfigData> _configs = [
          ConfigData(TaskType.task.foregroundColor, 'Exercise', Config.intervalExercise, 1, 99),
          ConfigData(TaskType.shortRest.foregroundColor, 'Rest', Config.intervalRest, 1, 99),
          ConfigData(Colors.purple, 'Sets', Config.intervalSets, 1, 12),
          ConfigData(TaskType.longRest.foregroundColor, 'Recovery', Config.intervalRecovery, 1, 99),
          ConfigData(Colors.deepOrangeAccent, 'Cycles', Config.intervalCycles, 1, 8),
        ];
        return Configuration(_intervalTimer.refreshInterval, "Interval", " s", _configs);
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _configuration(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
        title: Text('Timie'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            this._widgetIndex = index;
          });
        },
        children: [
          _pomodoro,
          _intervalTimer,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _widgetIndex,
        items: _navigationBarItems,
        onTap: _bottomNavigationBarOnTapped,
      ),
    );
  }

  void _bottomNavigationBarOnTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}