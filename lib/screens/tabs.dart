import 'package:flutter/material.dart';

import 'package:playmingle/screens/homepage2.dart';
import 'package:playmingle/screens/sports.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen(this.mail,{super.key});

  final String mail;

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen2(widget.mail);
    var activePageTitle = 'User Details';

    if (_selectedPageIndex == 1) {
      activePage = SportsScreen(mail: widget.mail);
      activePageTitle = ' ';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: ' ',
          ),
        ],
      ),
    );
  }
}