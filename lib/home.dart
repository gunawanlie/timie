import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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