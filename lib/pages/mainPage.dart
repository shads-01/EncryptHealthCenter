// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eh/pages/myAppointments.dart';
import 'package:flutter/material.dart';
import 'package:eh/pages/homePage.dart';
import 'package:eh/pages/searchPage.dart';
import 'package:eh/pages/userProfile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  final List _pages = [
    HomePage(),
    SearchPage(),
    MyAppointments(),
    UserProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.2),
            ),
          ],
        ),
        child: Container(
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Color.fromARGB(255, 138, 201, 250),
            selectedIndex: currentPageIndex,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_filled),
                label: 'Home',
                tooltip: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
                tooltip: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Appointments',
                tooltip: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
                tooltip: '',
              ),
            ],
          ),
        ),
      ),
      body: _pages[currentPageIndex],
    );
  }
}
