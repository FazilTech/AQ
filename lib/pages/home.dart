import 'package:aq/components/bottom_navigation_bar.dart';
import 'package:aq/pages/community_page.dart';
import 'package:aq/pages/flash_page.dart';
import 'package:aq/pages/home_page.dart';
import 'package:aq/pages/homee_page.dart';
import 'package:aq/pages/profile_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int _selectedIndex = 0;

  void navigationBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeePage(),
    const FlashPage(),
    const CommunityPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index)=> navigationBottomBar(index),
      ),
      body: _pages[_selectedIndex]
    );
  }
}