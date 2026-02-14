import 'package:flutter/material.dart';
import 'package:schoolconnect/Screens/DashBoard/MyClassScreen.dart';
import 'package:schoolconnect/Screens/MySubjectScreen.dart';
import 'package:schoolconnect/Screens/TeacherHomePage.dart';
import 'package:schoolconnect/constants/Mycolor.dart';

class TeacherBottomNav extends StatefulWidget {
  const TeacherBottomNav({super.key});

  @override
  State<TeacherBottomNav> createState() => _TeacherBottomNavState();
}

class _TeacherBottomNavState extends State<TeacherBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TeacherHomePage(),
    MySubjectScreen(),
    MyClassScreen(),
    AssignmentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0A1A3A),
        unselectedItemColor: Colors.grey,
        backgroundColor: MyColor.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "My Subject",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "My Class",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Assignments",
          ),
        ],
      ),
    );
  }
}
