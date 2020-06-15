import 'package:app/task_type.dart';
import 'package:flutter/material.dart';

import 'configuration.dart';
import 'config_data.dart';
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
  final List<Widget> _widgets = [
    Pomodoro(),
    IntervalTimer(),
  ];

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
          ConfigData(TaskType.task.foregroundColor, 'Focus', 'pomodoro_focus', 25, 1, 99),
          ConfigData(TaskType.shortRest.foregroundColor, 'Short Break', 'pomodoro_short_break', 5, 1, 99),
          ConfigData(TaskType.longRest.foregroundColor, 'Long Break', 'pomodoro_long_break', 15, 1, 99),
        ];
        return Configuration("Pomodoro", " m", _configs);
        break;
      case 1:
        List<ConfigData> _configs = [
          ConfigData(TaskType.task.foregroundColor, 'Exercise', 'interval_exercise', 20, 1, 99),
          ConfigData(TaskType.shortRest.foregroundColor, 'Rest', 'interval_rest', 10, 1, 99),
          ConfigData(Colors.purple, 'Sets', 'interval_sets', 8, 1, 12),
          ConfigData(TaskType.longRest.foregroundColor, 'Recovery', 'interval_recovery', 60, 1, 99),
          ConfigData(Colors.deepOrangeAccent, 'Cycles', 'interval_cycles', 3, 1, 8),
        ];
        return Configuration("Interval", " s", _configs);
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
        children: _widgets,
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