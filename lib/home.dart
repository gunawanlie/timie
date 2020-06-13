import 'package:flutter/material.dart';
import 'placeholder.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  int _widgetIndex = 0;
  final List<Widget> _widgets = [
    PlaceholderWidget(Colors.purple),
    PlaceholderWidget(Colors.deepOrange),
  ];

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _widgets.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timie'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped, // new
        currentIndex: _widgetIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            title: Text('Pomodoro'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('HIIT'),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _widgetIndex = index;
      _tabController.animateTo(_widgetIndex);
    });
  }
}